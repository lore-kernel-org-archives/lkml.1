Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbZCYMYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbZCYMYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZCYMYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:24:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33947 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbZCYMYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:24:33 -0400
Date: Wed, 25 Mar 2009 13:22:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
	percpu allocator
Message-ID: <20090325122241.GE11571@elte.hu>
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CA1AC3.9080908@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Tejun Heo <tj@kernel.org> wrote:

> > With your patches and a RELOC_HIDE version that uses the GOTENT 
> > indirection the kernel won't compile because the "X" constraint 
> > for the GOTENT access needs a symbol and there are quite a few 
> > users that pass a pointer. I do not see a simple solution for 
> > that problem yet.
> 
> Ah... okay.  Now I get it.  It wasn't expecting variables there.  How
> about doing the following?
> 
>  #define SHIFT_PERCPU_PTR(ptr, offset) (({				\
> 	 if (__builtin_constant_p(ptr))					\
> 		 do GOTENT trick;					\
> 	 else								\
> 		 RELOC_HIDE();						\
>  }))
> 
> Thanks.

Btw., is there any intermediate fix/workaround i could apply 
perhaps? I'd like to send the percpu bits early in the merge window 
and would hate to break Martin's arch ...

	Ingo
