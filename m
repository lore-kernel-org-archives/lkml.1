Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXDDSHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXDDSHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXDDSHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:07:02 -0400
Received: from mail.somanetworks.com ([216.126.67.42]:47951 "EHLO
	mail.somanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXDDSG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:06:59 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 14:06:58 EDT
Date: Wed, 4 Apr 2007 13:59:37 -0400 (EDT)
From: Scott Murray <scottm@somanetworks.com>
X-X-Sender: scottm@rancor.yyz.somanetworks.com
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, pcihpd-discuss@lists.sourceforge.net,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][PATCH] ROUND_UP macro cleanup in drivers/pci
In-Reply-To: <20070401111400.GA9758@arun.site>
Message-ID: <Pine.LNX.4.64.0704041346250.10014@rancor.yyz.somanetworks.com>
References: <20070401111400.GA9758@arun.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Milind Arun Choudhary wrote:

>
> ROUND_UP macro cleanup, use ALIGN where ever appropriate
>
> Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

Ack for the hotplug/cpci_hotplug_pci.c change, looks like I missed
removing that define back when I originally reworked things for 2.6.
The setup-bus.c change looks okay to me as well, but probably needs
sign-off from Greg.

Signed-off-by: Scott Murray <scottm@somanetworks.com>

> ---
>  hotplug/cpci_hotplug_pci.c |    2 --
>  setup-bus.c                |    8 +++-----
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
>
> diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
> index 7b1beaa..5e9be44 100644
> --- a/drivers/pci/hotplug/cpci_hotplug_pci.c
> +++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
> @@ -45,8 +45,6 @@ extern int cpci_debug;
>  #define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
>  #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
>
> -#define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
> -
>
>  u8 cpci_get_attention_status(struct slot* slot)
>  {
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 3554f39..e02766f 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -34,8 +34,6 @@
>  #define DBG(x...)
>  #endif
>
> -#define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
> -
>  static void __devinit
>  pbus_assign_resources_sorted(struct pci_bus *bus)
>  {
> @@ -314,7 +312,7 @@ pbus_size_io(struct pci_bus *bus)
>  #if defined(CONFIG_ISA) || defined(CONFIG_EISA)
>  	size = (size & 0xff) + ((size & ~0xffUL) << 2);
>  #endif
> -	size = ROUND_UP(size + size1, 4096);
> +	size = ALIGN(size + size1, 4096);
>  	if (!size) {
>  		b_res->flags = 0;
>  		return;
> @@ -383,11 +381,11 @@ pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long type)
>
>  		if (!align)
>  			min_align = align1;
> -		else if (ROUND_UP(align + min_align, min_align) < align1)
> +		else if (ALIGN(align + min_align, min_align) < align1)
>  			min_align = align1 >> 1;
>  		align += aligns[order];
>  	}
> -	size = ROUND_UP(size, min_align);
> +	size = ALIGN(size, min_align);
>  	if (!size) {
>  		b_res->flags = 0;
>  		return 1;
>
> --
> Milind Arun Choudhary
>

-- 
Scott Murray
SOMA Networks, Inc.
Toronto, Ontario
e-mail: scottm@somanetworks.com
