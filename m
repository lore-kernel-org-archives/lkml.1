Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYKTLYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYKTLYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYKTLYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:24:38 -0500
Received: from mailgw.miraclelinux.com ([122.216.84.157]:45928 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYKTLYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:24:38 -0500
Message-ID: <492548F3.6090307@miraclelinux.com>
Date: Thu, 20 Nov 2008 20:24:35 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: broonie@opensource.wolfsonmicro.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: Fix define values of CS1_HIB_MODE.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.4.4.348488, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.11.20.110724
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I found a little mistake.
The define values are wrong.

It is written in the WM8350 DATA SHEET Rev 3.4 P285 that
CS1_HIB_MODE(bit 12) is disable at "1".

The following is it.

<WM8350 DATA SHEET Rev 3.4   P285>

REGISTER |BIT|    LABEL   | DESCRIPTION
ADDRESS  |   |            |
---------+---+------------+-------------
R172(ACh)| 12|CS1_HIB_MODE| 0=leave current sink as in Active
         |   |            | 1=disable current shik in Hibemate

Could you please check the following patch ?

Regards,
Naohiro Ooiwa

Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
---
 include/linux/mfd/wm8350/pmic.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/wm8350/pmic.h b/include/linux/mfd/wm8350/pmic.h
index 656279a..078363b 100644
--- a/include/linux/mfd/wm8350/pmic.h
+++ b/include/linux/mfd/wm8350/pmic.h
@@ -83,8 +83,8 @@
 #define WM8350_CS1_ISEL_SHIFT                        0

 /* Bit values for R172 (0xAC) */
-#define WM8350_CS1_HIB_MODE_DISABLE                  0
-#define WM8350_CS1_HIB_MODE_LEAVE                    1
+#define WM8350_CS1_HIB_MODE_DISABLE                  1
+#define WM8350_CS1_HIB_MODE_LEAVE                    0

 #define WM8350_CS1_ISEL_220M                      0x3F

-- 
1.5.4.1

