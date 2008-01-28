Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYA1CVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYA1CVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 21:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYA1CVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 21:21:25 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55090 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYA1CVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 21:21:24 -0500
Date: Sun, 27 Jan 2008 18:27:17 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: not set boot cpu in cpu_present_map again
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801271827.17992.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: not set boot cpu in cpu_present_map again

in init/main.c boot_cpu_init() already does that before setup_arch

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -446,12 +446,6 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
-	/*
-	 * set this early, so we dont allocate cpu0
-	 * if MADT list doesnt list BSP first
-	 * mpparse.c/MP_processor_info() allocates logical cpu numbers.
-	 */
-	cpu_set(0, cpu_present_map);
 #ifdef CONFIG_ACPI
 	/*
 	 * Read APIC and some other early information from ACPI tables.
