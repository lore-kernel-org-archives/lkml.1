Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYHULuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYHULuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbYHULuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:50:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53472 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242AbYHULuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:50:06 -0400
Date: Thu, 21 Aug 2008 13:49:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [3/4] add agp_generic_destroy_pages()
Message-ID: <20080821114952.GE30667@elte.hu>
References: <1219286777.18007.41.camel@sli10-desk.sh.intel.com> <20080820200807.324aa671.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820200807.324aa671.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> stylistic nit:
> 
> > +
> > +			for (i = 0; i < curr->page_count; i++) {
> > +				curr->memory[i] = (unsigned long)gart_to_virt(
> > +					curr->memory[i]);
> > +				curr->bridge->driver->agp_destroy_page(
> > +					(void *)curr->memory[i],
> > +					AGP_PAGE_DESTROY_UNMAP);
> > +			}
> > +			for (i = 0; i < curr->page_count; i++) {
> > +				curr->bridge->driver->agp_destroy_page(
> > +					(void *)curr->memory[i],
> > +					AGP_PAGE_DESTROY_FREE);
> > +			}
> 
> Make the above code a standalone function and call it here.
> 
> Then convert all drivers over so their .agp_destroy_pages points at
> that new function.
> 
> Then remove the `if'.

good point.

[ Shaohua, when you fix this, please do it as a delta patch against your 
  current patchset (or against tip/master). Thanks. ]

	Ingo
