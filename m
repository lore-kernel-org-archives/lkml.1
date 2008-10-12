Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbYJLJqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbYJLJqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYJLJqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:46:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:1125 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYJLJqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m8GMDa8FFx9Bhuj86GpzI/yVJ+UXMLrA7gIMXa9CQZiPCXpfAR0/3lxtA3gaBMzeRC
         AIcPVAngESP4/BypRe95BWpVg5WxQeoSvX59RI/3DzDwcmlO4YDdPR09yyFvoNZ2g7uB
         z0LaGXbmQV2F5l9HSoVY///SUSS1CP8RCs/go=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 7/7] x86: fix section mismatch warning - apic_x2apic_phys
Date: Sun, 12 Oct 2008 11:46:23 +0200
Message-Id: <1223804783-11078-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
References: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.data+0xc008): Section mismatch in reference from the variable apic_x2apic_phys to the function .init.text:x2apic_acpi_madt_oem_check()
The variable apic_x2apic_phys references
the function __init x2apic_acpi_madt_oem_check()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/genx2apic_phys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 8f1343d..d042211 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -19,7 +19,7 @@ static int set_x2apic_phys_mode(char *arg)
 }
 early_param("x2apic_phys", set_x2apic_phys_mode);
 
-static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (cpu_has_x2apic && x2apic_phys)
 		return 1;
-- 
1.5.6.4

