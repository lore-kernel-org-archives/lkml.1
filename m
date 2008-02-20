Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYBTUWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYBTUWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933139AbYBTUVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:21:55 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:12223 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbYBTUVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:21:54 -0500
Date: Wed, 20 Feb 2008 15:21:52 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: lguest@ozlabs.org, rusty@rustcorp.com.au, fedora-kernel-list@redhat.com
Subject: [PATCH] lguest: fix undefined asm-offsets symbols
Message-ID: <20080220202152.GA9990@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lguest uses asm-offsets to generate ... offsets, obviously, for use
in the lguest switcher code. When the hypervisor code is built as a
module though, the asm offsets it needs won't be generated since
CONFIG_LGUEST will be undefined.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>

---
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index a33d530..44bafdd 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -134,7 +134,7 @@ void foo(void)
 	OFFSET(LGUEST_DATA_pgdir, lguest_data, pgdir);
 #endif
 
-#ifdef CONFIG_LGUEST
+#if defined(CONFIG_LGUEST) || defined(CONFIG_LGUEST_MODULE)
 	BLANK();
 	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
 	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
