Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760AbZEJHbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbZEJHbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 03:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZEJHb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 03:31:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:54218 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZEJHb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 03:31:28 -0400
Date: Sun, 10 May 2009 07:30:34 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rakib.mullick@gmail.com, sam@ravnborg.org, marcin.slusarz@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rakib.mullick@gmail.com, sam@ravnborg.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, mingo@elte.hu
In-Reply-To: <b9df5fa10905090235s4bfd26a8o979f93809c9727ad@mail.gmail.com>
References: <b9df5fa10905090235s4bfd26a8o979f93809c9727ad@mail.gmail.com>
Subject: [tip:x86/urgent] x86: Fix false positive section mismatch warnings in the apic code
Message-ID: <tip-b74d446f1f337e3fe906169a3266cb65ffa4179e@git.kernel.org>
Git-Commit-ID: b74d446f1f337e3fe906169a3266cb65ffa4179e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 10 May 2009 07:30:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b74d446f1f337e3fe906169a3266cb65ffa4179e
Gitweb:     http://git.kernel.org/tip/b74d446f1f337e3fe906169a3266cb65ffa4179e
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Sat, 9 May 2009 15:35:10 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 10 May 2009 09:26:54 +0200

x86: Fix false positive section mismatch warnings in the apic code

[ Impact: reduce kernel image size a bit, annotate away warnings ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
[ modified and tested it ]
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
LKML-Reference: <b9df5fa10905090235s4bfd26a8o979f93809c9727ad@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/es7000_32.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 1c11b81..3029477 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -285,7 +285,7 @@ static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
 	return 0;
 }
 
-static void unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+static void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
 	if (!oem_addr)
 		return;
@@ -306,7 +306,7 @@ static int es7000_check_dsdt(void)
 static int es7000_acpi_ret;
 
 /* Hook from generic ACPI tables.c */
-static int es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	unsigned long oem_addr = 0;
 	int check_dsdt;
@@ -717,7 +717,7 @@ struct apic apic_es7000_cluster = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
 
-struct apic apic_es7000 = {
+struct apic __refdata apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
