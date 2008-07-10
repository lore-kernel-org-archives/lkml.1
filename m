Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYGJEai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYGJEai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 00:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYGJEaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 00:30:05 -0400
Received: from sh.osrg.net ([192.16.179.4]:47483 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbYGJEaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 00:30:03 -0400
Date: Thu, 10 Jul 2008 13:25:23 +0900
To: akpm@linux-foundation.org
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 16/34] AMD IOMMU: add kernel command line parameters
 for AMD IOMMU
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080709185634.08c60937.akpm@linux-foundation.org>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-17-git-send-email-joerg.roedel@amd.com>
	<20080709185634.08c60937.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080710132447T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 18:56:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 26 Jun 2008 21:27:52 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds two parameters to the kernel command line to control behavior
> > of the AMD IOMMU.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu_init.c |   34 ++++++++++++++++++++++++++++++++++
> >  1 files changed, 34 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> > index d7a75bf..ec6f13b 100644
> > --- a/arch/x86/kernel/amd_iommu_init.c
> > +++ b/arch/x86/kernel/amd_iommu_init.c
> > @@ -789,3 +789,37 @@ void __init amd_iommu_detect(void)
> >  	}
> >  }
> >  
> > +static int __init parse_amd_iommu_options(char *str)
> > +{
> > +	for (; *str; ++str) {
> > +		if (strcmp(str, "off") == 0)
> > +			amd_iommu_disable = 1;
> > +		if (strcmp(str, "isolate") == 0)
> > +			amd_iommu_isolate = 1;
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> > +static int __init parse_amd_iommu_size_options(char *str)
> > +{
> > +	for (; *str; ++str) {
> > +		if (strcmp(str, "32M") == 0)
> > +			amd_iommu_aperture_order = 25;
> > +		if (strcmp(str, "64M") == 0)
> > +			amd_iommu_aperture_order = 26;
> > +		if (strcmp(str, "128M") == 0)
> > +			amd_iommu_aperture_order = 27;
> > +		if (strcmp(str, "256M") == 0)
> > +			amd_iommu_aperture_order = 28;
> > +		if (strcmp(str, "512M") == 0)
> > +			amd_iommu_aperture_order = 29;
> > +		if (strcmp(str, "1G") == 0)
> > +			amd_iommu_aperture_order = 30;
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> > +__setup("amd_iommu=", parse_amd_iommu_options);
> > +__setup("amd_iommu_size=", parse_amd_iommu_size_options);
> 
> Please document kernel boot parameters in Documentation/kernel-parameters.txt.

[PATCH 34/34] does (this should have included [PATCH 34/34], I guess).

I have one related question, we should document all the kernel boot
parameters in Documentation/kernel-parameters.txt?

Some of x86_64 boot parameters are in
Documentations/x86/x86_64/boot-options.txt. The parameters of IOMMUs
are scattered. It's confusing.

http://marc.info/?t=121541873700001&r=1&w=2
