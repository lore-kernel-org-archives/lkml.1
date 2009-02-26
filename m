Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZBZS5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZBZS5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZBZS46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:56:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56051 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZBZS45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:56:57 -0500
Date: Thu, 26 Feb 2009 19:56:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] add binary printf
Message-ID: <20090226185635.GA12895@elte.hu>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com> <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226185208.GA6658@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Instead of calling the in/out helper from the decoder, why not 
> calling the decoder from these three functions and let them 
> take the appropriate actions for each decoded format token?
> 
> Naive example:
> 
> bstr_printf() {
> 	while (decode_format(...))
> 		if (type == number)
> 			read_number_from_buf()
> 			str = number(....)
> 		....
> }
> 
> vsnprintf {
> 	while (decode_format(...))
> 		if (type == number)
> 			var_arg(...)
> 			str = number(....)
> 		....
> }
> 
> vbin_printf {
> 	while (decode_format(...))
> 		if (type == number)
> 			var_arg(...)
> 			write_number_to_buffer()
> 		...
> }
> 
> And the standard in/out pieces can be invoked through helpers.

ok, that looks rather clean too. And maybe vsnprintf() and 
bstr_printf() could be further unified?

I guess it depends on how it all looks like in the end. Only one 
way to find out ...

	Ingo
