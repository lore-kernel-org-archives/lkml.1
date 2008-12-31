Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYLaNxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYLaNxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbYLaNxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:53:35 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:33297 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbYLaNxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:53:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=eRM/dBw+LKp9F7e1aNY4FadVhYp5CDBMb9OFz0LQLTW7tFJ6J4TDRuScj6HToJE33X
         JlqqhddErzXLPbh/tfmDwq+kXEMxzXsDkwzap/4SmdqAoV9kKcJK0zvV2u+BSYPG2XRU
         0PENaIsveGJCDAda1nvPs/PBX2W5CIsJdFJCc=
Date: Wed, 31 Dec 2008 15:53:25 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
Message-ID: <20081231155325.392699d0@iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812192140350.29275@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	<c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	<alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
	<20081220004453.50aec846@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com>
	<20081220041759.5a026f5a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0812192140350.29275@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 21:47:53 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> > > The tracing_enabled is the way to start and stop a trace. I'm considering 
> > > to implement Frederic's request to reset the buffer on enabled. This is 
> > > quick but requires locks and mutexes to be taken. It calls a hook to the 
> > > plugin because different plugins actually want to reset (the irq latency 
> > > tracers reset with this).
> > > 
> > > The tracing_on is something that has been asked by developers to give a 
> > > way to start and stop tracing fast as possible, with no mutexes or added 
> > > locks. In fact, this option is local to the ring buffer code. Ftrace does 
> > > not even use it directly.  It just a global flag to stop tracing. There's 
> > > also an in-kernel equivalent tracing_on() and tracing_off(). This just 
> > > sets or clears a global flag that will stop any more writes to the trace 
> > > buffer.
> > 
> > Why not call tracing_on, say, logging_enabled?
> > IMHO tracing_enabled vs. tracing_on is incomprehesible, but
> > tracing_enabled vs. logging_enabled is a little more understandable.
> > current_tracer is self-explanatory, and tracing_enabled used to be.
> 
> One of the hardest things about ftrace is coming up with good naming. This 
> is not always so easy, as you can tell. I'm not sure "logging_enabled" is 
> any better. That would confuse myself ;-)   The reason I chose "on" is 
> because it is like an on/off switch, where as enabled/disabled is usually 
> (in the kernel anyway) associated to nesting.
> 
> How about tracing_enabled_light? ;-)

"tracing_on" is not a function call, so nesting does not make sense.
It is a file in debugfs, and therefore an end user interface. I am only
talking about the debugfs files, not functions. Only developers use
functions and devels can be expected to find the implementation and
read the fine documentation.

How about /debug/tracing/recording with values 0 and 1?
That would be a clear distinction to /debug/tracing/tracing_enabled.
I have also wondered about the "tracing_" prefix, the files are
already in the tracing/ directory.

I am just trying to think what file names would make sense in
debugfs. I completely agree with you on function naming, but should
the file have the same name as the function? Sure, for developers
it would be easier to remember, but the name might not make any
sense unless you know the internal implementation.

If something else than tracing starts to use the ring buffer
facility, we have to think about the names again. Until then,
just my 2c. :-)


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
