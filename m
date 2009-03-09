Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZCIN1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZCIN1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZCIN0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:26:32 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35607 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbZCIN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:26:28 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>
Cc: rtc-linux@googlegroups.com, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       dann frazier <dannf@hp.com>
Subject: [PATCH 2/7] parisc: rtc: platform_driver_probe() fixups
Date: Mon,  9 Mar 2009 14:26:18 +0100
Message-Id: <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using platform_driver_probe(), it's not needed to setup a .probe
function, and .remove should be marked __exit_p(), not __devexit_p().

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: dann frazier <dannf@hp.com>
---
 drivers/rtc/rtc-parisc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-parisc.c b/drivers/rtc/rtc-parisc.c
index 620b949..f4e871c 100644
--- a/drivers/rtc/rtc-parisc.c
+++ b/drivers/rtc/rtc-parisc.c
@@ -62,8 +62,7 @@ static struct platform_driver parisc_rtc_driver = {
 		.name = "rtc-parisc",
 		.owner = THIS_MODULE,
 	},
-	.probe = parisc_rtc_probe,
-	.remove = __devexit_p(parisc_rtc_remove),
+	.remove = __exit_p(parisc_rtc_remove),
 };
 
 static int __init parisc_rtc_init(void)
-- 
1.6.0.4

