Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZFEILD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZFEILD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbZFEIFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37489 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbZFEIF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:28 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 13/62] Blackfin: pull updated anomaly lists from toolchain
Date: Fri,  5 Jun 2009 04:04:22 -0400
Message-Id: <1244189111-19639-14-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mach-bf518/include/mach/anomaly.h |   35 +++++-
 arch/blackfin/mach-bf527/include/mach/anomaly.h |  168 +++++++++++++++--------
 arch/blackfin/mach-bf533/include/mach/anomaly.h |   88 ++++++++++--
 arch/blackfin/mach-bf537/include/mach/anomaly.h |   84 +++++++-----
 arch/blackfin/mach-bf538/include/mach/anomaly.h |   60 +++++++--
 arch/blackfin/mach-bf548/include/mach/anomaly.h |   44 +++++-
 arch/blackfin/mach-bf561/include/mach/anomaly.h |   25 +++-
 7 files changed, 367 insertions(+), 137 deletions(-)

diff --git a/arch/blackfin/mach-bf518/include/mach/anomaly.h b/arch/blackfin/mach-bf518/include/mach/anomaly.h
index c847bb1..b69bd9a 100644
--- a/arch/blackfin/mach-bf518/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf518/include/mach/anomaly.h
@@ -6,14 +6,19 @@
  * Licensed under the GPL-2 or later.
  */
 
-/* This file shoule be up to date with:
+/* This file should be up to date with:
  *  - Revision B, 02/03/2009; ADSP-BF512/BF514/BF516/BF518 Blackfin Processor Anomaly List
  */
 
+/* We plan on not supporting 0.0 silicon, but 0.1 isn't out yet - sorry */
+#if __SILICON_REVISION__ < 0
+# error will not work on BF518 silicon version
+#endif
+
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
-/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
+/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
 #define ANOMALY_05000074 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
@@ -47,7 +52,7 @@
 #define ANOMALY_05000435 (1)
 /* PORTx_DRIVE and PORTx_HYSTERESIS Registers Read Back Incorrect Values */
 #define ANOMALY_05000438 (1)
-/* Preboot Cannot be Used to Program the PLL_DIV Register */
+/* Preboot Cannot be Used to Alter the PLL_DIV Register */
 #define ANOMALY_05000439 (1)
 /* bfrom_SysControl() Cannot be Used to Write the PLL_DIV Register */
 #define ANOMALY_05000440 (1)
@@ -61,32 +66,56 @@
 #define ANOMALY_05000453 (1)
 /* PPI_FS3 is Driven One Half Cycle Later Than PPI Data */
 #define ANOMALY_05000455 (1)
+/* False Hardware Error when RETI points to invalid memory */
+#define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
+#define ANOMALY_05000099 (0)
+#define ANOMALY_05000119 (0)
+#define ANOMALY_05000120 (0)
 #define ANOMALY_05000125 (0)
+#define ANOMALY_05000149 (0)
 #define ANOMALY_05000158 (0)
+#define ANOMALY_05000171 (0)
+#define ANOMALY_05000179 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000215 (0)
+#define ANOMALY_05000220 (0)
+#define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
+#define ANOMALY_05000231 (0)
+#define ANOMALY_05000233 (0)
+#define ANOMALY_05000242 (0)
 #define ANOMALY_05000244 (0)
+#define ANOMALY_05000248 (0)
+#define ANOMALY_05000250 (0)
 #define ANOMALY_05000261 (0)
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
+#define ANOMALY_05000274 (0)
 #define ANOMALY_05000278 (0)
 #define ANOMALY_05000285 (0)
+#define ANOMALY_05000287 (0)
+#define ANOMALY_05000301 (0)
 #define ANOMALY_05000305 (0)
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000312 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (0)
+#define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (0)
+#define ANOMALY_05000389 (0)
+#define ANOMALY_05000400 (0)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000447 (0)
 #define ANOMALY_05000448 (0)
+#define ANOMALY_05000456 (0)
+#define ANOMALY_05000450 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf527/include/mach/anomaly.h b/arch/blackfin/mach-bf527/include/mach/anomaly.h
index df6808d..c84ddea 100644
--- a/arch/blackfin/mach-bf527/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf527/include/mach/anomaly.h
@@ -6,14 +6,19 @@
  * Licensed under the GPL-2 or later.
  */
 
-/* This file shoule be up to date with:
- *  - Revision B, 08/12/2008; ADSP-BF526 Blackfin Processor Anomaly List
- *  - Revision E, 08/18/2008; ADSP-BF527 Blackfin Processor Anomaly List
+/* This file should be up to date with:
+ *  - Revision C, 03/13/2009; ADSP-BF526 Blackfin Processor Anomaly List
+ *  - Revision F, 03/03/2009; ADSP-BF527 Blackfin Processor Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
+/* We do not support old silicon - sorry */
+#if __SILICON_REVISION__ < 0
+# error will not work on BF526/BF527 silicon version
+#endif
+
 #if defined(__ADSPBF522__) || defined(__ADSPBF524__) || defined(__ADSPBF526__)
 # define ANOMALY_BF526 1
 #else
@@ -25,158 +30,203 @@
 # define ANOMALY_BF527 0
 #endif
 
-/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
+#define _ANOMALY_BF526(rev526) (ANOMALY_BF526 && __SILICON_REVISION__ rev526)
+#define _ANOMALY_BF527(rev527) (ANOMALY_BF527 && __SILICON_REVISION__ rev527)
+#define _ANOMALY_BF526_BF527(rev526, rev527) (_ANOMALY_BF526(rev526) || _ANOMALY_BF527(rev527))
+
+/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
 #define ANOMALY_05000074 (1)
 /* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)	/* note: brokenness is noted in documentation, not anomaly sheet */
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
-/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+/* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (1)
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT Mode with External Clock */
+#define ANOMALY_05000254 (1)
 /* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
 #define ANOMALY_05000265 (1)
 /* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
 #define ANOMALY_05000310 (1)
 /* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
-#define ANOMALY_05000313 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000313 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Incorrect Access of OTP_STATUS During otp_write() Function */
-#define ANOMALY_05000328 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000328 (_ANOMALY_BF527(< 2))
+/* Host DMA Boot Modes Are Not Functional */
+#define ANOMALY_05000330 (__SILICON_REVISION__ < 2)
 /* Disallowed Configuration Prevents Subsequent Allowed Configuration on Host DMA Port */
-#define ANOMALY_05000337 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000337 (_ANOMALY_BF527(< 2))
 /* Ethernet MAC MDIO Reads Do Not Meet IEEE Specification */
-#define ANOMALY_05000341 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000341 (_ANOMALY_BF527(< 2))
 /* TWI May Not Operate Correctly Under Certain Signal Termination Conditions */
-#define ANOMALY_05000342 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000342 (_ANOMALY_BF527(< 2))
 /* USB Calibration Value Is Not Initialized */
-#define ANOMALY_05000346 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000346 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* USB Calibration Value to use */
 #define ANOMALY_05000346_value 0xE510
 /* Preboot Routine Incorrectly Alters Reset Value of USB Register */
