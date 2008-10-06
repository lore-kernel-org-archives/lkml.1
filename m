Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYJFTo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYJFTo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYJFTnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:43:20 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:8732 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYJFTnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-type:content-transfer-encoding;
        b=A2+uUEdWTS9dmk25nlHBtfrd/YistXFMxm5M3M7hEwlXnNCbxhS1vPY+Ys4jHxvzL9
         O+NkNgMTQ/eX2PXEOKdeFy26D9nuGibcBq973lr6869baPCTVbNAq9lIKFY6Tl55+sdh
         nPtJ53M4g7bZelxx4Ol4dZ9nsE5M54jcmHFbs=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [RFC PATCH 3/4] Example of PowerPC device tree support for GPT based
	IR
To: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net
Date: Mon, 06 Oct 2008 15:43:12 -0400
Message-ID: <20081006194312.15992.50877.stgit@terra>
In-Reply-To: <20081006194032.15992.8393.stgit@terra>
References: <20081006194032.15992.8393.stgit@terra>
User-Agent: StGIT/0.14.3.224.g199b
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
index 1d10f0a..cbb22a1 100644
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
@@ -328,6 +318,14 @@
 			reg = <0x8000 0x4000>;
 		};
 
+		ir0: timer@670 { /* General Purpose Timer 6 in Input mode */
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
@@ -345,7 +343,6 @@
 				 &gpt4		0 0 /* timer4		61c		x2-16	   */
 				 &gpt5		0 0 /* timer5		44c		x7-11	   */
 				 &gpt6		0 0 /* timer6		60c		x8-15	   */
-				 &gpt7		0 0 /* timer7		36a		x17-9	   */
 				 >;
 		};
 	};

