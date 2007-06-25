Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXFYCLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXFYCLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 22:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXFYCLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 22:11:31 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:61949 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbXFYCLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 22:11:30 -0400
Date: Sun, 24 Jun 2007 22:10:53 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: disable the GART in shutdown
Message-ID: <20070625021053.GC12557@rhun.ibm.com>
References: <200706221219.16243.yinghai.lu@sun.com> <200706230214.02535.ak@suse.de> <467C6906.6020105@sun.com> <200706221934.59966.yinghai.lu@sun.com> <20070623095209.248684e7.akpm@linux-foundation.org> <86802c440706241722o6d18d4acsf3293eb2a83c4688@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440706241722o6d18d4acsf3293eb2a83c4688@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 05:22:30PM -0700, Yinghai Lu wrote:
> On 6/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>  void __init gart_iommu_init(void)
> >>  {
> >>       struct agp_kern_info info;
> >> diff --git a/arch/x86_64/kernel/pci-dma.c b/arch/x86_64/kernel/pci-dma.c
> >> index 9f80aad..64f2ab3 100644
> >> --- a/arch/x86_64/kernel/pci-dma.c
> >> +++ b/arch/x86_64/kernel/pci-dma.c
> >> @@ -322,6 +322,13 @@ static int __init pci_iommu_init(void)
> >>       return 0;
> >>  }
> >>
> >> +void pci_iommu_shutdown(void)
> >> +{
> >> +#ifdef CONFIG_IOMMU
> >> +     gart_iommu_shutdown();
> >> +#endif
> >> +}
> >
> >It'd be better to avoid the ifdef-in-C by providing a stub function in a
> >header file if !CONFIG_IOMMU.  That's quite standard kernel practice and
> >might help avoid some other problems...
> 
> move ifdef into gart_iommu_shudown()?

What Andrew means is
(in a header file)

#ifdef CONFIG_IOMMU
extern void gart_iommu_shutdown(void);
#else
static inline void gart_iommu_shutdown(void)
{
}
#endif /* CONFIG_IOMMU */

Cheers,
Muli