-#define ANOMALY_05000347 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000347 (_ANOMALY_BF527(< 2))
 /* Security Features Are Not Functional */
-#define ANOMALY_05000348 (ANOMALY_BF527 && __SILICON_REVISION__ < 1)
+#define ANOMALY_05000348 (_ANOMALY_BF527(< 1))
 /* bfrom_SysControl() Firmware Function Performs Improper System Reset */
-#define ANOMALY_05000353 (ANOMALY_BF526)
+#define ANOMALY_05000353 (_ANOMALY_BF526(< 1))
 /* Regulator Programming Blocked when Hibernate Wakeup Source Remains Active */
-#define ANOMALY_05000355 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000355 (_ANOMALY_BF527(< 2))
 /* Serial Port (SPORT) Multichannel Transmit Failure when Channel 0 Is Disabled */
-#define ANOMALY_05000357 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000357 (_ANOMALY_BF527(< 2))
 /* Incorrect Revision Number in DSPID Register */
-#define ANOMALY_05000364 (ANOMALY_BF527 && __SILICON_REVISION__ == 1)
+#define ANOMALY_05000364 (_ANOMALY_BF527(== 1))
 /* PPI Underflow Error Goes Undetected in ITU-R 656 Mode */
 #define ANOMALY_05000366 (1)
 /* Incorrect Default CSEL Value in PLL_DIV */
-#define ANOMALY_05000368 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000368 (_ANOMALY_BF527(< 2))
 /* Possible RETS Register Corruption when Subroutine Is under 5 Cycles in Duration */
-#define ANOMALY_05000371 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000371 (_ANOMALY_BF527(< 2))
 /* Authentication Fails To Initiate */
-#define ANOMALY_05000376 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000376 (_ANOMALY_BF527(< 2))
 /* Data Read From L3 Memory by USB DMA May be Corrupted */
-#define ANOMALY_05000380 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000380 (_ANOMALY_BF527(< 2))
 /* 8-Bit NAND Flash Boot Mode Not Functional */
-#define ANOMALY_05000382 (__SILICON_REVISION__ < 2)
-/* Host Must Not Read Back During Host DMA Boot */
-#define ANOMALY_05000384 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000382 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Boot from OTP Memory Not Functional */
-#define ANOMALY_05000385 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000385 (_ANOMALY_BF527(< 2))
 /* bfrom_SysControl() Firmware Routine Not Functional */
-#define ANOMALY_05000386 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000386 (_ANOMALY_BF527(< 2))
 /* Programmable Preboot Settings Not Functional */
-#define ANOMALY_05000387 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000387 (_ANOMALY_BF527(< 2))
 /* CRC32 Checksum Support Not Functional */
-#define ANOMALY_05000388 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000388 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Reset Vector Must Not Be in SDRAM Memory Space */
-#define ANOMALY_05000389 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000389 (_ANOMALY_BF527(< 2))
 /* pTempCurrent Not Present in ADI_BOOT_DATA Structure */
-#define ANOMALY_05000392 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000392 (_ANOMALY_BF527(< 2))
 /* Deprecated Value of dTempByteCount in ADI_BOOT_DATA Structure */
-#define ANOMALY_05000393 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000393 (_ANOMALY_BF527(< 2))
 /* Log Buffer Not Functional */
-#define ANOMALY_05000394 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000394 (_ANOMALY_BF527(< 2))
 /* Hook Routine Not Functional */
-#define ANOMALY_05000395 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000395 (_ANOMALY_BF527(< 2))
 /* Header Indirect Bit Not Functional */
-#define ANOMALY_05000396 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000396 (_ANOMALY_BF527(< 2))
 /* BK_ONES, BK_ZEROS, and BK_DATECODE Constants Not Functional */
-#define ANOMALY_05000397 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000397 (_ANOMALY_BF527(< 2))
 /* SWRESET, DFRESET and WDRESET Bits in the SYSCR Register Not Functional */
-#define ANOMALY_05000398 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000398 (_ANOMALY_BF527(< 2))
 /* BCODE_NOBOOT in BCODE Field of SYSCR Register Not Functional */
-#define ANOMALY_05000399 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000399 (_ANOMALY_BF527(< 2))
 /* PPI Data Signals D0 and D8 do not Tristate After Disabling PPI */
-#define ANOMALY_05000401 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000401 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Level-Sensitive External GPIO Wakeups May Cause Indefinite Stall */
-#define ANOMALY_05000403 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000403 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Lockbox SESR Disallows Certain User Interrupts */
-#define ANOMALY_05000404 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000404 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Lockbox SESR Firmware Does Not Save/Restore Full Context */
 #define ANOMALY_05000405 (1)
 /* Lockbox SESR Firmware Arguments Are Not Retained After First Initialization */
-#define ANOMALY_05000407 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000407 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Lockbox Firmware Memory Cleanup Routine Does not Clear Registers */
 #define ANOMALY_05000408 (1)
 /* Lockbox firmware leaves MDMA0 channel enabled */
-#define ANOMALY_05000409 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000409 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Incorrect Default Internal Voltage Regulator Setting */
-#define ANOMALY_05000410 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000410 (_ANOMALY_BF527(< 2))
 /* bfrom_SysControl() Firmware Function Cannot be Used to Enter Power Saving Modes */
-#define ANOMALY_05000411 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000411 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* OTP_CHECK_FOR_PREV_WRITE Bit is Not Functional in bfrom_OtpWrite() API */
-#define ANOMALY_05000414 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000414 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* DEB2_URGENT Bit Not Functional */
-#define ANOMALY_05000415 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000415 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Speculative Fetches Can Cause Undesired External FIFO Operations */
 #define ANOMALY_05000416 (1)
 /* SPORT0 Ignores External TSCLK0 on PG14 When TMR6 is an Output */
-#define ANOMALY_05000417 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
-/* tSFSPE and tHFSPE Do Not Meet Data Sheet Specifications */
-#define ANOMALY_05000418 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000417 (_ANOMALY_BF527(< 2))
+/* PPI Timing Requirements tSFSPE and tHFSPE Do Not Meet Data Sheet Specifications */
+#define ANOMALY_05000418 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* USB PLL_STABLE Bit May Not Accurately Reflect the USB PLL's Status */
-#define ANOMALY_05000420 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000420 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* TWI Fall Time (Tof) May Violate the Minimum I2C Specification */
 #define ANOMALY_05000421 (1)
 /* TWI Input Capacitance (Ci) May Violate the Maximum I2C Specification */
-#define ANOMALY_05000422 (ANOMALY_BF527 && __SILICON_REVISION__ > 1)
+#define ANOMALY_05000422 (_ANOMALY_BF526_BF527(> 0, > 1))
 /* Certain Ethernet Frames With Errors are Misclassified in RMII Mode */
