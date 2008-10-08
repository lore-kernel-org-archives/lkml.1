Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbYJHTmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbYJHTmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYJHTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:3991 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbYJHTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZeyidAgoyM9P6FavUMRtHGuICwGQGmsjOvK1s11+pt1lCtMCNoNH0/nJeVwjRwOeQN
         gcPCXSaGqTZ8MN+zdykjJPUuA36n6Jt+B5Tj4afMg3buVMQEKTHw9LIAnB+ZBVzrbknx
         u6ZYroGNIIzUD0vI7BzWzLIhnP49hCMuys108=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 06/10] ixj: Caller ID Refactoring
Date: Wed,  8 Oct 2008 14:41:41 -0600
Message-Id: <4f6d77649769072c98fa1e6bcafd963b6b050190.1223497216.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <8b2fbd3480fa4d2e08da0d1ea5a6f9860e6d8bea.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
 <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
 <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
 <659ee5c8af676929264fafd812d539c372f6ee9d.1223497216.git.aciddeath@gmail.com>
 <8b2fbd3480fa4d2e08da0d1ea5a6f9860e6d8bea.1223497216.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all caller id settings into a single function to reduce code duplication.
All the DAA_Coeff_* methods set the same caller id tone values.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |  138 ++++++++++-------------------------------------
 1 files changed, 29 insertions(+), 109 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 80a31e4..a1bbe81 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -7719,6 +7719,28 @@ static void set_shared_ringerimpendance(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD5;
 }
 
