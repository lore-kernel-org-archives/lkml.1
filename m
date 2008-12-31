Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYLaTGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYLaTGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbYLaTG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:06:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbYLaTG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:06:28 -0500
Date: Wed, 31 Dec 2008 14:06:26 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
In-Reply-To: <20081231205708.4ee8b141@iki.fi>
Message-ID: <alpine.DEB.1.10.0812311401120.6750@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi>
 <alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com> <20081220041759.5a026f5a@daedalus.pq.iki.fi> <alpine.DEB.1.10.0812192140350.29275@gandalf.stny.rr.com> <20081231155325.392699d0@iki.fi> <alpine.DEB.1.10.0812311332410.6262@gandalf.stny.rr.com>
 <20081231205708.4ee8b141@iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 31 Dec 2008, Pekka Paalanen wrote:

> > 
> > Since this really only enables or disables the ring buffer, perhaps 
> > "ringbuffer_enabled" is the way to go?
> 
> As a C-function or as a debugfs file?

I was thinking of only changing the debugfs file.

> Are we controlling an action (recording events), a feature (a buffer
> where to record) or an implementation (a ring buffer)?

Good point. It only disables the recording, so perhaps a "record_enabled" 
would be better?

> Does the user know or care if it is a ring buffer or just whatever
> temporary storage?

Yeah, the user does not know or care what the implementation is.

> What does the user actually want to control? A buffer? A ring
> buffer? Recording stuff? The tracer? Tracing? Data flow?
> Assuming there are also other users than tracing, does it make
> sense to control the ring buffer facility itself?

I think the name record_enabled for debugfs is the best. This is exactly 
what happens (not how it is implemented). When someone echos 0 to 
record_enabled (currently called tracing_on), it stops the recording, and 
nothing else. The tracers still try to write to the buffer, but the write 
always fails. This does not disable the tracers or even notify the tracer 
that the buffers have stopped recording. This is just a simple light 
weight way to stop and start recording to the trace buffers from either 
user space or kernel space.  Kernel space can stop it, and user space can 
start it again (that was the original request for this feature).

I'm leaning towards record_enabled now.

> 
> I'm sure we could discuss this forever, so I'll just say:
> Happy new year! :-)

I still have 10 more hours, but who cares? ;-)

Happy New Year to you too!

-- Steve