-#define ANOMALY_05000423 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000423 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Internal Voltage Regulator Not Trimmed */
-#define ANOMALY_05000424 (ANOMALY_BF527 && __SILICON_REVISION__ < 2)
+#define ANOMALY_05000424 (_ANOMALY_BF527(< 2))
 /* Multichannel SPORT Channel Misalignment Under Specific Configuration */
-#define ANOMALY_05000425 (__SILICON_REVISION__ < 2)
-/* Speculative Fetches of Indirect-Pointer Instructions Can Cause Spurious Hardware Errors */
+#define ANOMALY_05000425 (_ANOMALY_BF526_BF527(< 1, < 2))
+/* Speculative Fetches of Indirect-Pointer Instructions Can Cause False Hardware Errors */
 #define ANOMALY_05000426 (1)
 /* WB_EDGE Bit in NFC_IRQSTAT Incorrectly Reflects Buffer Status Instead of IRQ Status */
-#define ANOMALY_05000429 (__SILICON_REVISION__ < 2)
+#define ANOMALY_05000429 (_ANOMALY_BF526_BF527(< 1, < 2))
 /* Software System Reset Corrupts PLL_LOCKCNT Register */
-#define ANOMALY_05000430 (ANOMALY_BF527 && __SILICON_REVISION__ > 1)
+#define ANOMALY_05000430 (_ANOMALY_BF527(> 1))
+/* Incorrect Use of Stack in Lockbox Firmware During Authentication */
+#define ANOMALY_05000431 (1)
 /* bfrom_SysControl() Does Not Clear SIC_IWR1 Before Executing PLL Programming Sequence */
-#define ANOMALY_05000432 (ANOMALY_BF526)
+#define ANOMALY_05000432 (_ANOMALY_BF526(< 1))
 /* Certain SIC Registers are not Reset After Soft or Core Double Fault Reset */
-#define ANOMALY_05000435 ((ANOMALY_BF526 && __SILICON_REVISION__ < 1) || ANOMALY_BF527)
+#define ANOMALY_05000435 (_ANOMALY_BF526_BF527(< 1, >= 0))
+/* Preboot Cannot be Used to Alter the PLL_DIV Register */
+#define ANOMALY_05000439 (_ANOMALY_BF526_BF527(< 1, >= 0))
+/* bfrom_SysControl() Cannot be Used to Write the PLL_DIV Register */
+#define ANOMALY_05000440 (_ANOMALY_BF526_BF527(< 1, >= 0))
+/* OTP Write Accesses Not Supported */
+#define ANOMALY_05000442 (_ANOMALY_BF527(< 1))
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
+/* The WURESET Bit in the SYSCR Register is not Functional */
+#define ANOMALY_05000445 (1)
+/* BCODE_QUICKBOOT, BCODE_ALLBOOT, and BCODE_FULLBOOT Settings in SYSCR Register Not Functional */
+#define ANOMALY_05000451 (1)
+/* Incorrect Default Hysteresis Setting for RESET, NMI, and BMODE Signals */
+#define ANOMALY_05000452 (_ANOMALY_BF526_BF527(< 1, >= 0))
+/* USB Receive Interrupt Is Not Generated in DMA Mode 1 */
+#define ANOMALY_05000456 (1)
+/* Host DMA Port Responds to Certain Bus Activity Without HOST_CE Assertion */
+#define ANOMALY_05000457 (1)
+/* False Hardware Error when RETI points to invalid memory */
+#define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
+#define ANOMALY_05000099 (0)
+#define ANOMALY_05000120 (0)
 #define ANOMALY_05000125 (0)
+#define ANOMALY_05000149 (0)
 #define ANOMALY_05000158 (0)
+#define ANOMALY_05000171 (0)
+#define ANOMALY_05000179 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000215 (0)
+#define ANOMALY_05000220 (0)
+#define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
+#define ANOMALY_05000231 (0)
+#define ANOMALY_05000233 (0)
+#define ANOMALY_05000242 (0)
 #define ANOMALY_05000244 (0)
+#define ANOMALY_05000248 (0)
+#define ANOMALY_05000250 (0)
 #define ANOMALY_05000261 (0)
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
+#define ANOMALY_05000274 (0)
 #define ANOMALY_05000278 (0)
 #define ANOMALY_05000285 (0)
+#define ANOMALY_05000287 (0)
+#define ANOMALY_05000301 (0)
 #define ANOMALY_05000305 (0)
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000312 (0)
 #define ANOMALY_05000323 (0)
+#define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000400 (0)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000447 (0)
 #define ANOMALY_05000448 (0)
+#define ANOMALY_05000450 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf533/include/mach/anomaly.h b/arch/blackfin/mach-bf533/include/mach/anomaly.h
index 1cf893e..31145b5 100644
--- a/arch/blackfin/mach-bf533/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf533/include/mach/anomaly.h
@@ -6,7 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
-/* This file shoule be up to date with:
+/* This file should be up to date with:
  *  - Revision E, 09/18/2008; ADSP-BF531/BF532/BF533 Blackfin Processor Anomaly List
  */
 
@@ -34,12 +34,12 @@
 # define ANOMALY_BF533 0
 #endif
 
-/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot 2 Not Supported */
+/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
 #define ANOMALY_05000074 (1)
 /* UART Line Status Register (UART_LSR) Bits Are Not Updated at the Same Time */
 #define ANOMALY_05000099 (__SILICON_REVISION__ < 5)
 /* Watchpoint Status Register (WPSTAT) Bits Are Set on Every Corresponding Match */
-#define ANOMALY_05000105 (1)
+#define ANOMALY_05000105 (__SILICON_REVISION__ > 2)
 /* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
@@ -48,7 +48,7 @@
 #define ANOMALY_05000158 (__SILICON_REVISION__ < 5)
 /* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
 #define ANOMALY_05000166 (1)
-/* Turning Serial Ports on with External Frame Syncs */
+/* Turning SPORTs on while External Frame Sync Is Active May Corrupt Data */
 #define ANOMALY_05000167 (1)
 /* PPI_COUNT Cannot Be Programmed to 0 in General Purpose TX or RX Modes */
 #define ANOMALY_05000179 (__SILICON_REVISION__ < 5)
@@ -67,9 +67,9 @@
 /* Current DMA Address Shows Wrong Value During Carry Fix */
 #define ANOMALY_05000199 (__SILICON_REVISION__ < 4)
 /* SPORT TFS and DT Are Incorrectly Driven During Inactive Channels in Certain Conditions */
-#define ANOMALY_05000200 (__SILICON_REVISION__ < 5)
+#define ANOMALY_05000200 (__SILICON_REVISION__ == 3 || __SILICON_REVISION__ == 4)
 /* Receive Frame Sync Not Ignored During Active Frames in SPORT Multi-Channel Mode */
-#define ANOMALY_05000201 (__SILICON_REVISION__ < 4)
+#define ANOMALY_05000201 (__SILICON_REVISION__ == 3)
 /* Possible Infinite Stall with Specific Dual-DAG Situation */
 #define ANOMALY_05000202 (__SILICON_REVISION__ < 5)
 /* Specific Sequence That Can Cause DMA Error or DMA Stopping */
