Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZANVnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZANVnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZANVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:42:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760874AbZANVmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:42:52 -0500
Date: Wed, 14 Jan 2009 16:42:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-graph-tracer: fix a regression while
 suspend to disk
In-Reply-To: <496e5a27.1438560a.4923.ffffb67a@mx.google.com>
Message-ID: <alpine.DEB.1.10.0901141642290.30879@gandalf.stny.rr.com>
References: <496e5a27.1438560a.4923.ffffb67a@mx.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Jan 2009, Frederic Weisbecker wrote:

> Impact: fix a crash while kernel image restore
> 
> When the function graph tracer is running and while suspend to disk, some racy
> and dangerous things happen against this tracer.
> 
> The current task will save its registers including the stack pointer which
> contains the return address hooked by the tracer. But the current task will
> continue to enter other functions after that to save the memory, and then
> it will store other return addresses, and finally loose the old depth which
> matches the return address saved in the old stack (during the registers saving).
> 
> So on image restore, the code will return to wrong addresses.
> And there are other things: on restore, the task will have it's "current"
> pointer overwritten during registers restoring....switching from one task to
> another... That would be insane to try to trace function graphs at these
> stages.
> 
> This patch makes the function graph tracer listening on power events, making
> it's tracing disabled for the current task (the one that performs the hibernation work)
> while suspend/resume to disk, making the tracing safe during hibernation.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks, Frederic, I'll apply it and pass it on.

-- Steve

