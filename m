Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbZFLB0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbZFLB0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZFLB0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:26:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:63160 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbZFLB0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:26:04 -0400
Subject: [PATCH 1/1] EDAC: Add DDR3 memory type for MPC85xx EDAC
From: yshi <yang.shi@windriver.com>
To: dougthompson@xmission.com,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2009 09:26:10 +0800
Message-Id: <1244769970.3419.246.camel@yshi-desktop.CORP>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 12 Jun 2009 01:25:50.0344 (UTC) FILETIME=[B86AE080:01C9EAFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Since some new MPC85xx SOCs support DDR3 memory now, so
add DDR3 memory type for MPC85xx EDAC.

Signed-off-by: Yang Shi <yang.shi@windriver.com>
---
 b/drivers/edac/edac_core.h     |    4 ++++
 b/drivers/edac/edac_mc_sysfs.c |    4 +++-
 b/drivers/edac/mpc85xx_edac.c  |    6 ++++++
 b/drivers/edac/mpc85xx_edac.h  |    1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/edac/mpc85xx_edac.h
+++ b/drivers/edac/mpc85xx_edac.h
@@ -53,6 +53,7 @@
 
 #define DSC_SDTYPE_DDR         0x02000000
 #define DSC_SDTYPE_DDR2                0x03000000
+#define DSC_SDTYPE_DDR3                0x07000000
 #define DSC_X32_EN     0x00000020
 
 /* Err_Int_En */
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -149,6 +149,8 @@ enum mem_type {
        MEM_FB_DDR2,            /* fully buffered DDR2 */
        MEM_RDDR2,              /* Registered DDR2 RAM */
        MEM_XDR,                /* Rambus XDR */
+       MEM_DDR3,               /* DDR3 RAM */
+       MEM_RDDR3,              /* Registered DDR3 RAM */
 };
 
 #define MEM_FLAG_EMPTY         BIT(MEM_EMPTY)
@@ -166,6 +168,8 @@ enum mem_type {
 #define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
 #define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
 #define MEM_FLAG_XDR            BIT(MEM_XDR)
+#define MEM_FLAG_DDR3           BIT(MEM_DDR3)
+#define MEM_FLAG_RDDR3          BIT(MEM_RDDR3)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -757,6 +757,9 @@ static void __devinit mpc85xx_init_csrow
                case DSC_SDTYPE_DDR2:
                        mtype = MEM_RDDR2;
                        break;
+               case DSC_SDTYPE_DDR3:
+                       mtype = MEM_RDDR3;
+                       break;
                default:
                        mtype = MEM_UNKNOWN;
                        break;
@@ -769,6 +772,9 @@ static void __devinit mpc85xx_init_csrow
                case DSC_SDTYPE_DDR2:
                        mtype = MEM_DDR2;
                        break;
+               case DSC_SDTYPE_DDR3:
+                       mtype = MEM_DDR3;
+                       break;
                default:
                        mtype = MEM_UNKNOWN;
                        break;
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -94,7 +94,9 @@ static const char *mem_types[] = {
        [MEM_DDR2] = "Unbuffered-DDR2",
        [MEM_FB_DDR2] = "FullyBuffered-DDR2",
        [MEM_RDDR2] = "Registered-DDR2",
-       [MEM_XDR] = "XDR"
+       [MEM_XDR] = "XDR",
+       [MEM_DDR3] = "Unbuffered-DDR3",
+       [MEM_RDDR3] = "Registered-DDR3"
 };
 
 static const char *dev_types[] = {

