Return-Path: <linux-kernel-owner+w=401wt.eu-S1163319AbXD1Rzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163319AbXD1Rzq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163313AbXD1RxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163314AbXD1Rwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:54 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [24/35] i386: Add __init to probe_bigsmp
Message-Id: <20070428175249.8A534151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Prarit Bhargava <prarit@redhat.com>
Add __init to probe_bigsmp.  All callers are __init and data being examined
is __initdata.

Resolves MODPOST warning similar to:

WARNING: vmlinux - Section mismatch: reference to .init.data: from .text between 'probe_bigsmp' (at offset 0xc0401e56) and 'init_apic_ldr'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mach-generic/bigsmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/mach-generic/bigsmp.c
===================================================================
--- linux.orig/arch/i386/mach-generic/bigsmp.c
+++ linux/arch/i386/mach-generic/bigsmp.c
@@ -45,7 +45,7 @@ static struct dmi_system_id __initdata b
 };
 
 
-static int probe_bigsmp(void)
+static int __init probe_bigsmp(void)
 { 
 	if (def_to_bigsmp)
         	dmi_bigsmp = 1;
