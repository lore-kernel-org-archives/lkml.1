Return-Path: <linux-kernel-owner+w=401wt.eu-S1763032AbYENPCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763032AbYENPCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762472AbYENPCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:02:24 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51213 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758749AbYENPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:02:23 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: make mp_ioapic_routing definition local
Date: Wed, 14 May 2008 19:03:04 +0400
Message-ID: <20080514150304.24443.8070.stgit@thinkpad>
In-Reply-To: <20080514150251.24443.5516.stgit@thinkpad>
References: <20080514150251.24443.5516.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/acpi/boot.c |    7 ++++++-
 include/asm-x86/io_apic.h   |    7 -------
 2 files changed, 6 insertions(+), 8 deletions(-)


diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 04075dc..a834a8e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -850,7 +850,12 @@ static int __init acpi_parse_madt_lapic_entries(void)
 extern int es7000_plat;
 #endif
 
-static struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
+static struct {
+	int apic_id;
+	int gsi_base;
+	int gsi_end;
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+} mp_ioapic_routing[MAX_IO_APICS];
 
 static int mp_find_ioapic(int gsi)
 {
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index d593e14..2ef96f0 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -112,13 +112,6 @@ extern int nr_ioapic_registers[MAX_IO_APICS];
 
 #define MP_MAX_IOAPIC_PIN 127
 
-struct mp_ioapic_routing {
-	int apic_id;
-	int gsi_base;
-	int gsi_end;
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
-};
-
 /* I/O APIC entries */
 extern struct mpc_config_ioapic mp_ioapics[MAX_IO_APICS];
 

