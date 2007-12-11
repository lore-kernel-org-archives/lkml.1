Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbXLKIy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbXLKIy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 03:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXLKIyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 03:54:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbXLKIyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 03:54:46 -0500
Date: Tue, 11 Dec 2007 09:54:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 5/4] x86: fix up asm-x86/pgtable*.h formatting
Message-ID: <20071211085423.GF20172@elte.hu>
References: <475DA7C5.70900@goop.org> <20071211083413.GA19953@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211083413.GA19953@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Dec 10, 2007 at 12:55:33PM -0800, Jeremy Fitzhardinge wrote:
> > +#define set_pte_atomic(pteptr, pteval)		set_pte(pteptr,pteval)
> > +#define set_pte_present(mm,addr,ptep,pteval)	set_pte_at(mm,addr,ptep,pteval)
> >  
> > +#define pte_clear(mm,addr,xp)				\
> > +	do {						\
> > +		set_pte_at(mm, addr, xp, __pte(0));	\
> > +	} while (0)
> > +
> >  #undef pmd_clear
> > +#define pmd_clear(xp)				\
> > +	do {					\
> > +		set_pmd(xp, __pmd(0));		\
> > +	} while (0)
> 
> What about turning these into inline functions to get better type 
> checking?

yes, please. That will also trigger and resolve any still present 
include file dependency mess. Macros are often used to hack around 
unclean include file layouts.

	Ingo
