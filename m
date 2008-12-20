Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYLTCcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYLTCcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 21:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYLTCcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 21:32:17 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:51798 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYLTCcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 21:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=GP4COlPGDuaxUL2zEuSTlt1WGP53LfK2OyH4jYwTjqUCFJc3oK0lcMsLpqGovjnIuc
         0WPI3DQe/co3Vgd0w7jHxy9XJZu1KPj6cnQVvtwQBCq3jaYUDxLwUsVV5h3DbTyv2FTH
         obXwxAK2ueJZs2Wk0XlYWrMYgV57uERrCR0Tk=
Date: Sat, 20 Dec 2008 04:32:10 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@gmail.com>, pq@iki.fi
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
Message-ID: <20081220043210.40758f36@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812192043320.29275@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	<c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	<alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
	<20081220004453.50aec846@daedalus.pq.iki.fi>
	<20081219225717.GK13409@elte.hu>
	<alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com>
	<20081219233443.GC17984@elte.hu>
	<alpine.DEB.1.10.0812191912280.26234@gandalf.stny.rr.com>
	<20081220033822.362bc88a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0812192043320.29275@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 20:46:38 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Sat, 20 Dec 2008, Pekka Paalanen wrote:
> 
> > On Fri, 19 Dec 2008 19:29:30 -0500 (EST)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > I thought this was just about not having to do
> > 
> > $ echo 0 > tracing_enabled
> > $ echo 28764243 > buffer_size
> > $ echo 1 > tracing_enabled
> > 
> > and instead just do
> > 
> > $ echo 28764243 > buffer_size
> > 
> > which would do exactly the same, except being easier for the user.
> > Personally I've never dreamed of any kind of resize-in-flight.
> > 
> 
> To implement this at the ftrace level should be a trivial change. I'm just 
> saying that doing this at the "ring buffer" level might be a bit more 
> complex. The ring buffer has no idea of ftrace. It should not. It is at 
> a lower lever than ftrace. Although, I do think some of the protecting 
> that is done at the tracing level during resize should be moved down into 
> the ring buffer layer.

Aah, so you are saying that the buffer_size file (or whatever it was called)
is part of the ring buffer user API, and not tracing user API?

But the ring buffer is just a buffer, is it meaningful to adjust a ring
buffer size? I cannot tell tracing to go use a different buffer. And if
there will be other users of ring buffers, they would probably want to
have their own control over the buffer size.

As a user, I want to adjust *the* tracing ring buffer size, not some ring
buffer size.

Am I making any sense? I'm trying to say that in my opinion, the
buffer_size file does not belong to the "ring buffer" level. The upper
levels should decide whether and how it offers buffer resizing.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
