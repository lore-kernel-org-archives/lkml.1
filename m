Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbXBDKAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbXBDKAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 05:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXBDKAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 05:00:07 -0500
Received: from 1-1-8-31a.gmt.gbg.bostream.se ([82.182.75.118]:61145 "EHLO
	lin5.shipmail.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752226AbXBDKAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 05:00:06 -0500
Message-ID: <45C5AEA5.2040501@tungstengraphics.com>
Date: Sun, 04 Feb 2007 11:00:05 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.7.8) Gecko/20050511
X-Accept-Language: sv, en-us, en
MIME-Version: 1.0
To: ebuddington@wesleyan.edu
CC: Dave Airlie <airlied@gmail.com>, Lee Revell <rlrevell@joe-job.com>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
References: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net> <75b66ecd0702031322k58db9da7l1ae1fc3a9342682b@mail.gmail.com> <20070203230945.GA4557@pool-71-161-133-234.spfdma.east.verizon.net> <21d7e9970702031520y503bfa98p43708e2d18a6599f@mail.gmail.com> <20070203232505.GC4557@pool-71-161-133-234.spfdma.east.verizon.net>
In-Reply-To: <20070203232505.GC4557@pool-71-161-133-234.spfdma.east.verizon.net>
Content-Type: multipart/mixed;
 boundary="------------000902040804080409030909"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000902040804080409030909
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Eric Buddington wrote:

>On Sun, Feb 04, 2007 at 10:20:29AM +1100, Dave Airlie wrote:
>  
>
>>What AGP chipset do you have? it looks like it might be caused by the
>>AGP changes for TTM..
>>    
>>
>
>lspci:
>
>00:00.0 Host bridge: Silicon Integrated Systems [SiS] 741/741GX/M741 Host (rev 03)
>00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SiS AGP Port (virtual PCI-to-PCI bridge)
>00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS963 [MuTIOL Media IO] (rev 25)
>00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
>00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE]
>...
>
>-Eric
>  
>
Eric,
Sorry for the breakage. Can you try the attached patch and see if it 
fixes the problem.

/Thomas


--------------000902040804080409030909
Content-Type: text/plain;
 name="0001-Add-missing-.agp_type_to_mask_type-entries.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Add-missing-.agp_type_to_mask_type-entries.txt"

>From 531c7dc4e9d26a9a2c7a64d52cf73951c7c03ee8 Mon Sep 17 00:00:00 2001
From: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date: Sun, 4 Feb 2007 10:53:17 +0100
Subject: [PATCH] Add missing .agp_type_to_mask_type entries.
---
 drivers/char/agp/parisc-agp.c |    1 +
 drivers/char/agp/sis-agp.c    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 17c50b0..b7b4590 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -228,6 +228,7 @@ struct agp_bridge_driver parisc_agp_driv
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= 1,
 };
 
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index a00fd48..60342b7 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -140,6 +140,7 @@ static struct agp_bridge_driver sis_driv
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
 static struct agp_device_ids sis_agp_device_ids[] __devinitdata =
-- 
1.4.1


--------------000902040804080409030909--
