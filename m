Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYJLJpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYJLJpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYJLJox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:44:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:65032 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbYJLJov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mPPN3zTWkxXralSxaq7vNiYNjpMKNCTLvnM4VNVb7YAxcmOgcmVzQWtztkai68zhrq
         Wtvh2YeZDa//r9xHWALM1LNF2jFj2zg4BQ2Bhoa2HKP1LrljywCwPS8tO78lGLMk3WwN
         bcdxDK6nbaVGLzo8AicKtilqSNvAkV4UmxDb8=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/7] x86: fix section mismatch warning - apic_flat
Date: Sun, 12 Oct 2008 11:44:08 +0200
Message-Id: <1223804652-11033-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
References: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.data+0xbe08): Section mismatch in reference from the variable apic_flat to the function .init.text:flat_acpi_madt_oem_check()
The variable apic_flat references
the function __init flat_acpi_madt_oem_check()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/genapic_flat_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 9eca5ba..56d552c 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -25,7 +25,7 @@
 #include <acpi/acpi_bus.h>
 #endif
 
-static int __init flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 1;
 }
-- 
1.5.6.4

