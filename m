Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYFFN4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYFFN4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbYFFN4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:56:42 -0400
Received: from mail.atmel.fr ([81.80.104.162]:44029 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbYFFN4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:56:41 -0400
X-Greylist: delayed 1269 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 09:56:40 EDT
Message-ID: <48493D16.1050503@atmel.com>
Date: Fri, 06 Jun 2008 15:35:18 +0200
From: Patrice Vilchez <patrice.vilchez@atmel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Victor <andrew@sanpeople.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
CC: ATMEL - Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] Fix NAND FLASH timings for at91sam9x evaluation kits.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix NAND FLASH timings for at91sam9x evaluation kits.

New timings are based on application note
"NAND Flash Support on AT91SAM9 Microcontrollers" available at
http://atmel.com/dyn/resources/prod_documents/doc6255.pdf).

Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>
---

This timings are mandatory for newer kernel revision.
Please, could you consider them before 2.6.26 final release.

 arch/arm/mach-at91/at91sam9260_devices.c |    4 ++--
 arch/arm/mach-at91/at91sam9261_devices.c |   12 ++++++------
 arch/arm/mach-at91/at91sam9263_devices.c |    4 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c  |   12 ++++++------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 393a32a..26f5cac 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -321,8 +321,8 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+			| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
 	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
 			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 0babb64..ec18913 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -232,19 +232,19 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+			| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
-	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(2) | AT91_SMC_NCS_WRPULSE_(5)
-			| AT91_SMC_NRDPULSE_(2) | AT91_SMC_NCS_RDPULSE_(5));
+	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
+			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
 
-	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(7) | AT91_SMC_NRDCYCLE_(7));
+	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(5) | AT91_SMC_NRDCYCLE_(5));
 
 	if (data->bus_width_16)
 		mode = AT91_SMC_DBW_16;
 	else
 		mode = AT91_SMC_DBW_8;
-	at91_sys_write(AT91_SMC_MODE(3), mode | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(1));
+	at91_sys_write(AT91_SMC_MODE(3), mode | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(2));
 
 	/* enable pin */
 	if (data->enable_pin)
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 719667e..8a81f76 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -391,8 +391,8 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	at91_sys_write(AT91_MATRIX_EBI0CSA, csa | AT91_MATRIX_EBI0_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+			| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
 	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
 			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 450db30..d13a2e2 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -138,15 +138,15 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+			| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
-	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(2) | AT91_SMC_NCS_WRPULSE_(5)
-			| AT91_SMC_NRDPULSE_(2) | AT91_SMC_NCS_RDPULSE_(5));
+	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
+			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
 
-	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(7) | AT91_SMC_NRDCYCLE_(7));
+	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(5) | AT91_SMC_NRDCYCLE_(5));
 
-	at91_sys_write(AT91_SMC_MODE(3), AT91_SMC_DBW_8 | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(1));
+	at91_sys_write(AT91_SMC_MODE(3), AT91_SMC_DBW_8 | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(2));
 
 	/* enable pin */
 	if (data->enable_pin)
-- 
1.5.3.7



