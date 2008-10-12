Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYJLJpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYJLJpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYJLJpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:45:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:65032 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbYJLJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jL3JNLYS9CFjBNCDmpQyrxskLG9yAQbGI+8FJNqBdHjjCq1StisIdL+bg7ujny5SBA
         WX8M53rX5nfIr8y/fi1mg1XrW8iNxxGiwPy+wRdZ3SMcm4qRHbJpOlsh/IOZq32D+pTB
         4DeJouGdYjgbb5SdAVn3K/uZaWs2KewhpobIc=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/7] x86: fix section mismatch warning - apic_x2apic_uv_x
Date: Sun, 12 Oct 2008 11:44:10 +0200
Message-Id: <1223804652-11033-4-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
References: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.data+0xbf08): Section mismatch in reference from the variable apic_x2apic_uv_x to the function .init.text:uv_acpi_madt_oem_check()
The variable apic_x2apic_uv_x references
the function __init uv_acpi_madt_oem_check()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/genx2apic_uv_x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index ae2ffc8..b1369f4 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -30,7 +30,7 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 
-static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
 		if (!strcmp(oem_table_id, "UVL"))
-- 
1.5.6.4

