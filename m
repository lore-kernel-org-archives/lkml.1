Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYJLJph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYJLJph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbYJLJpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:45:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:21673 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYJLJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bht+J2Fch53UQOHAwwamVqhwaxsVnLYzgImxBWvHJqNc6aPmhauK1CtM44FRb5x3lP
         k8vyNdCb9VkUrCZ0C8tgPeAL36RQ8mdYOwgdFeqjpiYUf4SMwwec7PaZ/zQ8X2iCdCIi
         sZp3J5x5MngWWS9zfbNMwa5BdY7YydnqV6ZLk=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/7] x86: fix section mismatch warning - apic_physflat
Date: Sun, 12 Oct 2008 11:44:09 +0200
Message-Id: <1223804652-11033-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
References: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.data+0xbe88): Section mismatch in reference from the variable apic_physflat to the function .init.text:physflat_acpi_madt_oem_check()
The variable apic_physflat references
the function __init physflat_acpi_madt_oem_check()
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
index 56d552c..59a732f 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -170,7 +170,7 @@ struct genapic apic_flat =  {
  * We cannot use logical delivery in this case because the mask
  * overflows, so use physical mode.
  */
-static int __init physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 #ifdef CONFIG_ACPI
 	/*
-- 
1.5.6.4

