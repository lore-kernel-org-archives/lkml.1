Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYHOOku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYHOOku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYHOOkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:40:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:55565 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYHOOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:40:41 -0400
Date: Fri, 15 Aug 2008 07:40:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       airlied@linux.ie, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 2/2] reduce tlb/cache flush times of agpgart memory
 allocation
Message-ID: <20080815074033.4817f876@infradead.org>
In-Reply-To: <20080815143131.GF12954@elte.hu>
References: <1217832690.21811.9.camel@sli10-desk.sh.intel.com>
	<20080815143131.GF12954@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 16:31:31 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > To reduce tlb/cache flush, makes agp memory allocation do one flush 
> > after all pages in a region are changed to uc.
> > 
> > All agp drivers except agp-sgi uses agp_generic_alloc_page() for 
> > .agp_alloc_page, so the patch should work for them. agp-sgi is only 
> > for ia64, so not a problem too.
> 
> applied to tip/x86/pat - thanks!
> 
> I've Cc:-ed more PAT folks - any objections?
> 

it really needs something else instead; it needs airlied's array
allocator
otherwise you hit the second wall as well (the pat checks per page)

in reality an array version of ioremap (or set_pages_X) is what is
needed
