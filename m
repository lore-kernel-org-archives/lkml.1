Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbYJLJqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbYJLJqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbYJLJpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:45:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:65032 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbYJLJph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=InOhmOqXpTd7IalhE/ULFeMLMtRltK/f42/9CCK70UbOvSSRY8KUEqGS0gK8FUmHxB
         7MKW10P+6ekbAYMoPe+bmO83sHPc6dvyZiLL5/JzN/RI5FXRc1N5dkI9FstXaMnDABa4
         ScfDBhGp76uRoGxSAZLawKpxDvFhNmp06N5kw=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/7] x86: fix section mismatch warning - apic_x2apic_cluster
Date: Sun, 12 Oct 2008 11:44:11 +0200
Message-Id: <1223804652-11033-5-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
References: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.data+0xbf88): Section mismatch in reference from the variable apic_x2apic_cluster to the function .init.text:x2apic_acpi_madt_oem_check()
The variable apic_x2apic_cluster references
the function __init x2apic_acpi_madt_oem_check()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/genx2apic_cluster.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index e4bf2cc..f6a2c8e 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -12,7 +12,7 @@
 
 DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 
-static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (cpu_has_x2apic)
 		return 1;
-- 
1.5.6.4

