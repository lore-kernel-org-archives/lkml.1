Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbYHOOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbYHOOnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYHOOnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:43:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYHOOno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:43:44 -0400
Date: Fri, 15 Aug 2008 16:43:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       airlied@linux.ie, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 2/2] reduce tlb/cache flush times of agpgart memory
	allocation
Message-ID: <20080815144312.GI12954@elte.hu>
References: <1217832690.21811.9.camel@sli10-desk.sh.intel.com> <20080815143131.GF12954@elte.hu> <20080815074033.4817f876@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815074033.4817f876@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 15 Aug 2008 16:31:31 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Shaohua Li <shaohua.li@intel.com> wrote:
> > 
> > > To reduce tlb/cache flush, makes agp memory allocation do one flush 
> > > after all pages in a region are changed to uc.
> > > 
> > > All agp drivers except agp-sgi uses agp_generic_alloc_page() for 
> > > .agp_alloc_page, so the patch should work for them. agp-sgi is only 
> > > for ia64, so not a problem too.
> > 
> > applied to tip/x86/pat - thanks!
> > 
> > I've Cc:-ed more PAT folks - any objections?
> > 
> 
> it really needs something else instead; it needs airlied's array 
> allocator otherwise you hit the second wall as well (the pat checks 
> per page)
> 
> in reality an array version of ioremap (or set_pages_X) is what is 
> needed

ok, agreed.

	Ingo
