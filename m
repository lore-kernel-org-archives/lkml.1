Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbYKMTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbYKMTkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYKMTeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:18 -0500
Received: from gw.goop.org ([64.81.55.164]:34407 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbYKMTeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 13 of 38] x86: unstatic mp_find_ioapic so it can be used
	elsewhere
X-Mercurial-Node: 8eb04c7f954b3f5bd7c0accf7e40dc5088f595ae
Message-Id: <8eb04c7f954b3f5bd7c0.1226603411@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/mpspec.h |    1 +
 arch/x86/kernel/acpi/boot.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -63,6 +63,7 @@
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
+extern int mp_find_ioapic(int gsi);
 #else
 static inline int
 mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -865,7 +865,7 @@
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
-static int mp_find_ioapic(int gsi)
+int mp_find_ioapic(int gsi)
 {
 	int i = 0;
 