+static void set_caller_id_tones(IXJ *j)
+{
+	/* Caller ID 1st Tone      (0E):CA,0E,CA,09,99,99,99,99 */
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[5] = 0xCA;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[4] = 0x09;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[3] = 0x99;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[2] = 0x99;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[1] = 0x99;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[0] = 0x99;
+	/* Caller ID 2nd Tone      (0F):FD,B5,BA,07,DA,00,00,00 */
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[7] = 0xFD;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[6] = 0xB5;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[5] = 0xBA;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[4] = 0x07;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[3] = 0xDA;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[2] = 0x00;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[1] = 0x00;
+	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[0] = 0x00;
+}
+
 static void set_50hz_20v_levelmetering_ringing(IXJ *j)
 {
 	/* Levelmetering Ringing           (0D):32,45,B5,84     ; 50Hz 20V */
@@ -7829,25 +7851,7 @@ static void DAA_Coeff_US(IXJ *j)
 	/*  */
 	set_shared_ringerimpendance(j);
 	set_25hz_30v_levemetering_ringing(j);
-
-	/* Caller ID 1st Tone           (0E):CA,0E,CA,09,99,99,99,99 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[5] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[4] = 0x09;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[3] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[2] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[1] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[0] = 0x99;
-/* Caller ID 2nd Tone           (0F):FD,B5,BA,07,DA,00,00,00 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[7] = 0xFD;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[6] = 0xB5;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[5] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[4] = 0x07;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[3] = 0xDA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[2] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[1] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[0] = 0x00;
+	set_caller_id_tones(j);
 /*  */
 	/* ;CR Registers */
 	/* Config. Reg. 0 (filters)       (cr0):FE ; CLK gen. by crystal */
@@ -7985,24 +7989,7 @@ static void DAA_Coeff_UK(IXJ *j)
 /* ; idle */
 	set_shared_ringerimpendance(j);
 	set_25hz_30v_levemetering_ringing(j);
-/* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[5] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[4] = 0x09;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[3] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[2] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[1] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[0] = 0x99;
-/* Caller ID 2nd Tone              (0F):FD,B5,BA,07,DA,00,00,00 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[7] = 0xFD;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[6] = 0xB5;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[5] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[4] = 0x07;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[3] = 0xDA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[2] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[1] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[0] = 0x00;
+	set_caller_id_tones(j);
 /* ;CR Registers */
 	/* Config. Reg. 0 (filters)        (cr0):FF */
 	j->m_DAAShadowRegs.SOP_REGS.SOP.cr0.reg = 0xFF;
@@ -8136,26 +8123,10 @@ static void DAA_Coeff_France(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[1] = 0x2C;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[0] = 0x45;
 /* ; idle */
+
 	set_shared_ringerimpendance(j);
 	set_50hz_20v_levelmetering_ringing(j);
-/* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[5] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[4] = 0x09;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[3] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[2] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[1] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[0] = 0x99;
-/* Caller ID 2nd Tone              (0F):FD,B5,BA,07,DA,00,00,00 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[7] = 0xFD;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[6] = 0xB5;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[5] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[4] = 0x07;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[3] = 0xDA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[2] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[1] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[0] = 0x00;
+	set_caller_id_tones(j);
 /* ;CR Registers */
 	/* Config. Reg. 0 (filters)        (cr0):FF */
 	j->m_DAAShadowRegs.SOP_REGS.SOP.cr0.reg = 0xFF;
@@ -8312,24 +8283,7 @@ static void DAA_Coeff_Germany(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x45;
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0x0F;
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x8E;
-/* Caller ID 1st Tone           (0E):CA,0E,CA,09,99,99,99,99 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[5] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[4] = 0x09;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[3] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[2] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[1] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[0] = 0x99;
-/* Caller ID 2nd Tone           (0F):FD,B5,BA,07,DA,00,00,00 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[7] = 0xFD;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[6] = 0xB5;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[5] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[4] = 0x07;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[3] = 0xDA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[2] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[1] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[0] = 0x00;
+	set_caller_id_tones(j);
 /* ;CR Registers */
 	/* Config. Reg. 0 (filters)        (cr0):FF ; all Filters enabled, CLK from ext. source */
 	j->m_DAAShadowRegs.SOP_REGS.SOP.cr0.reg = 0xFF;
@@ -8465,24 +8419,7 @@ static void DAA_Coeff_Australia(IXJ *j)
 /* ;  idle */
 	set_shared_ringerimpendance(j);
 	set_50hz_20v_levelmetering_ringing(j);
-	/* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[5] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[4] = 0x09;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[3] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[2] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[1] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[0] = 0x99;
-/* Caller ID 2nd Tone              (0F):FD,B5,BA,07,DA,00,00,00 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[7] = 0xFD;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[6] = 0xB5;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[5] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[4] = 0x07;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[3] = 0xDA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[2] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[1] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[0] = 0x00;
+	set_caller_id_tones(j);
 /* ;CR Registers */
 	/* Config. Reg. 0 (filters)        (cr0):FF */
 	j->m_DAAShadowRegs.SOP_REGS.SOP.cr0.reg = 0xFF;
@@ -8618,24 +8555,7 @@ static void DAA_Coeff_Japan(IXJ *j)
 /* ;  idle */
 	set_shared_ringerimpendance(j);
 	set_25hz_30v_levemetering_ringing(j);
-/* Caller ID 1st Tone              (0E):CA,0E,CA,09,99,99,99,99 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[5] = 0xCA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[4] = 0x09;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[3] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[2] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[1] = 0x99;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[0] = 0x99;
-/* Caller ID 2nd Tone              (0F):FD,B5,BA,07,DA,00,00,00 */
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[7] = 0xFD;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[6] = 0xB5;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[5] = 0xBA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[4] = 0x07;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[3] = 0xDA;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[2] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[1] = 0x00;
-	j->m_DAAShadowRegs.COP_REGS.COP.CallerID2ndTone[0] = 0x00;
+	set_caller_id_tones(j);
 /* ;CR Registers */
 	/* Config. Reg. 0 (filters)        (cr0):FF */
 	j->m_DAAShadowRegs.SOP_REGS.SOP.cr0.reg = 0xFF;
-- 
1.5.6.4

