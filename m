Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZFIGyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZFIGyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZFIGyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:54:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51307 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbZFIGyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:54:08 -0400
Date: Tue, 9 Jun 2009 08:53:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
Message-ID: <20090609065350.GB16707@elte.hu>
References: <1244481941.13761.9119.camel@twins> <18989.57919.895309.847520@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18989.57919.895309.847520@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Peter Zijlstra writes:
> 
> > Allow extending the perf_counter_attr structure by linking extended
> > structures to it.
> 
> ...
> 
> > @@ -175,6 +175,13 @@ struct perf_counter_attr {
> >  	__u32			__reserved_3;
> >  
> >  	__u64			__reserved_4;
> > +
> > +	struct perf_counter_attr_ext *ext_attrs;
> > +};
> 
> Since this is a user-visible structure, you've just introduced an 
> ABI difference between 32-bit and 64-bit processes, which we've 
> managed to avoid so far. [...]

This is a good point too - handling pointers in ABIs is possible but 
should be avoided as much as possible: it creates the need to 
introduce a compat_sys_perf_counter_open() and doubles the syscall 
table complexity.

Lets do the s/__reserved_1/attr_size ABI i suggested (i outlined 
various properties of it in the previous mail). Agreed?

	Ingo
