Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZLEMf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZLEMf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 07:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbZLEMfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 07:35:55 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:2979 "EHLO
	mx3.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754364AbZLEMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 07:35:54 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B1A53AE.9020707@tremplin-utc.net>
Date: Sat, 05 Dec 2009 13:35:58 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: linux-kernel@vger.kernel.org, Zac Medico <zmedico@gentoo.org>
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com> <4B055609.9030306@tremplin-utc.net>
In-Reply-To: <4B055609.9030306@tremplin-utc.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 19-11-09 15:28, Éric Piel schreef:
> Op 19-11-09 09:52, Zeno Davatz schreef:
>> Hi
>>
>> I am looking for the Asus Eeepc Poulsbo (psb) driver in Kernel
>> 2.6.32-rc7. When is this driver expected to make it into the kernel?
:
> Hi,
> I'd also be interested by a patch to get the psb kernel module to
> compile with 2.6.32. If anyone has this already available, please post it!
> Or maybe someone knows what should be done to fix this type of errors?
Hello,

I've just noticed that Zac Medico has written the fixes (as sed scripts)
for the psb driver in gentoo. Below is the patch version of his fixes.
It works for me :-)

Thanks Zac!
See you,
Eric

8<--------------------------------------------------
psb: Fix compilation with kernel 2.6.32

This patch made from the Gentoo ebuild written by Zac Medico <zmedico@gentoo.org>,
to fix compilation of the psb module with kernel 2.6.32

It should be safe to be used with older version of the kernel. It fixes two changes:
 * In commit 6a12235c7d2d75c7d94b9afcaaecd422ff845ce0 phys_to_gart was removed
   since it is a 1:1 mapping on all platforms.
 * The acpi PREFIX constant is gone.

---
diff -urP psb-4.41.1-4mdv2010.0.orig/drm_agpsupport.c psb-4.41.1-4mdv2010.0.fix2632/drm_agpsupport.c
--- psb-4.41.1-4mdv2010.0.orig/drm_agpsupport.c	2009-10-08 12:09:11.000000000 +0200
+++ psb-4.41.1-4mdv2010.0.fix2632/drm_agpsupport.c	2009-12-05 02:46:28.000421027 +0100
@@ -524,7 +524,7 @@
 	DRM_DEBUG("Current page count is %ld\n", (long) mem->page_count);
 	mem->page_count = 0;
 	for (cur_page = pages; cur_page < last_page; ++cur_page)
-		mem->pages[mem->page_count++] = phys_to_gart(page_to_phys(*cur_page));
+		mem->pages[mem->page_count++] = page_to_phys(*cur_page);
 	agp_be->mem = mem;
 	return 0;
 }
diff -urP psb-4.41.1-4mdv2010.0.orig/drm_edid.c psb-4.41.1-4mdv2010.0.fix2632/drm_edid.c
--- psb-4.41.1-4mdv2010.0.orig/drm_edid.c	2009-10-08 12:09:11.000000000 +0200
+++ psb-4.41.1-4mdv2010.0.fix2632/drm_edid.c	2009-12-05 02:46:38.155168734 +0100
@@ -39,7 +39,7 @@
 	if (obj && obj->type == ACPI_TYPE_BUFFER)
 		memcpy(edid, obj->buffer.pointer, obj->buffer.length);
 	else {
-		printk(KERN_ERR PREFIX "Invalid _DDC data\n");
+		printk(KERN_ERR "ACPI: " "Invalid _DDC data\n");
 		status = -EFAULT;
 		kfree(obj);
 	}

