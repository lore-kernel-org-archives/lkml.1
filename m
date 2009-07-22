Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZGVQ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZGVQ7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZGVQ7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:59:38 -0400
Received: from claw.goop.org ([74.207.240.146]:37298 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZGVQ7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:59:37 -0400
Message-ID: <4A674577.4020206@goop.org>
Date: Wed, 22 Jul 2009 09:59:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Bastian Blank <bastian@waldi.eu.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] x86/amd: don't probe for extended APIC ID if APICs are disabled
References: <20090604104016.GT5736@alberich.amd.com> <20090721103642.GA10071@wavehammer.waldi.eu.org> <4A65F34D.40506@goop.org> <20090722095436.GA9000@wavehammer.waldi.eu.org> <alpine.LFD.2.00.0907221628110.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907221628110.2813@localhost.localdomain>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we've logically disabled apics, don't probe the PCI space for the
AMD extended APIC ID.

[ Impact: prevent boot crash under Xen. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reported-by: Bastian Blank <bastian@waldi.eu.org>

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 28e5f59..e2485b0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -356,7 +356,7 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
 	/* check CPU config space for extended APIC ID */
-	if (c->x86 >= 0xf) {
+	if (cpu_has_apic && c->x86 >= 0xf) {
 		unsigned int val;
 		val = read_pci_config(0, 24, 0, 0x68);
 		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))


