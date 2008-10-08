Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYJHTmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYJHTmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYJHTkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:8491 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbYJHTkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OVLGlfAXpcOUCdfgK05OKAFLFYckU7bAMVoyPSnLnFsUwkUs2Tc4dj7x6cHoHyi+dD
         ZctviCVgKliLIrDpEPdEX+QIFJ1kiQhEfM6S2ZfX29w6bwD0kL//xEaO6ITP4LXLn+W6
         3k7YAs1Ai1HlH655u1xJ8OsmgMgHS9C9ZvEDM=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 04/10] ixj: Consolidate duplicate Ringer array initializers into common functions.
Date: Wed,  8 Oct 2008 14:41:39 -0600
Message-Id: <659ee5c8af676929264fafd812d539c372f6ee9d.1223497216.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
 <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
 <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull the RingerImpendance_1 and RingerImpendance_2 setup into a common function,
the settings are the same for all the country settings except Germany.
Also consolidate the levelmetering settings into 2 shared functions to further
reduce code duplication.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |  168 ++++++++++++++--------------------------------
 1 files changed, 51 insertions(+), 117 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 99d6bed..1f91a59 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -7697,6 +7697,46 @@ static int __init ixj_init(void)
 module_init(ixj_init);
 module_exit(ixj_exit);
 
+static void set_shared_ringerimpendance(IXJ *j)
+{
+	/* Bytes for Ringing part 1 (03):1B,3C,93,3A,22,12,A3,23 */
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[7] = 0x1B;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[6] = 0x3C;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[5] = 0x93;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[4] = 0x3A;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[3] = 0x22;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[2] = 0x12;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[1] = 0xA3;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[0] = 0x23;
+	/* Bytes for Ringing part 2 (06):12,A2,A6,BA,22,7A,0A,D5 */
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[7] = 0x12;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[6] = 0xA2;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[5] = 0xA6;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[4] = 0xBA;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[3] = 0x22;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[2] = 0x7A;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[1] = 0x0A;
+	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD5;
+}
+
+static void set_50hz_20v_levelmetering_ringing(IXJ *j)
+{
+	/* Levelmetering Ringing           (0D):32,45,B5,84     ; 50Hz 20V */
+	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0x32;
+	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x45;
+	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0xB5;
+	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x84;
+}
+
+static void set_25hz_30v_levemetering_ringing(IXJ *j)
+{
+	/* Levelmetering Ringing  (0D):AA,35,0F,8E  ; 25Hz 30V less possible? */
+	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0xAA;
+	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x35;
+	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0x0F;
+	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x8E;
+}
+
 static void DAA_Coeff_US(IXJ *j)
 {
 	int i;
@@ -7783,30 +7823,8 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[0] = 0xA6;
 /* ;  (10K, 0.68uF) */
 	/*  */
-	/* Bytes for Ringing part 1 (03):1B,3B,9B,BA,D4,1C,B3,23 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[7] = 0x1B;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[6] = 0x3C;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[5] = 0x93;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[4] = 0x3A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[2] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[1] = 0xA3;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[0] = 0x23;
-	/* Bytes for Ringing part 2 (06):13,42,A6,BA,D4,73,CA,D5 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[7] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[6] = 0xA2;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[5] = 0xA6;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[4] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[2] = 0x7A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[1] = 0x0A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD5;
-
-	/* Levelmetering Ringing        (0D):B2,45,0F,8E       */
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0xAA;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x35;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0x0F;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x8E;
+	set_shared_ringerimpendance(j);
+	set_25hz_30v_levemetering_ringing(j);
 
 	/* Caller ID 1st Tone           (0E):CA,0E,CA,09,99,99,99,99 */
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
@@ -7967,29 +7985,8 @@ static void DAA_Coeff_UK(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[1] = 0xF5;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[0] = 0x32;
 /* ; idle */
-	/* Bytes for Ringing part 1 (03):1B,3C,93,3A,22,12,A3,23 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[7] = 0x1B;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[6] = 0x3C;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[5] = 0x93;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[4] = 0x3A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[2] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[1] = 0xA3;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[0] = 0x23;
-/* Bytes for Ringing part 2 (06):12,A2,A6,BA,22,7A,0A,D5 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[7] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[6] = 0xA2;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[5] = 0xA6;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[4] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[2] = 0x7A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[1] = 0x0A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD5;
-/* Levelmetering Ringing           (0D):AA,35,0F,8E     ; 25Hz 30V less possible? */
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0xAA;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x35;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0x0F;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x8E;
+	set_shared_ringerimpendance(j);
+	set_25hz_30v_levemetering_ringing(j);
 /* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
@@ -8147,29 +8144,8 @@ static void DAA_Coeff_France(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[1] = 0x2C;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[0] = 0x45;
 /* ; idle */
-	/* Bytes for Ringing part 1 (03):1B,3C,93,3A,22,12,A3,23 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[7] = 0x1B;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[6] = 0x3C;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[5] = 0x93;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[4] = 0x3A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[2] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[1] = 0xA3;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[0] = 0x23;
-/* Bytes for Ringing part 2 (06):12,A2,A6,BA,22,7A,0A,D5 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[7] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[6] = 0xA2;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[5] = 0xA6;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[4] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[2] = 0x7A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[1] = 0x0A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD5;
-/* Levelmetering Ringing           (0D):32,45,B5,84     ; 50Hz 20V */
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x45;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0xB5;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x84;
+	set_shared_ringerimpendance(j);
+	set_50hz_20v_levelmetering_ringing(j);
 /* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
@@ -8507,30 +8483,9 @@ static void DAA_Coeff_Australia(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[1] = 0x24;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[0] = 0x46;
 /* ;  idle */
-	/* Bytes for Ringing part 1 (03):1B,3C,93,3A,22,12,A3,23 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[7] = 0x1B;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[6] = 0x3C;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[5] = 0x93;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[4] = 0x3A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[2] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[1] = 0xA3;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[0] = 0x23;
-/* Bytes for Ringing part 2 (06):12,A2,A6,BA,22,7A,0A,D5 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[7] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[6] = 0xA2;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[5] = 0xA6;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[4] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[2] = 0x7A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[1] = 0x0A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD5;
-/* Levelmetering Ringing           (0D):32,45,B5,84   ; 50Hz 20V */
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0x32;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x45;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0xB5;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x84;
-/* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
+	set_shared_ringerimpendance(j);
+	set_50hz_20v_levelmetering_ringing(j);
+	/* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[5] = 0xCA;
@@ -8687,29 +8642,8 @@ static void DAA_Coeff_Japan(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[1] = 0x4C;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[0] = 0xBA;
 /* ;  idle */
-	/* Bytes for Ringing part 1 (03):1B,3C,93,3A,22,12,A3,23 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[7] = 0x1B;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[6] = 0x3C;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[5] = 0x93;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[4] = 0x3A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[2] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[1] = 0xA3;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[0] = 0x23;
-/* Bytes for Ringing part 2 (06):12,A2,A6,BA,22,7A,0A,D5 */
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[7] = 0x12;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[6] = 0xA2;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[5] = 0xA6;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[4] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[3] = 0x22;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[2] = 0x7A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[1] = 0x0A;
-	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD5;
-/* Levelmetering Ringing       (0D):AA,35,0F,8E     ; 25Hz 30V less possible? */
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0xAA;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x35;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0x0F;
-	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x8E;
+	set_shared_ringerimpendance(j);
+	set_25hz_30v_levemetering_ringing(j);
 /* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
-- 
1.5.6.4

