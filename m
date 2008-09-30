Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYI3MqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYI3MqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYI3Mpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:45:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYI3Mpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:45:53 -0400
Date: Tue, 30 Sep 2008 08:45:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new
 type of print_line
In-Reply-To: <c62985530809300539o2842c14fk16708abaf69c4e2f@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809300844270.1984@gandalf.stny.rr.com>
References: <48E11E1E.7010001@gmail.com>  <20080929221934.260306dd@daedalus.pq.iki.fi>  <20080930085241.GB10374@elte.hu> <c62985530809300539o2842c14fk16708abaf69c4e2f@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Fr?d?ric Weisbecker wrote:
> 
> Thanks Ingo.
> 
> I'm currently testing tip/master, since tracing/pipe is merged into.
> It seems there are some locking issues that I hadn't when I tested the patches.
> Perhaps it's because of the merge with the new ring buffer.
> 
> I just launched the sched_switch tracer and it worked well until 4
> seconds of execution. And after that it blocked.
> I tested too a marker message adding and it is never displayed. Worse:
> I can't break the pipe with Ctrl + C after that.
> 
> When I will have some time, I will try to debug all what I find.
> 

OK, I'll nuke the ring_buffer_lock :-/

The trace_pipe calls that and then calls print_trace_line which will 
eventually lock the buffer again. This is a bug on my part. I'll fix that 
today.

Thanks,

-- Steve

