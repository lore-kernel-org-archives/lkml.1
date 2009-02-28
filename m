Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZB1Ak3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZB1Ak3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 19:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZB1AkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 19:40:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753592AbZB1AkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 19:40:18 -0500
Date: Fri, 27 Feb 2009 16:39:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
 3 users
In-Reply-To: <20090227061936.GA5318@nowhere>
Message-ID: <alpine.LFD.2.00.0902271631231.3111@localhost.localdomain>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com> <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere>
 <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Feb 2009, Frederic Weisbecker wrote:
> 
> Ok, here is a try, I've mostly unified the format decoding bits.
> Most interesting other helpers were already implemented (pointer(),
> string() and number()

Ok, I don't think this is beautiful, but neither was the original code, 
so..

However, in order to make it at least a _bit_ more palatable, could we 
please agree to at least clean up this:

> +static int format_decode(const char *fmt, enum format_type *type, int *flags,
> +			  int *field_width, int *base, int *precision,
> +			  int *qualifier)

To

	struct printf_spec {
		enum format_type type;
		int flags, field_width, base, precision, qualifier;
	};

and then pass things around like

	static int format_decode(const char *fmt, struct printf_spec *spec)
	{
	..

instead? Wouldn't that be nicer? I suspect it would make the code look 
nicer too (instead of doing "*base = x", you'd see "spec->base = x" and it 
would look less like line noise in the callee, an the caller could just 
do a single "struct format_spec spec = { 0, }" to initialize that thing).

		Linus
