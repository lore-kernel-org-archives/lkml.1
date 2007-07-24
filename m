Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbXGXB5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbXGXB5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760385AbXGXB46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:56:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:40688 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759595AbXGXB46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="271829941"
Subject: Re: [RFC 7/8]KVM: swap out guest pages
From: Shaohua Li <shaohua.li@intel.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <46A491C4.8010302@qumranet.com>
References: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>
	 <46A491C4.8010302@qumranet.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 09:51:48 +0800
Message-Id: <1185241908.24201.22.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 19:32 +0800, Avi Kivity wrote:
> Shaohua Li wrote:
> > Make KVM guest pages be allocated dynamically and able to be swaped
> out.
> >
> > One issue: all inodes returned from anon_inode_getfd are shared,
> > if one module changes field of the inode, other moduels might break.
> > Should we introduce a new API to not share inode?
> >
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > ---
> >  drivers/kvm/kvm.h      |    8 +
> >  drivers/kvm/kvm_main.c |  220
> +++++++++++++++++++++++++++++++++++++++++++++----
> >  2 files changed, 211 insertions(+), 17 deletions(-)
> >
> > +
> > +     /*
> > +      * We just zap vcpu 0's page table. For a SMP guest, we should
> zap all
> > +      * vcpus'. It's better shadow page table is per-vm.
> > +      */
> > +     if (PagePrivate(page))
> > +             kvm_mmu_zap_pagetbl(&kvm->vcpus[0], page->index);
> > +
> >  
> 
> You're not removing any shadows of the page, in case that page is a
> guest page table.  But I don't see anything wrong with it -- the page
> won't change while it's in swap.
You are right. Should we?
