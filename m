Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYHPTXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYHPTXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYHPTVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:21:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:15952 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYHPTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ex4noHyom8nM/SlYKbUzIaCgNJ+nTdpCTrhgo6Y4ZuV76PozfJL8aPY4o1Sbx51K9B
         6yZvFgPvR5JhQYzimier68H4Au1YEbGBwdcirhtLne00uH1Dt4+sOtw/CBNtvgK2zqcB
         TKrFhvYrk2G3p9gcSA5sndiiJ96hL/C2wIpTg=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 6/6] x86: apic - unify xapic_icr_read
Date: Sat, 16 Aug 2008 23:21:55 +0400
Message-Id: <e030374ddba6313261c60ac18e380e7ec0a02f40.1218914042.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <2d50651150912bee93e30485c0307eeb74ab1143.1218914042.git.gorcunov@gmail.com>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
 <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
 <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
 <7bef3d3fb91a430ad3a461f59c8a5140fa1e9d87.1218914042.git.gorcunov@gmail.com>
 <e752642559f71f83b08df6bc44864a5946147279.1218914042.git.gorcunov@gmail.com>
 <2d50651150912bee93e30485c0307eeb74ab1143.1218914042.git.gorcunov@gmail.com>
In-Reply-To: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
References: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 18c0b8c..5e07381 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -174,7 +174,7 @@ u64 xapic_icr_read(void)
 	icr2 = apic_read(APIC_ICR2);
 	icr1 = apic_read(APIC_ICR);
 
-	return (icr1 | ((u64)icr2 << 32));
+	return icr1 | ((u64)icr2 << 32);
 }
 
 static struct apic_ops xapic_ops = {
-- 
1.6.0.rc1.34.g0fe8c

