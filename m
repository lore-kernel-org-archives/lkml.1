Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbZIEAVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbZIEAVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964833AbZIEAVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:41 -0400
Received: from kroah.org ([198.145.64.141]:42288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964802AbZIEAV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:56 2009
Message-Id: <20090905001456.753978833@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 61/71] powerpc/ps3: Add missing check for PS3 to rtc-ps3 platform device registration
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-ps3-add-missing-check-for-ps3-to-rtc-ps3-platform-device-registration.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

commit 7b6a09f3d6aedeaac923824af2a5df30300b56e9 upstream.

On non-PS3, we get:

| kernel BUG at drivers/rtc/rtc-ps3.c:36!

because the rtc-ps3 platform device is registered unconditionally in a kernel
with builtin support for PS3.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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


