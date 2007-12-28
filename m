Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbXL1P6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbXL1P6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 10:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXL1P6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 10:58:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:44853 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbXL1P6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 10:58:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=fp/d5cnDm2mZNNHJ3ut5Lr2ajVFngfZUq+EMCsy8SN8UDf1qEEaOFgGhhW+XVg14gqipoaowGjDP3Z1vxqEC8qApdKkZ4XUDtdFw2X2QyHYNGRDZ+6sdx752gyQRKh6pAkPzGLcDW1uhMCFVc5paRZmX3p7mDRjK5zK3Ug8Yd0Q=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: export 'leave_mm' symbol
Date: Fri, 28 Dec 2007 16:58:05 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712281658.05958.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a linking error if CONFIG_ACPI_PROCESSOR=m
(this error occurs in the 'mm' branch of linux-2.6-x86.git).

We need to export the 'leave_mm' symbol so it can be accessible
for the ACPI processor module.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index 596d002..dc0cde9 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -263,6 +263,7 @@ void leave_mm(int cpu)
 	cpu_clear(cpu, per_cpu(cpu_tlbstate, cpu).active_mm->cpu_vm_mask);
 	load_cr3(swapper_pg_dir);
 }
+EXPORT_SYMBOL(leave_mm);
 
 /*
  *
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 1334afe..2fd74b0 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -76,6 +76,7 @@ void leave_mm(int cpu)
 	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
 	load_cr3(swapper_pg_dir);
 }
+EXPORT_SYMBOL(leave_mm);
 
 /*
  *

-- 
	Miguel Botón
