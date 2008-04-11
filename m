Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbYDKLce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbYDKLce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760352AbYDKLcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:32:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:29681 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301AbYDKLcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=CGk12d0TSkGeyF1K3CXta2slrpU/ehWbBIMvYZ9pwYKyV4ri46aKLKB8OaNH3gqxzhv0jnkacse+HHOxtCV89qGoMyGKmN2x49F3b1otgCUOvmxFIp7lcLT9qcUqUDUn6iGFSB2dhnGcuEjMgO2YukkKwb9xehW4BcUcYIYxUdk=
Message-ID: <47FF4B65.9060101@gmail.com>
Date: Fri, 11 Apr 2008 13:28:37 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, tglx@linutronix.de
Subject: [PATCH 1/3] x86: Section mismatch fixes
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes mismatch warnings in smp_checks() (in arch/x86/kernel/smpboot.c):

WARNING: arch/x86/kernel/built-in.o(.text+0x11922): Section mismatch in reference from the function smp_checks()
to the variable .cpuinit.data:smp_b_stepping
The function smp_checks() references
the variable __cpuinitdata smp_b_stepping.
This is often because smp_checks lacks a __cpuinitdata
annotation or the annotation of smp_b_stepping is wrong. 

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
 smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4882a35..de40681 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -437,7 +437,7 @@ valid_k7:
 #endif
 }
 
-void smp_checks(void)
+void __cpuinit smp_checks(void)
 {
 	if (smp_b_stepping)
 		printk(KERN_WARNING "WARNING: SMP operation may be unreliable"
