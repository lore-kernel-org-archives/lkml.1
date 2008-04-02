Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbYDBPgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbYDBPgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYDBPf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:35:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24723 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbYDBPf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:35:56 -0400
Date: Wed, 2 Apr 2008 08:33:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Fix build for non-PCIhost
Message-Id: <20080402083343.02de39c0.randy.dunlap@oracle.com>
In-Reply-To: <200804021703.27817.mb@bu3sch.de>
References: <20080401175230.9ffe75cf.sfr@canb.auug.org.au>
	<20080401092119.3cb214b1.randy.dunlap@oracle.com>
	<200804021703.27817.mb@bu3sch.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 17:03:26 +0200 Michael Buesch wrote:

> This fixes a build error when PCMCIA-host support is built,
> but PCI-host support is disabled.
> Hell, who on earth would use such a weird configuration. :D
> 
> drivers/built-in.o: In function `ssb_attr_sprom_store':
> (.text+0x1c4b79): undefined reference to `ssb_devices_freeze'
> drivers/built-in.o: In function `ssb_attr_sprom_store':
> (.text+0x1c4bb3): undefined reference to `ssb_devices_thaw'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
> 
> John, please apply this to 2.6.26
> 
> 
> Index: wireless-testing/drivers/ssb/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/main.c	2008-03-21 21:41:31.000000000 +0100
> +++ wireless-testing/drivers/ssb/main.c	2008-04-02 16:50:16.000000000 +0200
> @@ -202,7 +202,7 @@ out:
>  	return err;
>  }
>  
> -#ifdef CONFIG_SSB_PCIHOST
> +#ifdef CONFIG_SSB_SPROM
>  int ssb_devices_freeze(struct ssb_bus *bus)
>  {
>  	struct ssb_device *dev;
> @@ -288,7 +288,7 @@ int ssb_devices_thaw(struct ssb_bus *bus
>  
>  	return 0;
>  }
> -#endif /* CONFIG_SSB_PCIHOST */
> +#endif /* CONFIG_SSB_SPROM */
>  
>  static void ssb_device_shutdown(struct device *dev)
>  {
> 
> 
> -- 

---
~Randy
