Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYJHTmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYJHTmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYJHTkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:3991 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbYJHTks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Xr5oNbAsTxwMqZk4q58Jgn05F3VFIZXgcTzS0E7dFHZ6xe55MscuHJnUaR4DoeVJb+
         04XuQn4O7W0CP7Wp6y74q5r7wPvImQhVRrVddXBButrjBJQN1D6pakUEoG53jic8lfQJ
         3VYC+foT9d7NkdRz8yy+4KaY8CQkExr0INajo=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 05/10] ixj: Move duplicate code into well named zero_caller_id function.
Date: Wed,  8 Oct 2008 14:41:40 -0600
Message-Id: <8b2fbd3480fa4d2e08da0d1ea5a6f9860e6d8bea.1223497216.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <659ee5c8af676929264fafd812d539c372f6ee9d.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
 <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
 <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
 <659ee5c8af676929264fafd812d539c372f6ee9d.1223497216.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |   52 +++++++++++-----------------------------------
 1 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 1f91a59..80a31e4 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -7737,16 +7737,20 @@ static void set_25hz_30v_levemetering_ringing(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x8E;
 }
 
-static void DAA_Coeff_US(IXJ *j)
+static void zero_caller_id(IXJ *j)
 {
-	int i;
-
-	j->daa_country = DAA_US;
 	/*----------------------------------------------- */
 	/* CAO */
+	int i;
 	for (i = 0; i < ALISDAA_CALLERID_SIZE; i++) {
 		j->m_DAAShadowRegs.CAO_REGS.CAO.CallerID[i] = 0;
 	}
+}
+
+static void DAA_Coeff_US(IXJ *j)
+{
+	j->daa_country = DAA_US;
+	zero_caller_id(j);
 
 /* Bytes for IM-filter part 1 (04): 0E,32,E2,2F,C2,5A,C0,00 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[7] = 0x03;
@@ -7902,14 +7906,8 @@ static void DAA_Coeff_US(IXJ *j)
 
 static void DAA_Coeff_UK(IXJ *j)
 {
-	int i;
-
 	j->daa_country = DAA_UK;
-	/*----------------------------------------------- */
-	/* CAO */
-	for (i = 0; i < ALISDAA_CALLERID_SIZE; i++) {
-		j->m_DAAShadowRegs.CAO_REGS.CAO.CallerID[i] = 0;
-	}
+	zero_caller_id(j);
 
 /*  Bytes for IM-filter part 1 (04): 00,C2,BB,A8,CB,81,A0,00 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[7] = 0x00;
@@ -8061,14 +8059,8 @@ static void DAA_Coeff_UK(IXJ *j)
 
 static void DAA_Coeff_France(IXJ *j)
 {
-	int i;
-
 	j->daa_country = DAA_FRANCE;
-	/*----------------------------------------------- */
-	/* CAO */
-	for (i = 0; i < ALISDAA_CALLERID_SIZE; i++) {
-		j->m_DAAShadowRegs.CAO_REGS.CAO.CallerID[i] = 0;
-	}
+	zero_caller_id(j);
 
 /* Bytes for IM-filter part 1 (04): 02,A2,43,2C,22,AF,A0,00 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[7] = 0x02;
@@ -8220,14 +8212,8 @@ static void DAA_Coeff_France(IXJ *j)
 
 static void DAA_Coeff_Germany(IXJ *j)
 {
-	int i;
-
 	j->daa_country = DAA_GERMANY;
-	/*----------------------------------------------- */
-	/* CAO */
-	for (i = 0; i < ALISDAA_CALLERID_SIZE; i++) {
-		j->m_DAAShadowRegs.CAO_REGS.CAO.CallerID[i] = 0;
-	}
+	zero_caller_id(j);
 
 /* Bytes for IM-filter part 1 (04): 00,CE,BB,B8,D2,81,B0,00 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[7] = 0x00;
@@ -8400,14 +8386,8 @@ static void DAA_Coeff_Germany(IXJ *j)
 
 static void DAA_Coeff_Australia(IXJ *j)
 {
-	int i;
-
 	j->daa_country = DAA_AUSTRALIA;
-	/*----------------------------------------------- */
-	/* CAO */
-	for (i = 0; i < ALISDAA_CALLERID_SIZE; i++) {
-		j->m_DAAShadowRegs.CAO_REGS.CAO.CallerID[i] = 0;
-	}
+	zero_caller_id(j);
 
 /* Bytes for IM-filter part 1 (04): 00,A3,AA,28,B3,82,D0,00 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[7] = 0x00;
@@ -8559,14 +8539,8 @@ static void DAA_Coeff_Australia(IXJ *j)
 
 static void DAA_Coeff_Japan(IXJ *j)
 {
-	int i;
-
 	j->daa_country = DAA_JAPAN;
-	/*----------------------------------------------- */
-	/* CAO */
-	for (i = 0; i < ALISDAA_CALLERID_SIZE; i++) {
-		j->m_DAAShadowRegs.CAO_REGS.CAO.CallerID[i] = 0;
-	}
+	zero_caller_id(j);
 
 /* Bytes for IM-filter part 1 (04): 06,BD,E2,2D,BA,F9,A0,00 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[7] = 0x06;
-- 
1.5.6.4

