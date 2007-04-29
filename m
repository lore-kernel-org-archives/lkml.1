Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXD2JM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXD2JM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXD2JM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:12:58 -0400
Received: from gw.goop.org ([64.81.55.164]:57087 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXD2JM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 05:12:57 -0400
Message-ID: <463461A3.9070300@goop.org>
Date: Sun, 29 Apr 2007 02:13:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] paravirt: fix startup_ipi_hook config dependency
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

startup_ipi_hook depends on CONFIG_X86_LOCAL_APIC, so move it to the
right part of the paravirt_ops initialization.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/paravirt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -292,6 +292,7 @@ struct paravirt_ops paravirt_ops = {
 	.apic_read = native_apic_read,
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
+	.startup_ipi_hook = paravirt_nop,
 #endif
 	.set_lazy_mode = paravirt_nop,
 
@@ -342,8 +343,6 @@ struct paravirt_ops paravirt_ops = {
 	.dup_mmap = paravirt_nop,
 	.exit_mmap = paravirt_nop,
 	.activate_mm = paravirt_nop,
-
-	.startup_ipi_hook = paravirt_nop,
 };
 
 EXPORT_SYMBOL(paravirt_ops);


