Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZH0IpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZH0IpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZH0IpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:45:22 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59684 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbZH0IpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:45:22 -0400
Date: Thu, 27 Aug 2009 10:45:22 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: stable@kernel.org
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: powerpc/ps3: Add missing check for PS3 to rtc-ps3 platform device
 registration (fwd)
Message-ID: <alpine.LRH.2.00.0908271041550.22490@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For stable/linux-2.6.30.y

---------- Forwarded message ----------
Date: Thu, 27 Aug 2009 03:59:28 GMT
From: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: git-commits-head@vger.kernel.org
Subject: powerpc/ps3: Add missing check for PS3 to rtc-ps3 platform device
    registration

Gitweb:     http://git.kernel.org/linus/7b6a09f3d6aedeaac923824af2a5df30300b56e9
Commit:     7b6a09f3d6aedeaac923824af2a5df30300b56e9
Parent:     f415c413f458837bd0c27086b79aca889f9435e4
Author:     Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
AuthorDate: Sun Aug 23 22:54:32 2009 +0000
Committer:  Benjamin Herrenschmidt <benh@kernel.crashing.org>
CommitDate: Thu Aug 27 13:25:46 2009 +1000

    powerpc/ps3: Add missing check for PS3 to rtc-ps3 platform device registration
    
    On non-PS3, we get:
    
    | kernel BUG at drivers/rtc/rtc-ps3.c:36!
    
    because the rtc-ps3 platform device is registered unconditionally in a kernel
    with builtin support for PS3.
    
    Reported-by: Sachin Sant <sachinp@in.ibm.com>
    Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
    Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/platforms/ps3/time.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/time.c b/arch/powerpc/platforms/ps3/time.c
index b178a1e..40b5cb4 100644
--- a/arch/powerpc/platforms/ps3/time.c
+++ b/arch/powerpc/platforms/ps3/time.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 
+#include <asm/firmware.h>
 #include <asm/rtc.h>
 #include <asm/lv1call.h>
 #include <asm/ps3.h>
@@ -84,6 +85,9 @@ static int __init ps3_rtc_init(void)
 {
 	struct platform_device *pdev;
 
+	if (!firmware_has_feature(FW_FEATURE_PS3_LV1))
+		return -ENODEV;
+
 	pdev = platform_device_register_simple("rtc-ps3", -1, NULL, 0);
 	if (IS_ERR(pdev))
 		return PTR_ERR(pdev);
--
To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
