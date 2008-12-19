Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYLSRU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYLSRU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYLSRUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:20:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYLSRUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:20:20 -0500
Date: Fri, 19 Dec 2008 12:20:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Pekka Paalanen <pq@iki.fi>,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: [PATCH] ftrace: introduce tracing_reset_online_cpus() helper
In-Reply-To: <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Dec 2008, Fr?d?ric Weisbecker wrote:
> 
> 
> That's looks good.
> By the past, I also suggested Steven to automatically reset the traces
> buffer each time a tracer is started, that
> would factor out the code a bit more. I don't think one tracer would
> avoid to reset the buffer once it is started, and
> I don't think it is needed to reset twice on tracer switching: on stop
> of the old tracer and on start on the new. Only
> on start should be enough.

I'm actually against the idea of reseting a trace everytime we enable it.
That is:

echo 1 > /debug/tracing/tracing_enabled

This should not reset the tracer. I actually do tracing where I disable 
and enable it around areas I am interested in. I want all tracing, not 
just the last one.

Now we have recently added /debug/tracing/tracing_on which can quickly 
stop tracing. I may be able to use that, and we can let the 
tracing_enable" reset it too.

I'll have to take a look at my scripts to see if that would work.

-- Steve