@@ -104,7 +104,7 @@
 #define ANOMALY_05000242 (__SILICON_REVISION__ < 5)
 /* If I-Cache Is On, CSYNC/SSYNC/IDLE Around Change of Control Causes Failures */
 #define ANOMALY_05000244 (__SILICON_REVISION__ < 5)
-/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+/* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (1)
 /* Data CPLBs Should Prevent Spurious Hardware Errors */
 #define ANOMALY_05000246 (__SILICON_REVISION__ < 5)
@@ -137,7 +137,7 @@
 /* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Decrease */
 #define ANOMALY_05000270 (__SILICON_REVISION__ < 5)
 /* Spontaneous Reset of Internal Voltage Regulator */
-#define ANOMALY_05000271 (__SILICON_REVISION__ < 4)
+#define ANOMALY_05000271 (__SILICON_REVISION__ == 3)
 /* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
 #define ANOMALY_05000272 (1)
 /* Writes to Synchronous SDRAM Memory May Be Lost */
@@ -165,14 +165,14 @@
 /* New Feature: Additional PPI Frame Sync Sampling Options (Not Available On Older Silicon) */
 #define ANOMALY_05000306 (__SILICON_REVISION__ < 5)
 /* SCKELOW Bit Does Not Maintain State Through Hibernate */
-#define ANOMALY_05000307 (1)
+#define ANOMALY_05000307 (1)	/* note: brokenness is noted in documentation, not anomaly sheet */
 /* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
 #define ANOMALY_05000310 (1)
 /* Erroneous Flag (GPIO) Pin Operations under Specific Sequences */
 #define ANOMALY_05000311 (__SILICON_REVISION__ < 6)
 /* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (__SILICON_REVISION__ < 6)
-/* PPI Is Level-Sensitive on First Transfer */
+/* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
 #define ANOMALY_05000313 (__SILICON_REVISION__ < 6)
 /* Killed System MMR Write Completes Erroneously On Next System MMR Access */
 #define ANOMALY_05000315 (__SILICON_REVISION__ < 6)
@@ -200,17 +200,63 @@
 #define ANOMALY_05000426 (1)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
+/* False Hardware Error when RETI points to invalid memory */
+#define ANOMALY_05000461 (1)
 
 /* These anomalies have been "phased" out of analog.com anomaly sheets and are
  * here to show running on older silicon just isn't feasible.
  */
 
+/* Internal voltage regulator can't be modified via register writes */
+#define ANOMALY_05000066 (__SILICON_REVISION__ < 2)
 /* Watchpoints (Hardware Breakpoints) are not supported */
 #define ANOMALY_05000067 (__SILICON_REVISION__ < 3)
+/* SDRAM PSSE bit cannot be set again after SDRAM Powerup */
+#define ANOMALY_05000070 (__SILICON_REVISION__ < 2)
+/* Writing FIO_DIR can corrupt a programmable flag's data */
+#define ANOMALY_05000079 (__SILICON_REVISION__ < 2)
+/* Timer Auto-Baud Mode requires the UART clock to be enabled */
+#define ANOMALY_05000086 (__SILICON_REVISION__ < 2)
+/* Internal Clocking Modes on SPORT0 not supported */
+#define ANOMALY_05000088 (__SILICON_REVISION__ < 2)
+/* Internal voltage regulator does not wake up from an RTC wakeup */
+#define ANOMALY_05000092 (__SILICON_REVISION__ < 2)
+/* The IFLUSH instruction must be preceded by a CSYNC instruction */
+#define ANOMALY_05000093 (__SILICON_REVISION__ < 2)
+/* Vectoring to an instruction that is presently being filled into the instruction cache may cause erroneous behavior */
+#define ANOMALY_05000095 (__SILICON_REVISION__ < 2)
+/* PREFETCH, FLUSH, and FLUSHINV must be followed by a CSYNC */
+#define ANOMALY_05000096 (__SILICON_REVISION__ < 2)
+/* Performance Monitor 0 and 1 are swapped when monitoring memory events */
+#define ANOMALY_05000097 (__SILICON_REVISION__ < 2)
+/* 32-bit SPORT DMA will be word reversed */
+#define ANOMALY_05000098 (__SILICON_REVISION__ < 2)
+/* Incorrect status in the UART_IIR register */
+#define ANOMALY_05000100 (__SILICON_REVISION__ < 2)
+/* Reading X_MODIFY or Y_MODIFY while DMA channel is active */
+#define ANOMALY_05000101 (__SILICON_REVISION__ < 2)
+/* Descriptor-based MemDMA may lock up with 32-bit transfers or if transfers span 64KB buffers */
+#define ANOMALY_05000102 (__SILICON_REVISION__ < 2)
+/* Incorrect value written to the cycle counters */
+#define ANOMALY_05000103 (__SILICON_REVISION__ < 2)
+/* Stores to L1 Data memory incorrect when a specific sequence is followed */
+#define ANOMALY_05000104 (__SILICON_REVISION__ < 2)
+/* Programmable Flag (PF3) functionality not supported in all PPI modes */
+#define ANOMALY_05000106 (__SILICON_REVISION__ < 2)
+/* Data store can be lost when targeting a cache line fill */
+#define ANOMALY_05000107 (__SILICON_REVISION__ < 2)
 /* Reserved bits in SYSCFG register not set at power on */
 #define ANOMALY_05000109 (__SILICON_REVISION__ < 3)
+/* Infinite Core Stall */
+#define ANOMALY_05000114 (__SILICON_REVISION__ < 2)
+/* PPI_FSx may glitch when generated by the on chip Timers */
+#define ANOMALY_05000115 (__SILICON_REVISION__ < 2)
 /* Trace Buffers may record discontinuities into emulation mode and/or exception, NMI, reset handlers */
 #define ANOMALY_05000116 (__SILICON_REVISION__ < 3)
+/* DTEST registers allow access to Data Cache when DTEST_COMMAND< 14 >= 0 */
+#define ANOMALY_05000117 (__SILICON_REVISION__ < 2)
+/* Booting from an 8-bit or 24-bit Addressable SPI device is not supported */
+#define ANOMALY_05000118 (__SILICON_REVISION__ < 2)
 /* DTEST_COMMAND initiated memory access may be incorrect if data cache or DMA is active */
 #define ANOMALY_05000123 (__SILICON_REVISION__ < 3)
 /* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1, or 1:1 */
@@ -222,7 +268,9 @@
 /* DMEM_CONTROL is not set on Reset */
 #define ANOMALY_05000137 (__SILICON_REVISION__ < 3)
 /* SPI boot will not complete if there is a zero fill block in the loader file */
-#define ANOMALY_05000138 (__SILICON_REVISION__ < 3)
+#define ANOMALY_05000138 (__SILICON_REVISION__ == 2)
+/* Timerx_Config must be set for using the PPI in GP output mode with internal Frame Syncs */
+#define ANOMALY_05000139 (__SILICON_REVISION__ < 2)
 /* Allowing the SPORT RX FIFO to fill will cause an overflow */
 #define ANOMALY_05000140 (__SILICON_REVISION__ < 3)
 /* An Infinite Stall occurs with a particular sequence of consecutive dual dag events */
