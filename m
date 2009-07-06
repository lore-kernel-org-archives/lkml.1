Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZGFIVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZGFIVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZGFIVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:21:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZGFIVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:21:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 5/5] sparc: use asm-generic/pci-dma-compat
Date: Mon, 6 Jul 2009 10:21:28 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-9-generic; KDE/4.2.95; x86_64; ; )
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, reif@earthlink.net
References: <1246860820-20629-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1246860820-20629-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1246860820-20629-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907061021.28360.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+mWai7oEf8cbL3POP7CLnI6WEt/XJeZGYX9Yg
 e4sh1X0lQnf9rHjiiVDS8+Exzk8zcjjZ7ApwKnrmx7hSE6Kaki
 zTDXJBilgCpKRUPg+4D5OfqApKzucmH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009, FUJITA Tomonori wrote:

> --- a/arch/sparc/include/asm/pci_64.h
> +++ b/arch/sparc/include/asm/pci_64.h
> -/* Return whether the given PCI device DMA address mask can
> - * be supported properly.  For example, if your device can
> - * only drive the low 24-bits during PCI bus mastering, then
> - * you would pass 0x00ffffff as the mask to this function.
> - */
> -extern int pci_dma_supported(struct pci_dev *hwdev, u64 mask);
> -
>  /* PCI IOMMU mapping bypass support. */
>  
>  /* PCI 64-bit addressing works for all slots on all controller
> --- a/arch/sparc/kernel/iommu.c
> +++ b/arch/sparc/kernel/iommu.c
> @@ -840,6 +840,8 @@ static struct dma_map_ops sun4u_dma_ops = {
>  struct dma_map_ops *dma_ops = &sun4u_dma_ops;
>  EXPORT_SYMBOL(dma_ops);
>  
> +extern int pci64_dma_supported(struct pci_dev *pdev, u64 device_mask);
> +
>  int dma_supported(struct device *dev, u64 device_mask)
>  {
>  	struct iommu *iommu = dev->archdata.iommu;

Minor nitpicking: The declaration should better be left in the header
file to avoid extern declarations in C files.

	Arnd <><
