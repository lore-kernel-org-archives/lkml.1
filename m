Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbZIJQI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbZIJQI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZIJQI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:08:29 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:34849 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZIJQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:08:28 -0400
Date: Thu, 10 Sep 2009 09:08:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: David Vrabel <david.vrabel@csr.com>, Roman Zippel <zippel@linux-m68k.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: UWB Kconfig: cannot set UWB to N in gconfig
Message-Id: <20090910090806.e8db2300.randy.dunlap@oracle.com>
In-Reply-To: <1252577154.2340.12.camel@castor>
References: <1252577154.2340.12.camel@castor>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AA9246A.0062:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 11:05:54 +0100 Richard Kennedy wrote:

> I sometimes use 'make gconfig' and I noticed that I cannot disable the
> UWB option -- it just won't let me set it to N.

Not specific to 'gconfig'.

> AFAICT this is because the CONFIG USB_WUSB selects UWB which forces it
> on.

Yes.

> applying this patch fixes the issue but I'm not sure if this is the
> right way to go about it.
> 
> any thoughts?

UWB can be disabled by disabling both of these options that are several
entries below it in the same menu:

USB_WHCI_HCD and USB_HWA_HCD

and then returning to UWB and disabling it.

Should users have to figure that out?  no.


> This is against 2.6.31
> 
> 
> diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
> index eb09a0a..cc97041 100644
> --- a/drivers/usb/wusbcore/Kconfig
> +++ b/drivers/usb/wusbcore/Kconfig
> @@ -5,7 +5,7 @@ config USB_WUSB
>  	tristate "Enable Wireless USB extensions (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL
>  	depends on USB
> -        select UWB
> +        depends on UWB
>          select CRYPTO
>          select CRYPTO_BLKCIPHER
>          select CRYPTO_CBC

use tabs, not spaces.


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
