Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbZCYQHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbZCYQHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762026AbZCYQHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:07:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:54092 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762793AbZCYQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:07:32 -0400
Subject: RE: [PATCH] Suspend and Resume Support for Intel IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "'Ingo Molnar'" <mingo@elte.hu>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB894F11D64@orsmsx505.amr.corp.intel.com>
References: <20090218165633.GA20167@linux-os.sc.intel.com>
	 <alpine.LFD.2.00.0902180910160.21686@localhost.localdomain>
	 <20090218171935.GA14625@elte.hu>
	 <A6AD88C3F2289247BE726C37303E1EB894F11D64@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 16:06:42 +0000
Message-Id: <1237997202.2085.25.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 09:28 -0800, Yu, Fenghua wrote:
> >> On Wed, 18 Feb 2009, Fenghua Yu wrote:
> >> >
> >> > +static int vtd_enabled;
> >> ..
> >> > +static int iommu_resume(struct sys_device *dev)
> >> > +{
> >> ..
> >> > +	if (!vtd_enabled)
> >> > +		return 0;
> >> 
> >> Hmm. Why do this?
> >> 
> >> Wouldn't it be much more logical to only register the 
> >> iommu_sysdev if the thing is enabled, rather than having an 
> >> odd flag that gets tested at runtime?
> >
> >The sysdev_class_register() could be done straight in 
> >intel_iommu_init(), because that gets called by pci_iommu_init() 
> >which is an fs_initcall() - so all the sysdev facilities should 
> >be up and running already.
> 
> That was my original concern. I'll remove the vtd_enabled flag and
> register device_iommu in intel_iommu_init() in an updated patch.

For some reason most of this thread is missing from my mailbox. Did you
ever submit this 'updated patch' that you threatened...?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

