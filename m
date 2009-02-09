Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZBJUII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZBJUII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbZBJUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:07:28 -0500
Received: from gw.goop.org ([64.81.55.164]:50708 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbZBJUH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:07:26 -0500
Message-Id: <4924e228ae039029a9503ad571d91086e4042c90.1234296039.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:47 -0800
Subject: [PATCH] x86: unstatic mp_find_ioapic so it can be used elsewhere
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/mpspec.h |    1 +
 arch/x86/kernel/acpi/boot.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 8c56201..b59371a 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -77,6 +77,7 @@ extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
+extern int mp_find_ioapic(int gsi);
 #else
 static inline int
 mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c334fe7..068b900 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -872,7 +872,7 @@ static struct {
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
-static int mp_find_ioapic(int gsi)
+int mp_find_ioapic(int gsi)
 {
 	int i = 0;
 
-- 
1.6.0.6


