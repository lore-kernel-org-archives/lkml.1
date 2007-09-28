Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbXI1Vtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbXI1Vtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXI1Vtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:49:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38205 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbXI1Vtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:49:42 -0400
Date: Fri, 28 Sep 2007 14:48:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Maarten Bressers <mbres@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compiler warnings for 2.6.23-rc8 on x86_64
Message-Id: <20070928144853.01d4f247.randy.dunlap@oracle.com>
In-Reply-To: <20070928205630.38562652FE@smtp.gentoo.org>
References: <20070928205630.38562652FE@smtp.gentoo.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 20:56:30 +0000 (UTC) Maarten Bressers wrote:

> This (trivial) patch fixes two compiler warnings for 2.6.23-rc8 on x86_64,
> use of deprecated function pci_find_device() and a section mismatch.
> Build log and .config file included.
> 
> Signed-off by: Maarten Bressers <mbres@gentoo.org>

Please include the text from section mismatch warnings in the patch
description.

> diff --git a/arch/x86_64/kernel/smpboot.c b/arch/x86_64/kernel/smpboot.c
> index 32f5078..7c872df 100644
> --- a/arch/x86_64/kernel/smpboot.c
> +++ b/arch/x86_64/kernel/smpboot.c
> @@ -532,7 +532,7 @@ struct create_idle {
>  	int cpu;
>  };
>  
> -void do_fork_idle(struct work_struct *work)
> +static void __cpuinit do_fork_idle(struct work_struct *work)
>  {
>  	struct create_idle *c_idle =
>  		container_of(work, struct create_idle, work);
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index c6e79d0..0eb7e9e 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -96,7 +96,7 @@ pci_find_slot(unsigned int bus, unsigned int devfn)
>  {
>  	struct pci_dev *dev = NULL;
>  
> -	while ((dev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
> +	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>  		if (dev->bus->number == bus && dev->devfn == devfn)
>  			return dev;
>  	}
> @@ -434,8 +434,6 @@ int pci_dev_present(const struct pci_device_id *ids)
>  EXPORT_SYMBOL(pci_dev_present);
>  EXPORT_SYMBOL(pci_find_present);
>  
> -EXPORT_SYMBOL(pci_find_device);
> -EXPORT_SYMBOL(pci_find_slot);

There are still about 30 and 14 respetively users of pci_find_devic()
and pci_find_slot() in 2.6.23-rc8.  Will you be fixing them?


>  /* For boot time work */
>  EXPORT_SYMBOL(pci_find_bus);
>  EXPORT_SYMBOL(pci_find_next_bus);

---
~Randy
Phaedrus says that Quality is about caring.
