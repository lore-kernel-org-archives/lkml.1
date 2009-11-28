Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZK1SgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZK1SgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 13:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZK1SgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 13:36:24 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:20475 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZK1SgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 13:36:23 -0500
Date: Sat, 28 Nov 2009 10:34:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: g_multi: Fixed '"CONFIG_USB_ETH_RNDIS" redefined'
 warning
Message-Id: <20091128103429.705670b2.randy.dunlap@oracle.com>
In-Reply-To: <1259150386-7291-1-git-send-email-m.nazarewicz@samsung.com>
References: <20091125223508.c0924e2d.sfr@canb.auug.org.au>
	<1259150386-7291-1-git-send-email-m.nazarewicz@samsung.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B116DA3.002F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 12:59:46 +0100 Michal Nazarewicz wrote:

> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
> 
> CONFIG_USB_ETH_RNDIS may be defined when g_ether is built causing
> warning when multi.c tries to redefine its value.  Changed to first
> undefine CONFIG_USB_ETH_RNDIS in multi.c.

Is there no kconfig way to solve this?
You shouldn't be messing with kconfig symbols in source files...


> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> ---
>  drivers/usb/gadget/multi.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
> index 64711fe..227dc81 100644
> --- a/drivers/usb/gadget/multi.c
> +++ b/drivers/usb/gadget/multi.c
> @@ -26,6 +26,9 @@
>  #include <linux/utsname.h>
>  
>  
> +#if defined CONFIG_USB_ETH_RNDIS
> +#  undef CONFIG_USB_ETH_RNDIS
> +#endif
>  #if defined CONFIG_USB_G_MULTI_RNDIS
>  #  define CONFIG_USB_ETH_RNDIS y
>  #endif
> -- 


---
~Randy
