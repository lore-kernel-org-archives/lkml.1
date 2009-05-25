Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZEYFBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZEYFBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZEYFBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:01:05 -0400
Received: from ems-wuensche.com ([81.169.132.244]:49589 "EHLO
	h559305.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbZEYFBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:01:03 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 01:01:03 EDT
Message-ID: <4A1A23E4.3070604@ems-wuensche.com>
Date: Mon, 25 May 2009 06:51:48 +0200
From: Sebastian Haas <haas@ems-wuensche.com>
Organization: EMS Dr. Thomas =?ISO-8859-1?Q?W=FCnsche?=
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH -next] cpc-usb: fix PROC_FS dependency
References: <20090522185110.3f95b03e.sfr@canb.auug.org.au> <4A16D325.4030202@oracle.com> <4A16D495.9040301@xenotime.net>
In-Reply-To: <4A16D495.9040301@xenotime.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Randy Dunlap schrieb:
> Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> The proper way to check for and enforce a kconfig symbol
>> dependency is via Kconfig files, not by using #error in
>> a source file followed by 9 other compile errors.
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Sebastian Haas <haas@ems-wuensche.com>
>> ---
>>  drivers/staging/cpc-usb/Kconfig       |    2 +-
>>  drivers/staging/cpc-usb/cpc-usb_drv.c |   10 +---------
>>  2 files changed, 2 insertions(+), 10 deletions(-)
>>
>> --- linux-next-20090522.orig/drivers/staging/cpc-usb/cpc-usb_drv.c
>> +++ linux-next-20090522/drivers/staging/cpc-usb/cpc-usb_drv.c
>> @@ -27,12 +27,8 @@
>>  #include <linux/completion.h>
>>  #include <asm/uaccess.h>
>>  #include <linux/usb.h>
>> -
>>  #include <linux/version.h>
>> -
>> -#ifdef CONFIG_PROC_FS
>> -#   include <linux/proc_fs.h>
>> -#endif
>> +#include <linux/proc_fs.h>
>>  
>>  #include "cpc.h"
>>  
>> @@ -57,10 +53,6 @@ MODULE_LICENSE("GPL v2");
>>  #define USB_CPCUSB_M16C_PRODUCT_ID    0x0888
>>  #define USB_CPCUSB_LPC2119_PRODUCT_ID 0x0444
>>  
>> -#ifndef CONFIG_PROC_FS
>> -#error "PROCFS needed"
>> -#endif
>> -
>>  #define CPC_USB_PROC_DIR     CPC_PROC_DIR "cpc-usb"
>>  
>>  static struct proc_dir_entry *procDir;
>> --- linux-next-20090522.orig/drivers/staging/cpc-usb/Kconfig
>> +++ linux-next-20090522/drivers/staging/cpc-usb/Kconfig
>> @@ -1,4 +1,4 @@
>>  config USB_CPC
>>  	tristate "CPC CAN USB driver"
>> -	depends on USB
>> +	depends on USB && PROC_FS
>>  	default n
> 
> BTW, I'm surprised that there is no NET or CAN dependency here.
Yes, you are right. But there are no dependencies yet. As soon as
the driver starts to support SocketCAN, we need to add this
dependency.

- --
Mit freundlichen Gruessen/Best Regards,

Sebastian Haas
Software Entwicklung/Software Development

Phone: +49-9451-9432-22
Fax  : +49-9451-9432-12
Email: haas@ems-wuensche.com
Web  : www.ems-wuensche.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoaI9sACgkQpqRB8PJG7XzKAgCfWhjQeeFG+qXLoOQHM0hy0sw2
iK8An08cPNYEP5qEA/ex5KGjZm71keBq
=Fxlt
-----END PGP SIGNATURE-----
-- 
EMS Dr. Thomas Wuensche e.K.
Sonnenhang 3
85304 Ilmmuenster
HRA Neuburg a.d. Donau, HR-Nr. 70.106
Phone: +49-8441-490260
Fax  : +49-8441-81860
http://www.ems-wuensche.com