@@ -237,17 +285,17 @@
 #define ANOMALY_05000145 (__SILICON_REVISION__ < 3)
 /* MDMA may lose the first few words of a descriptor chain */
 #define ANOMALY_05000146 (__SILICON_REVISION__ < 3)
-/* The source MDMA descriptor may stop with a DMA Error */
+/* Source MDMA descriptor may stop with a DMA Error near beginning of descriptor fetch */
 #define ANOMALY_05000147 (__SILICON_REVISION__ < 3)
 /* When booting from a 16-bit asynchronous memory device, the upper 8-bits of each word must be 0x00 */
 #define ANOMALY_05000148 (__SILICON_REVISION__ < 3)
 /* Frame Delay in SPORT Multichannel Mode */
 #define ANOMALY_05000153 (__SILICON_REVISION__ < 3)
-/* SPORT TFS signal is active in Multi-channel mode outside of valid channels */
+/* SPORT TFS signal stays active in multichannel mode outside of valid channels */
 #define ANOMALY_05000154 (__SILICON_REVISION__ < 3)
 /* Timer1 can not be used for PWMOUT mode when a certain PPI mode is in use */
 #define ANOMALY_05000155 (__SILICON_REVISION__ < 3)
-/* A killed 32-bit System MMR write will lead to the next system MMR access thinking it should be 32-bit. */
+/* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
 #define ANOMALY_05000157 (__SILICON_REVISION__ < 3)
 /* SPORT transmit data is not gated by external frame sync in certain conditions */
 #define ANOMALY_05000163 (__SILICON_REVISION__ < 3)
@@ -275,15 +323,27 @@
 #define ANOMALY_05000206 (__SILICON_REVISION__ < 3)
 
 /* Anomalies that don't exist on this proc */
+#define ANOMALY_05000120 (0)
+#define ANOMALY_05000149 (0)
+#define ANOMALY_05000171 (0)
+#define ANOMALY_05000220 (0)
+#define ANOMALY_05000248 (0)
 #define ANOMALY_05000266 (0)
+#define ANOMALY_05000274 (0)
+#define ANOMALY_05000287 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (1)
+#define ANOMALY_05000362 (1)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
+#define ANOMALY_05000389 (0)
 #define ANOMALY_05000412 (0)
+#define ANOMALY_05000430 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
 #define ANOMALY_05000447 (0)
 #define ANOMALY_05000448 (0)
+#define ANOMALY_05000456 (0)
+#define ANOMALY_05000450 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf537/include/mach/anomaly.h b/arch/blackfin/mach-bf537/include/mach/anomaly.h
index 1bfd80c..fc96634 100644
--- a/arch/blackfin/mach-bf537/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf537/include/mach/anomaly.h
@@ -6,7 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
-/* This file shoule be up to date with:
+/* This file should be up to date with:
  *  - Revision D, 09/18/2008; ADSP-BF534/ADSP-BF536/ADSP-BF537 Blackfin Processor Anomaly List
  */
 
@@ -36,77 +36,75 @@
 
 /* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
 #define ANOMALY_05000074 (1)
-/* DMA_RUN bit is not valid after a Peripheral Receive Channel DMA stops */
+/* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)
-/* Rx.H cannot be used to access 16-bit System MMR registers */
+/* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
 /* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
 #define ANOMALY_05000157 (__SILICON_REVISION__ < 2)
-/* Turning SPORTs on while External Frame Sync Is Active May Corrupt Data */
-#define ANOMALY_05000167 (1)
-/* PPI_DELAY not functional in PPI modes with 0 frame syncs */
+/* PPI_DELAY Not Functional in PPI Modes with 0 Frame Syncs */
 #define ANOMALY_05000180 (1)
 /* Instruction Cache Is Not Functional */
 #define ANOMALY_05000237 (__SILICON_REVISION__ < 2)
-/* If i-cache is on, CSYNC/SSYNC/IDLE around Change of Control causes failures */
+/* If I-Cache Is On, CSYNC/SSYNC/IDLE Around Change of Control Causes Failures */
 #define ANOMALY_05000244 (__SILICON_REVISION__ < 3)
-/* Spurious Hardware Error from an access in the shadow of a conditional branch */
+/* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (1)
 /* CLKIN Buffer Output Enable Reset Behavior Is Changed */
 #define ANOMALY_05000247 (1)
-/* Incorrect Bit-Shift of Data Word in Multichannel (TDM) mode in certain conditions */
+/* Incorrect Bit Shift of Data Word in Multichannel (TDM) Mode in Certain Conditions */
 #define ANOMALY_05000250 (__SILICON_REVISION__ < 3)
 /* EMAC Tx DMA error after an early frame abort */
 #define ANOMALY_05000252 (__SILICON_REVISION__ < 3)
-/* Maximum external clock speed for Timers */
+/* Maximum External Clock Speed for Timers */
 #define ANOMALY_05000253 (__SILICON_REVISION__ < 3)
-/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT mode with external clock */
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT Mode with External Clock */
 #define ANOMALY_05000254 (__SILICON_REVISION__ > 2)
-/* Entering Hibernate Mode with RTC Seconds event interrupt not functional */
+/* Entering Hibernate State with RTC Seconds Interrupt Not Functional */
 #define ANOMALY_05000255 (__SILICON_REVISION__ < 3)
 /* EMAC MDIO input latched on wrong MDC edge */
 #define ANOMALY_05000256 (__SILICON_REVISION__ < 3)
-/* Interrupt/Exception during short hardware loop may cause bad instruction fetches */
+/* Interrupt/Exception During Short Hardware Loop May Cause Bad Instruction Fetches */
 #define ANOMALY_05000257 (__SILICON_REVISION__ < 3)
-/* Instruction Cache is corrupted when bits 9 and 12 of the ICPLB Data registers differ */
+/* Instruction Cache Is Corrupted When Bits 9 and 12 of the ICPLB Data Registers Differ */
 #define ANOMALY_05000258 (((ANOMALY_BF536 || ANOMALY_BF537) && __SILICON_REVISION__ == 1) || __SILICON_REVISION__ == 2)
-/* ICPLB_STATUS MMR register may be corrupted */
+/* ICPLB_STATUS MMR Register May Be Corrupted */
 #define ANOMALY_05000260 (__SILICON_REVISION__ == 2)
-/* DCPLB_FAULT_ADDR MMR register may be corrupted */
+/* DCPLB_FAULT_ADDR MMR Register May Be Corrupted */
 #define ANOMALY_05000261 (__SILICON_REVISION__ < 3)
-/* Stores to data cache may be lost */
+/* Stores To Data Cache May Be Lost */
 #define ANOMALY_05000262 (__SILICON_REVISION__ < 3)
