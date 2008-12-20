Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYLTBqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYLTBqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYLTBqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:46:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYLTBqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:46:39 -0500
Date: Fri, 19 Dec 2008 20:46:38 -0500 (EST)
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
In-Reply-To: <20081220033822.362bc88a@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0812192043320.29275@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi> <20081219225717.GK13409@elte.hu>
 <alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com> <20081219233443.GC17984@elte.hu> <alpine.DEB.1.10.0812191912280.26234@gandalf.stny.rr.com> <20081220033822.362bc88a@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 20 Dec 2008, Pekka Paalanen wrote:

> On Fri, 19 Dec 2008 19:29:30 -0500 (EST)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> I thought this was just about not having to do
> 
> $ echo 0 > tracing_enabled
> $ echo 28764243 > buffer_size
> $ echo 1 > tracing_enabled
> 
> and instead just do
> 
> $ echo 28764243 > buffer_size
> 
> which would do exactly the same, except being easier for the user.
> Personally I've never dreamed of any kind of resize-in-flight.
> 

To implement this at the ftrace level should be a trivial change. I'm just 
saying that doing this at the "ring buffer" level might be a bit more 
complex. The ring buffer has no idea of ftrace. It should not. It is at 
a lower lever than ftrace. Although, I do think some of the protecting 
that is done at the tracing level during resize should be moved down into 
the ring buffer layer.

-- Steve

