Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYKZMVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYKZMVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYKZMVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:21:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYKZMVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:21:12 -0500
Date: Wed, 26 Nov 2008 07:21:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable
 output
In-Reply-To: <c62985530811260332m20a3388dy7bdc1fc15811898d@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811260718570.26424@gandalf.stny.rr.com>
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>  <20081126020459.GA16374@elte.hu>  <alpine.DEB.1.10.0811252113270.26424@gandalf.stny.rr.com> <c62985530811260332m20a3388dy7bdc1fc15811898d@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Fr?d?ric Weisbecker wrote:

> >>
> >> 3) The first column: single-character visual shortcuts for "overhead".
> >>    This is a concept we used in the -rt tracer and it still lives in
> >>    the latency tracer bits of ftrace and is quite useful:
> >>
> >>     '+' means "overhead spike": overhead is above 10 usecs.
> >>     '!' means "large overhead": overhead is above 100 usecs.
> >>
> >>    These give at-a-glance hotspot analysis - hotspots are easier to
> >>    miss as pure numbers.
> >
> > The latency_trace file has this too. And it uses the above peek to figure
> > it out ;-)
> 
> 
> That's right, the latency_trace does it. But it is based on a
> ring-buffer entry timestamp.
> I wanted to use ring-buffer entry timestamp, but it would be hard to
> calculate the duration
> since the return trace of a function doesn't often follow immediately
> its entry trace.
> And I can't reuse lat_print_timestamp() because I need the nsec
> remaining part....
> 
> This is too specific to reuse latency_trace...

I'd suggest just looking at how those are implemented, and use your own. 
One note, the latency tracer looks at the next entry, even if it is on 
another CPU. This is incorrect, and will definitely be incorrect for you. 
Just use the ring_buffer_iter_peek, that will get you what you want. Well, 
for leaf functions.

-- Steve

