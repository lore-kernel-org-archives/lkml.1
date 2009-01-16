Return-Path: <linux-kernel-owner+w=401wt.eu-S934231AbZAPAtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbZAPAtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZAPAsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:48:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63497 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZAPAsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:48:35 -0500
Date: Thu, 15 Jan 2009 19:48:33 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ftrace: add stack trace to function tracer
In-Reply-To: <20090116004121.302184848@goodmis.org>
Message-ID: <alpine.DEB.1.10.0901151946140.18861@gandalf.stny.rr.com>
References: <20090116004050.273665842@goodmis.org> <20090116004121.302184848@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Jan 2009, Steven Rostedt wrote:
> 
> Produces the following in /debug/tracing/trace:
> 
>        kjournald-702   [001]   135.673060: io_schedule <-sync_buffer
>        kjournald-702   [002]   135.673671:
>  <= sync_buffer
>  <= __wait_on_bit
>  <= out_of_line_wait_on_bit
>  <= __wait_on_buffer
>  <= sync_dirty_buffer
>  <= journal_commit_transaction
>  <= kjournald

Note, the above is from two different CPUS. This is because I did not want 
to messy up the current function trace with more branches. I took the easy 
way out. I simply registered another tracer to the function tracer to dump 
out the trace.

I have an idea how to fix it. I'll work on a solution now.

-- Steve