-/* Hardware loop corrupted when taking an ICPLB exception */
+/* Hardware Loop Corrupted When Taking an ICPLB Exception */
 #define ANOMALY_05000263 (__SILICON_REVISION__ == 2)
-/* CSYNC/SSYNC/IDLE causes infinite stall in second to last instruction in hardware loop */
+/* CSYNC/SSYNC/IDLE Causes Infinite Stall in Penultimate Instruction in Hardware Loop */
 #define ANOMALY_05000264 (__SILICON_REVISION__ < 3)
-/* Sensitivity to noise with slow input edge rates on external SPORT TX and RX clocks */
+/* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
 #define ANOMALY_05000265 (1)
 /* Memory DMA error when peripheral DMA is running with non-zero DEB_TRAFFIC_PERIOD */
 #define ANOMALY_05000268 (__SILICON_REVISION__ < 3)
-/* High I/O activity causes output voltage of internal voltage regulator (VDDint) to decrease */
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Decrease */
 #define ANOMALY_05000270 (__SILICON_REVISION__ < 3)
-/* Certain data cache write through modes fail for VDDint <=0.9V */
+/* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
 #define ANOMALY_05000272 (1)
-/* Writes to Synchronous SDRAM memory may be lost */
+/* Writes to Synchronous SDRAM Memory May Be Lost */
 #define ANOMALY_05000273 (__SILICON_REVISION__ < 3)
-/* Writes to an I/O data register one SCLK cycle after an edge is detected may clear interrupt */
+/* Writes to an I/O Data Register One SCLK Cycle after an Edge Is Detected May Clear Interrupt */
 #define ANOMALY_05000277 (__SILICON_REVISION__ < 3)
-/* Disabling Peripherals with DMA running may cause DMA system instability */
+/* Disabling Peripherals with DMA Running May Cause DMA System Instability */
 #define ANOMALY_05000278 (((ANOMALY_BF536 || ANOMALY_BF537) && __SILICON_REVISION__ < 3) || (ANOMALY_BF534 && __SILICON_REVISION__ < 2))
 /* SPI Master boot mode does not work well with Atmel Data flash devices */
 #define ANOMALY_05000280 (1)
-/* False Hardware Error Exception when ISR context is not restored */
+/* False Hardware Error Exception When ISR Context Is Not Restored */
 #define ANOMALY_05000281 (__SILICON_REVISION__ < 3)
-/* Memory DMA corruption with 32-bit data and traffic control */
+/* Memory DMA Corruption with 32-Bit Data and Traffic Control */
 #define ANOMALY_05000282 (__SILICON_REVISION__ < 3)
 /* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
 #define ANOMALY_05000283 (__SILICON_REVISION__ < 3)
 /* New Feature: EMAC TX DMA Word Alignment (Not Available On Older Silicon) */
 #define ANOMALY_05000285 (__SILICON_REVISION__ < 3)
-/* SPORTs may receive bad data if FIFOs fill up */
+/* SPORTs May Receive Bad Data If FIFOs Fill Up */
 #define ANOMALY_05000288 (__SILICON_REVISION__ < 3)
-/* Memory to memory DMA source/destination descriptors must be in same memory space */
+/* Memory-To-Memory DMA Source/Destination Descriptors Must Be in Same Memory Space */
 #define ANOMALY_05000301 (1)
 /* SSYNCs After Writes To CAN/DMA MMR Registers Are Not Always Handled Correctly */
 #define ANOMALY_05000304 (__SILICON_REVISION__ < 3)
@@ -116,11 +114,11 @@
 #define ANOMALY_05000307 (__SILICON_REVISION__ < 3)
 /* Writing UART_THR while UART clock is disabled sends erroneous start bit */
 #define ANOMALY_05000309 (__SILICON_REVISION__ < 3)
-/* False hardware errors caused by fetches at the boundary of reserved memory */
+/* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
 #define ANOMALY_05000310 (1)
-/* Errors when SSYNC, CSYNC, or loads to LT, LB and LC registers are interrupted */
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (1)
-/* PPI is level sensitive on first transfer */
+/* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
 #define ANOMALY_05000313 (1)
 /* Killed System MMR Write Completes Erroneously On Next System MMR Access */
 #define ANOMALY_05000315 (__SILICON_REVISION__ < 3)
@@ -156,24 +154,46 @@
 #define ANOMALY_05000426 (1)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
+/* False Hardware Error when RETI points to invalid memory */
+#define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
+#define ANOMALY_05000099 (0)
+#define ANOMALY_05000120 (0)
 #define ANOMALY_05000125 (0)
+#define ANOMALY_05000149 (0)
 #define ANOMALY_05000158 (0)
+#define ANOMALY_05000171 (0)
+#define ANOMALY_05000179 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000215 (0)
+#define ANOMALY_05000220 (0)
+#define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
+#define ANOMALY_05000231 (0)
+#define ANOMALY_05000233 (0)
+#define ANOMALY_05000242 (0)
+#define ANOMALY_05000248 (0)
 #define ANOMALY_05000266 (0)
+#define ANOMALY_05000274 (0)
+#define ANOMALY_05000287 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (1)
+#define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
+#define ANOMALY_05000389 (0)
+#define ANOMALY_05000400 (0)
 #define ANOMALY_05000412 (0)
+#define ANOMALY_05000430 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
 #define ANOMALY_05000447 (0)
 #define ANOMALY_05000448 (0)
+#define ANOMALY_05000456 (0)
+#define ANOMALY_05000450 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf538/include/mach/anomaly.h b/arch/blackfin/mach-bf538/include/mach/anomaly.h
index 3a56998..175ca9e 100644
--- a/arch/blackfin/mach-bf538/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf538/include/mach/anomaly.h
@@ -6,7 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
-/* This file shoule be up to date with:
+/* This file should be up to date with:
  *  - Revision G, 09/18/2008; ADSP-BF538/BF538F Blackfin Processor Anomaly List
  *  - Revision L, 09/18/2008; ADSP-BF539/BF539F Blackfin Processor Anomaly List
  */
@@ -14,17 +14,29 @@
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
+/* We do not support old silicon - sorry */
 #if __SILICON_REVISION__ < 4
-# error will not work on BF538 silicon version 0.0, 0.1, 0.2, or 0.3
+# error will not work on BF538/BF539 silicon version 0.0, 0.1, 0.2, or 0.3
 #endif
 
-/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
+#if defined(__ADSPBF538__)
+# define ANOMALY_BF538 1
+#else
+# define ANOMALY_BF538 0
+#endif
+#if defined(__ADSPBF539__)
+# define ANOMALY_BF539 1
+#else
+# define ANOMALY_BF539 0
+#endif
+
+/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
 #define ANOMALY_05000074 (1)
 /* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
-/* PPI Data Lengths between 8 and 16 Do Not Zero Out Upper Bits */
+/* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
 #define ANOMALY_05000166 (1)
 /* PPI_COUNT Cannot Be Programmed to 0 in General Purpose TX or RX Modes */
 #define ANOMALY_05000179 (1)
