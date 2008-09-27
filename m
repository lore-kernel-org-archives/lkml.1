Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYI0SZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYI0SZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYI0SZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:25:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37837 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYI0SZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:25:21 -0400
Date: Sat, 27 Sep 2008 14:25:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [Patch -tip 3/3] Tracing/ftrace: Don't consume entries unhandled
 by mmiotrace
In-Reply-To: <20080927174756.GF26047@elte.hu>
Message-ID: <alpine.DEB.1.10.0809271420210.11231@gandalf.stny.rr.com>
References: <48DB8408.7080408@gmail.com> <20080925173435.5f525557@daedalus.pq.iki.fi> <c62985530809250744t3ce0011ajebd8343eb748cf24@mail.gmail.com> <20080925183608.283babfb@daedalus.pq.iki.fi> <c62985530809250913q227a5876k19b1b0ec591ad3cd@mail.gmail.com>
 <20080927174756.GF26047@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Sep 2008, Ingo Molnar wrote:
> 
> the new trace-ringbuffer design Steve is working on would abstract away 
> this complication - then we could make tracers truly independent 
> entities.

Yep, I even started implementing this. What is nice about this too, is 
that we could even mix the tracer buffers together in the merge sort. 
Since all buffers use the same timestamping, we can keep the separate 
buffers out, turn on different tracers, and have the output show them all 
together.

This would mean that we can keep the function tracer buffer large, and the 
other tracer buffers smaller. And merge them together when needed.

I'll have to recreate it, since the buffer code changed quite a bit since 
I first started making ftrace do this. Also, I want to make the changes to 
ftrace as incremental as possible. That way we could easily diagnose 
problems that arise.

-- Steve
