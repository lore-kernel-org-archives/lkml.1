Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYINICr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYINICr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 04:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYINIBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 04:01:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3067 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYINIBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 04:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=qQ3oCrzqEm5e+i+FCBVv4jOnDkO6mMA9DS7dIfqFeFk53Rq1j8f+fSKhlzJXAR6cWd
         +o8/4WnMpJCw/ySfXlpTDdvDfMNhrE6ixOqMK5Zjh8vivXBeSaZSSWC1ki30R1Mfy8dF
         HdbCu4yLYrSuRVUqEdbvRM3mZByHOfQF/kkOo=
References: <20080914075536.619891882@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sun, 14 Sep 2008 11:55:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org, linux-kernel@vger.kernel.org
Cc: yhlu.kernel@gmail.com, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/2] x86: apic - skip writting ESR register if we dont have on
Content-Disposition: inline; filename=x86-setup_local_APIC-esr-fix
Message-ID: <48ccc4e8.0c07560a.0cab.34d4@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 82489DX we don't have ESR register so we should not
write it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-14 11:46:13.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-14 11:48:37.000000000 +0400
@@ -1131,7 +1131,7 @@ void __cpuinit setup_local_APIC(void)
 
 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
-	if (esr_disable) {
+	if (lapic_is_integrated() && esr_disable) {
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);

-- 
