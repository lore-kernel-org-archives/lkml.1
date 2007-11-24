Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbXKXW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbXKXW40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 17:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbXKXW4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 17:56:03 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:39375 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbXKXW4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 17:56:00 -0500
Date: Sat, 24 Nov 2007 14:57:19 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: not set boot cpu in cpu_present_map again
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200711241457.20193.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: not set boot cpu in cpu_present_map again

in init/main.c boot_cpu_init() already does that before setup_arch

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 30d94d1..9905c45 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -409,12 +409,6 @@ void __init setup_arch(char **cmdline_p)
 	early_quirks();
 #endif
 
-	/*
-	 * set this early, so we dont allocate cpu0
-	 * if MADT list doesnt list BSP first
-	 * mpparse.c/MP_processor_info() allocates logical cpu numbers.
-	 */
-	cpu_set(0, cpu_present_map);
 #ifdef CONFIG_ACPI
 	/*
 	 * Read APIC and some other early information from ACPI tables.