@@ -40,13 +52,13 @@
 #define ANOMALY_05000229 (1)
 /* PPI_FS3 Is Not Driven in 2 or 3 Internal Frame Sync Transmit Modes */
 #define ANOMALY_05000233 (1)
-/* If i-cache is on, CSYNC/SSYNC/IDLE around Change of Control causes failures */
+/* If I-Cache Is On, CSYNC/SSYNC/IDLE Around Change of Control Causes Failures */
 #define ANOMALY_05000244 (__SILICON_REVISION__ < 3)
-/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+/* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (1)
 /* Maximum External Clock Speed for Timers */
 #define ANOMALY_05000253 (1)
-/* DCPLB_FAULT_ADDR MMR register may be corrupted */
+/* DCPLB_FAULT_ADDR MMR Register May Be Corrupted */
 #define ANOMALY_05000261 (__SILICON_REVISION__ < 3)
 /* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Decrease */
 #define ANOMALY_05000270 (__SILICON_REVISION__ < 4)
@@ -58,11 +70,11 @@
 #define ANOMALY_05000277 (__SILICON_REVISION__ < 4)
 /* Disabling Peripherals with DMA Running May Cause DMA System Instability */
 #define ANOMALY_05000278 (__SILICON_REVISION__ < 4)
-/* False Hardware Error Exception when ISR Context Is Not Restored */
+/* False Hardware Error Exception When ISR Context Is Not Restored */
 #define ANOMALY_05000281 (__SILICON_REVISION__ < 4)
 /* Memory DMA Corruption with 32-Bit Data and Traffic Control */
 #define ANOMALY_05000282 (__SILICON_REVISION__ < 4)
-/* System MMR Write Is Stalled Indefinitely when Killed in a Particular Stage */
+/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
 #define ANOMALY_05000283 (__SILICON_REVISION__ < 4)
 /* SPORTs May Receive Bad Data If FIFOs Fill Up */
 #define ANOMALY_05000288 (__SILICON_REVISION__ < 4)
@@ -80,14 +92,14 @@
 #define ANOMALY_05000307 (__SILICON_REVISION__ < 4)
 /* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
 #define ANOMALY_05000310 (1)
-/* Errors when SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (__SILICON_REVISION__ < 5)
-/* PPI Is Level-Sensitive on First Transfer */
+/* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
 #define ANOMALY_05000313 (__SILICON_REVISION__ < 4)
-/* Killed System MMR Write Completes Erroneously on Next System MMR Access */
+/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
 #define ANOMALY_05000315 (__SILICON_REVISION__ < 4)
 /* PFx Glitch on Write to FIO_FLAG_D or FIO_FLAG_T */
-#define ANOMALY_05000318 (__SILICON_REVISION__ < 4)
+#define ANOMALY_05000318 (ANOMALY_BF539 && __SILICON_REVISION__ < 4)
 /* Regulator Programming Blocked when Hibernate Wakeup Source Remains Active */
 #define ANOMALY_05000355 (__SILICON_REVISION__ < 5)
 /* Serial Port (SPORT) Multichannel Transmit Failure when Channel 0 Is Disabled */
@@ -114,23 +126,45 @@
 #define ANOMALY_05000436 (__SILICON_REVISION__ > 3)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
+/* False Hardware Error when RETI points to invalid memory */
+#define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
+#define ANOMALY_05000099 (0)
+#define ANOMALY_05000120 (0)
+#define ANOMALY_05000149 (0)
 #define ANOMALY_05000158 (0)
+#define ANOMALY_05000171 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000215 (0)
+#define ANOMALY_05000220 (0)
+#define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
+#define ANOMALY_05000231 (0)
+#define ANOMALY_05000242 (0)
+#define ANOMALY_05000248 (0)
+#define ANOMALY_05000250 (0)
+#define ANOMALY_05000254 (0)
 #define ANOMALY_05000263 (0)
+#define ANOMALY_05000274 (0)
+#define ANOMALY_05000287 (0)
 #define ANOMALY_05000305 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (1)
+#define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
+#define ANOMALY_05000389 (0)
+#define ANOMALY_05000400 (0)
 #define ANOMALY_05000412 (0)
+#define ANOMALY_05000430 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
 #define ANOMALY_05000447 (0)
 #define ANOMALY_05000448 (0)
+#define ANOMALY_05000456 (0)
+#define ANOMALY_05000450 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf548/include/mach/anomaly.h b/arch/blackfin/mach-bf548/include/mach/anomaly.h
index 882e40c..c510ae6 100644
--- a/arch/blackfin/mach-bf548/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf548/include/mach/anomaly.h
@@ -6,26 +6,31 @@
  * Licensed under the GPL-2 or later.
  */
 
-/* This file shoule be up to date with:
+/* This file should be up to date with:
  *  - Revision H, 01/16/2009; ADSP-BF542/BF544/BF547/BF548/BF549 Blackfin Processor Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
-/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
+/* We do not support 0.0 or 0.1 silicon - sorry */
+#if __SILICON_REVISION__ < 2
+# error will not work on BF548 silicon version 0.0, or 0.1
+#endif
+
+/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
 #define ANOMALY_05000074 (1)
 /* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
-/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+/* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (1)
 /* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
 #define ANOMALY_05000265 (1)
 /* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
 #define ANOMALY_05000272 (1)
-/* False Hardware Error Exception when ISR context is not restored */
+/* False Hardware Error Exception When ISR Context Is Not Restored */
 #define ANOMALY_05000281 (__SILICON_REVISION__ < 1)
 /* SSYNCs After Writes To CAN/DMA MMR Registers Are Not Always Handled Correctly */
 #define ANOMALY_05000304 (__SILICON_REVISION__ < 1)
@@ -59,7 +64,7 @@
 #define ANOMALY_05000340 (__SILICON_REVISION__ < 1)
 /* Boot Host Wait (HWAIT) and Boot Host Wait Alternate (HWAITA) Signals Are Swapped */
 #define ANOMALY_05000344 (__SILICON_REVISION__ < 1)
-/* USB Calibration Value Is Not Intialized */
+/* USB Calibration Value Is Not Initialized */
 #define ANOMALY_05000346 (__SILICON_REVISION__ < 1)
 /* USB Calibration Value to use */
 #define ANOMALY_05000346_value 0x5411
@@ -147,11 +152,11 @@
 #define ANOMALY_05000416 (1)
 /* Multichannel SPORT Channel Misalignment Under Specific Configuration */
 #define ANOMALY_05000425 (1)
-/* Speculative Fetches of Indirect-Pointer Instructions Can Cause Spurious Hardware Errors */
+/* Speculative Fetches of Indirect-Pointer Instructions Can Cause False Hardware Errors */
 #define ANOMALY_05000426 (1)
 /* CORE_EPPI_PRIO bit and SYS_EPPI_PRIO bit in the HMDMA1_CONTROL register are not functional */
 #define ANOMALY_05000427 (__SILICON_REVISION__ < 2)
