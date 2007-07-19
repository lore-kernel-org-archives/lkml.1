Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbXGSKZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbXGSKZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbXGSJ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:12 -0400
Received: from ns.suse.de ([195.135.220.2]:35448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760885AbXGSJzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:47 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: sam@ravnborg.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [52/58] i386: fix section mismatch warnings in mtrr
Message-Id: <20070719095539.3950814E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sam Ravnborg <sam@ravnborg.org>

Following section mismatch warnings were reported by Andrey Borzenkov:

WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:amd_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x967a) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:cyrix_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x967f) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:centaur_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x9684) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa735) and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa749) and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa770) and 'generic_get_mtrr'

It was tracked down to a few functions missing __init tag.
Compile tested only.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/mtrr/generic.c |    2 +-
 arch/i386/kernel/cpu/mtrr/main.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux/arch/i386/kernel/cpu/mtrr/generic.c
@@ -79,7 +79,7 @@ static void print_fixed(unsigned base, u
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
-void get_mtrr_state(void)
+void __init get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
Index: linux/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux/arch/i386/kernel/cpu/mtrr/main.c
@@ -643,7 +643,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-__init void mtrr_bp_init(void)
+void __init mtrr_bp_init(void)
 {
 	init_ifs();
 
