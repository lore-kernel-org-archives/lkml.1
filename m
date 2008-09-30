Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYI3LD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYI3LD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYI3LDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:03:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYI3LDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:03:50 -0400
Date: Tue, 30 Sep 2008 13:03:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for
	GART
Message-ID: <20080930110319.GA12529@elte.hu>
References: <20080927181855.GA11147@elte.hu> <20080928193436.GA8386@amd.com> <20080929085647.GB2190@elte.hu> <20080929231116Q.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929231116Q.fujita.tomonori@lab.ntt.co.jp>
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

> > yes - could you please make a new option for it, 
> > CONFIG_IOMMU_DEBUG_FORCE=y or so - and cover all iommus that support 
> > it?
> 
> I'm not sure we are talking about the same thing. Surely, I and Joerg 
> are talking different things.
> 
> GART driver doesn't need to use the IOMMU hardware at all times. GART 
> does a virtual mapping only when necessary (a device needs to handle 
> an address that it can't access to). But as I wrote, if you use 
> iommu=force, GART driver always use the IOMMU hardware.

yes - but iommu=force is not randconfig covered, hence it never gets 
tested by -tip testing. So my suggestion was a really simple patch: a 
new Kconfig entry that makes iommu=force default. 

CONFIG_BOOTPARAM_IOMMU_FORCE=y would be the right name for it. (disabled 
by default, of course)

> Other x86 IOMMU drivers always use the IOMMU hardware. Except for 
> Intel VT-D, they manage free virtual I/O space in the round-robin 
> manner with the bitmap algorithm to avoid frequent IOTLB flush. Joerg 
> said he tested AMD IOMMU driver with the round-robin manner disabled 
> so AMD IOMMU driver uses the same virtual I/O space with lots of IOTLB 
> flush.

all i'm suggesting is to please expose existing debug capabilities in 
the .config space, so that it can be tested in automated setups.

	Ingo