-/* WB_EDGE Bit in NFC_IRQSTAT Incorrectly Behaves as a Buffer Status Bit Instead of an IRQ Status Bit */
+/* WB_EDGE Bit in NFC_IRQSTAT Incorrectly Reflects Buffer Status Instead of IRQ Status */
 #define ANOMALY_05000429 (__SILICON_REVISION__ < 2)
 /* Software System Reset Corrupts PLL_LOCKCNT Register */
 #define ANOMALY_05000430 (__SILICON_REVISION__ >= 2)
@@ -170,26 +175,49 @@
 /* Reduced Timing Margins on DDR Output Setup and Hold (tDS and tDH) */
 #define ANOMALY_05000449 (__SILICON_REVISION__ == 1)
 /* USB DMA Mode 1 Short Packet Data Corruption */
-#define ANOMALY_05000450 (1
+#define ANOMALY_05000450 (1)
+/* USB Receive Interrupt Is Not Generated in DMA Mode 1 */
+#define ANOMALY_05000456 (__SILICON_REVISION__ < 3)
+/* False Hardware Error when RETI points to invalid memory */
+#define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
+#define ANOMALY_05000099 (0)
+#define ANOMALY_05000120 (0)
 #define ANOMALY_05000125 (0)
+#define ANOMALY_05000149 (0)
 #define ANOMALY_05000158 (0)
+#define ANOMALY_05000171 (0)
+#define ANOMALY_05000179 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000215 (0)
+#define ANOMALY_05000220 (0)
+#define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
+#define ANOMALY_05000231 (0)
+#define ANOMALY_05000233 (0)
+#define ANOMALY_05000242 (0)
 #define ANOMALY_05000244 (0)
+#define ANOMALY_05000248 (0)
+#define ANOMALY_05000250 (0)
+#define ANOMALY_05000254 (0)
 #define ANOMALY_05000261 (0)
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
+#define ANOMALY_05000274 (0)
 #define ANOMALY_05000278 (0)
+#define ANOMALY_05000287 (0)
+#define ANOMALY_05000301 (0)
 #define ANOMALY_05000305 (0)
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000323 (0)
+#define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
 #define ANOMALY_05000380 (0)
+#define ANOMALY_05000400 (0)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
diff --git a/arch/blackfin/mach-bf561/include/mach/anomaly.h b/arch/blackfin/mach-bf561/include/mach/anomaly.h
index d0b0b35..dccd396 100644
--- a/arch/blackfin/mach-bf561/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf561/include/mach/anomaly.h
@@ -6,7 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
-/* This file shoule be up to date with:
+/* This file should be up to date with:
  *  - Revision Q, 11/07/2008; ADSP-BF561 Blackfin Processor Anomaly List
  */
 
@@ -18,11 +18,11 @@
 # error will not work on BF561 silicon version 0.0, 0.1, 0.2, or 0.4
 #endif
 
-/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot 2 Not Supported */
+/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
 #define ANOMALY_05000074 (1)
 /* UART Line Status Register (UART_LSR) Bits Are Not Updated at the Same Time */
 #define ANOMALY_05000099 (__SILICON_REVISION__ < 5)
-/* Trace Buffers may contain errors in emulation mode and/or exception, NMI, reset handlers */
+/* Trace Buffers may record discontinuities into emulation mode and/or exception, NMI, reset handlers */
 #define ANOMALY_05000116 (__SILICON_REVISION__ < 3)
 /* Testset instructions restricted to 32-bit aligned memory locations */
 #define ANOMALY_05000120 (1)
@@ -40,7 +40,7 @@
 #define ANOMALY_05000136 (__SILICON_REVISION__ < 3)
 /* Allowing the SPORT RX FIFO to fill will cause an overflow */
 #define ANOMALY_05000140 (__SILICON_REVISION__ < 3)
-/* Infinite Stall may occur with a particular sequence of consecutive dual dag events */
+/* An Infinite Stall occurs with a particular sequence of consecutive dual dag events */
 #define ANOMALY_05000141 (__SILICON_REVISION__ < 3)
 /* Interrupts may be lost when a programmable input flag is configured to be edge sensitive */
 #define ANOMALY_05000142 (__SILICON_REVISION__ < 3)
@@ -80,7 +80,7 @@
 #define ANOMALY_05000163 (__SILICON_REVISION__ < 3)
 /* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
 #define ANOMALY_05000166 (1)
-/* Turning Serial Ports on with External Frame Syncs */
+/* Turning SPORTs on while External Frame Sync Is Active May Corrupt Data */
 #define ANOMALY_05000167 (1)
 /* SDRAM auto-refresh and subsequent Power Ups */
 #define ANOMALY_05000168 (__SILICON_REVISION__ < 5)
@@ -164,7 +164,7 @@
 #define ANOMALY_05000242 (__SILICON_REVISION__ < 5)
 /* If I-Cache Is On, CSYNC/SSYNC/IDLE Around Change of Control Causes Failures */
 #define ANOMALY_05000244 (__SILICON_REVISION__ < 5)
-/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+/* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (__SILICON_REVISION__ < 5)
 /* TESTSET operation forces stall on the other core */
 #define ANOMALY_05000248 (__SILICON_REVISION__ < 5)
@@ -208,7 +208,7 @@
 #define ANOMALY_05000275 (__SILICON_REVISION__ > 2)
 /* Timing Requirements Change for External Frame Sync PPI Modes with Non-Zero PPI_DELAY */
 #define ANOMALY_05000276 (__SILICON_REVISION__ < 5)
-/* Writes to an I/O data register one SCLK cycle after an edge is detected may clear interrupt */
+/* Writes to an I/O Data Register One SCLK Cycle after an Edge Is Detected May Clear Interrupt */
 #define ANOMALY_05000277 (__SILICON_REVISION__ < 3)
 /* Disabling Peripherals with DMA Running May Cause DMA System Instability */
 #define ANOMALY_05000278 (__SILICON_REVISION__ < 5)
@@ -232,7 +232,7 @@
 #define ANOMALY_05000310 (1)
 /* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (1)
-/* PPI Is Level-Sensitive on First Transfer */
+/* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
 #define ANOMALY_05000313 (1)
 /* Killed System MMR Write Completes Erroneously On Next System MMR Access */
 #define ANOMALY_05000315 (1)
@@ -276,18 +276,27 @@
 #define ANOMALY_05000428 (__SILICON_REVISION__ > 3)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
+/* False Hardware Error when RETI points to invalid memory */
+#define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
+#define ANOMALY_05000119 (0)
 #define ANOMALY_05000158 (0)
 #define ANOMALY_05000183 (0)
+#define ANOMALY_05000233 (0)
 #define ANOMALY_05000273 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000353 (1)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
+#define ANOMALY_05000389 (0)
+#define ANOMALY_05000400 (0)
+#define ANOMALY_05000430 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
 #define ANOMALY_05000447 (0)
 #define ANOMALY_05000448 (0)
+#define ANOMALY_05000456 (0)
+#define ANOMALY_05000450 (0)
 
 #endif
-- 
1.6.3.1

