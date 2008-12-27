Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYL0Q5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYL0Q5C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 11:57:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYL0Q4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 11:56:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbYL0Q4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 11:56:52 -0500
Date: Sat, 27 Dec 2008 17:56:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
Message-ID: <20081227165622.GA19796@elte.hu>
References: <patchbomb.1229970362@abulafia.goop.org> <20081227104823.GI14639@elte.hu> <20081228014432L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228014432L.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Sat, 27 Dec 2008 11:48:23 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Also, this patch will interact with ia64 materially:
> > 
> >   Subject: [PATCH 9 of 9] ia64/x86/swiotlb: use enum dma_data_direciton in dma_ops
> > 
> > So we'll need a bit more confidence in the testing status of this queue, 
> > and we probably want to wait until Tony merged the pending .29 ia64 
> > changes, and also get an Ack from Tony for these bits:
> > 
> >  arch/ia64/dig/dig_vtd_iommu.c       |    9 +++--
> >  arch/ia64/hp/common/hwsw_iommu.c    |   22 ++++++++------
> >  arch/ia64/hp/common/sba_iommu.c     |   12 ++++---
> >  arch/ia64/include/asm/dma-mapping.h |   29 +++++++++---------
> >  arch/ia64/include/asm/swiotlb.h     |   26 ++++++++++------
> >  arch/ia64/kernel/machvec.c          |    6 ++-
> >  arch/ia64/sn/kernel/io_common.c     |    3 +-
> >  arch/ia64/sn/pci/pci_dma.c          |   21 ++++++++-----
> >  arch/ia64/sn/pci/pcibr/pcibr_dma.c  |    3 +-
> >  arch/ia64/sn/pci/tioca_provider.c   |    3 +-
> > 
> > (Tony Cc:-ed)
> 
> BTW, the above patch breaks IA64 build.
> 
> It's fixable but I think that it would be better to just drop this huge 
> patch and add some cast in powerpc code. the types of SWIOTBL function 
> arguments don't need to mach to DAM_API.txt though it might be nice if 
> so. There are other type mismatches. If we really want to do this 
> cleanups, we should fix up all the mismatches.

hm, we shouldnt do ugly typecasts - lets fix all the places. As Jeremy 
indicated, this is work in progress.

	Ingo
