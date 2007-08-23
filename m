Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXHWXjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXHWXjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXHWXiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:38:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:50165 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXHWXit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nBYB7EkzZYJRlbZr/ow/VqezCjZgY+vh4pT2JB/pgY6rpP8RrU6YXyfWYr1Sh+VkGlRDNjbA4xPdheS8BO4FYFtj1WPr1/3bcgTg8rbVtXYjdGpzZo24XB/y0HcOnvSEV8E9UNc4bIOoIqqO7ol1N5LqPyJlManrI96+LxS2cys=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/30] Remove unneeded casts of [kv][mzc]alloc() return values
Date: Fri, 24 Aug 2007 01:35:56 +0200
User-Agent: KMail/1.9.7
Cc: Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708240135.56833.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [kv][mzc]alloc() functions return a void pointer, so when 
assigning to a pointer type variable there is no need to cast 
the return value.

This is something that is already commonly being cleaned up when 
people change nearby code and it's also something people are 
usually asked not to do when submitting new code. 

I took a look at how many such casts are currently left and didn't 
find that many, so I cleaned them up.
I've probably missed some, but this patch series should clean up 
the majority of the remaining ones at least.

The patches in this series are

 [PATCH 1/30] ia64: Remove unnecessary cast of allocation return value in sn_hwperf_enum_objects()
 [PATCH 1/30] cris: Remove unnecessary cast of allocation return value in intmem.c
 [PATCH 1/30] um: Don't unnecessarily cast allocation return value in ubd_kern.c
 [PATCH 1/30] powerpc: Don't cast kmalloc return value in ibmebus.c
 [PATCH 1/30] atm: No need to cast vmalloc() return value
 [PATCH 1/30] i2o: No need to cast kmalloc() return value in cfg_open()
 [PATCH 1/30] mtd: Get rid of pointless cast of kzalloc() return value in AT26xxx driver
 [PATCH 1/30] mtd: Avoid a pointless kmalloc() return value cast in TQM8xxL mapping handling code
 [PATCH 1/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
 [PATCH 1/30] irda: Do not do pointless kmalloc return value cast in KingSun driver
 [PATCH 1/30] net: No need to cast vmalloc() return values in NetXen NIC driver
 [PATCH 1/30] net: No point in casting kmalloc return values in Gianfar Ethernet Driver
 [PATCH 1/30] net: Don't do pointless kmalloc return value casts in zd1211 driver
 [PATCH 1/30] net: Kill some unneeded allocation return value casts in libertas
 [PATCH 1/30] net: No need to cast kmalloc() return value in ipw2100 driver
 [PATCH 1/30] net: Avoid pointless allocation casts in BSD compression module
 [PATCH 1/30] isdn: Get rid of some pointless allocation casts in common and bsd comp.
 [PATCH 1/30] isdn: eicon - get rid of a pointless vmalloc() return value cast
 [PATCH 1/30] scsi: Remove explicit casts of [kv]alloc return values in osst driver
 [PATCH 1/30] scsi: In the Advansys driver, do not cast allocation function return values
 [PATCH 1/30] oss: Remove unneeded vmalloc() return value casts in OSS
 [PATCH 1/30] ivtv: kzalloc() returns void pointer, no need to cast
 [PATCH 1/30] video: Remove pointless kmalloc() return value cast in Zoran PCI controller driver
 [PATCH 1/30] dvb: remove some unneeded vmalloc() return value casts from av7110
 [PATCH 1/30] tty: dont needlessly cast kmalloc() return value
 [PATCH 1/30] md: vmalloc() returns void pointer so we don't need to cast it in dm-ioctl
 [PATCH 1/30] usb: avoid redundant cast of kmalloc() return value in OTi-6858 driver
 [PATCH 1/30] jfs: avoid pointless casts of kmalloc() return val
 [PATCH 1/30] mm: No need to cast vmalloc() return value in zone_wait_table_init()
 [PATCH 1/30] emu10k1: There's no need to cast vmalloc() return value in snd_emu10k1_create()

I'll send them all as replies to this email, to LKML and maintainers.


Kind regards,
  Jesper

