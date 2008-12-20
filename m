Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbYLTC4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbYLTC4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 21:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYLTC4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 21:56:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50127 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYLTC4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 21:56:46 -0500
Date: Fri, 19 Dec 2008 21:56:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
In-Reply-To: <20081220043210.40758f36@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0812192148210.29275@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi> <20081219225717.GK13409@elte.hu>
 <alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com> <20081219233443.GC17984@elte.hu> <alpine.DEB.1.10.0812191912280.26234@gandalf.stny.rr.com> <20081220033822.362bc88a@daedalus.pq.iki.fi> <alpine.DEB.1.10.0812192043320.29275@gandalf.stny.rr.com>
 <20081220043210.40758f36@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008, Pekka Paalanen wrote:

> > 
> > To implement this at the ftrace level should be a trivial change. I'm just 
> > saying that doing this at the "ring buffer" level might be a bit more 
> > complex. The ring buffer has no idea of ftrace. It should not. It is at 
> > a lower lever than ftrace. Although, I do think some of the protecting 
> > that is done at the tracing level during resize should be moved down into 
> > the ring buffer layer.
> 
> Aah, so you are saying that the buffer_size file (or whatever it was called)
> is part of the ring buffer user API, and not tracing user API?

Nope, the buffer_size is part of the ftrace API. It was just that it 
seemed that Ingo was pushing that the ring buffer API should handle it. I 
may have misunderstood Ingo though. Note, when Ingo and I start going back 
and forth, we sometimes are at the implementation level, and probably will 
confuse the users ;-)

Since the buffer_size is at the ftrace level, it will make it easier to do 
the changes there.

> 
> But the ring buffer is just a buffer, is it meaningful to adjust a ring
> buffer size? I cannot tell tracing to go use a different buffer. And if
> there will be other users of ring buffers, they would probably want to
> have their own control over the buffer size.

Exactly.

> 
> As a user, I want to adjust *the* tracing ring buffer size, not some ring
> buffer size.

Correct, and that is what you are doing.

> 
> Am I making any sense? I'm trying to say that in my opinion, the
> buffer_size file does not belong to the "ring buffer" level. The upper
> levels should decide whether and how it offers buffer resizing.

The "buffer_size" file is part of ftrace, not the ring buffer. You are 
making perfect sense.

-- Steve


