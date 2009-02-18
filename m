Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZBRRUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZBRRUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZBRRT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:19:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZBRRTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:19:55 -0500
Date: Wed, 18 Feb 2009 18:19:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>, David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       'iommu@lists.linux-foundation.org', LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Suspend and Resume Support for Intel IOMMU
Message-ID: <20090218171935.GA14625@elte.hu>
References: <20090218165633.GA20167@linux-os.sc.intel.com> <alpine.LFD.2.00.0902180910160.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902180910160.21686@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 18 Feb 2009, Fenghua Yu wrote:
> >
> > +static int vtd_enabled;
> ..
> > +static int iommu_resume(struct sys_device *dev)
> > +{
> ..
> > +	if (!vtd_enabled)
> > +		return 0;
> 
> Hmm. Why do this?
> 
> Wouldn't it be much more logical to only register the 
> iommu_sysdev if the thing is enabled, rather than having an 
> odd flag that gets tested at runtime?

The sysdev_class_register() could be done straight in 
intel_iommu_init(), because that gets called by pci_iommu_init() 
which is an fs_initcall() - so all the sysdev facilities should 
be up and running already.

	Ingo
