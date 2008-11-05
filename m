Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbYKETtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbYKETtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYKETrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:47:53 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:12406 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737AbYKETrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-type:content-transfer-encoding;
        b=Dldqq3VdSg9Noxe/LUYPEHt2/bIxMHf9rK/yJHf2oaad2IeeGL889JXPxBTHKzsHSf
         mIbdY4YVqlghBi8P/tAfwMRTkF/Qiaaorf9Wanuex8U/lE4cEEMhAhHWRtHN+/FLuUlC
         CTWxZNS4i+zKxOihdZdJq24kxHdyTdk5ZKWB8=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [RFC PATCH V4 5/6] Example of PowerPC device tree support for GPT
	based IR
To: linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2008 14:47:46 -0500
Message-ID: <20081105194746.19407.45683.stgit@localhost>
In-Reply-To: <20081105194640.19407.19682.stgit@localhost>
References: <20081105194640.19407.19682.stgit@localhost>
User-Agent: StGit/0.14.3.275.gdc7f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---
 arch/powerpc/boot/dts/dspeak01.dts |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/boot/dts/dspeak01.dts b/arch/powerpc/boot/dts/dspeak01.dts
index ec163c0..bde6b79 100644
--- a/arch/powerpc/boot/dts/dspeak01.dts
+++ b/arch/powerpc/boot/dts/dspeak01.dts
@@ -131,16 +131,6 @@
 			#gpio-cells = <2>;
 		};
 
-		gpt7: timer@670 { /* General Purpose Timer in GPIO mode */
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			cell-index = <7>;
-			reg = <0x670 0x10>;
-			interrupts = <0x1 0x10 0x0>;
-			interrupt-parent = <&mpc5200_pic>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
 		rtc@800 {	// Real time clock
 			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
 			device_type = "rtc";
@@ -333,6 +323,14 @@
 			clock-handle = <&clock0>;
 		};
 
+		ir0@670 { /* General Purpose Timer 6 in Input mode */
+			compatible = "gpt-ir";
+			cell-index = <7>;
+			reg = <0x670 0x10>;
+			interrupts = <0x1 0x10 0x0>;
+			interrupt-parent = <&mpc5200_pic>;
+		};
+
 		/* This is only an example device to show the usage of gpios. It maps all available
 		 * gpios to the "gpio-provider" device.
 		 */
@@ -350,7 +348,6 @@
 				 &gpt4		0 0 /* timer4		61c		x2-16	   */
 				 &gpt5		0 0 /* timer5		44c		x7-11	   */
 				 &gpt6		0 0 /* timer6		60c		x8-15	   */
-				 &gpt7		0 0 /* timer7		36a		x17-9	   */
 				 >;
 		};
 	};

