Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbXLKWV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbXLKWV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbXLKWVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:21:19 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38485 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754838AbXLKWVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:21:18 -0500
Date: Tue, 11 Dec 2007 23:21:19 +0100
From: Adrian Bunk <bunk@kernel.org>
To: jeremy@xensource.com, chrisw@sous-sol.org
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] xen: fiddle_vdso() must be __init
Message-ID: <20071211222119.GG14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x2589): Section mismatch: reference to .init.data:vsyscall_int80_start (between 'fiddle_vdso' and 'xen_setup_features')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
bd7d683674d639a57c73b316972a28df43690a17 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index f84e772..5e24f67 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -59,7 +59,7 @@ static void xen_idle(void)
 /*
  * Set the bit indicating "nosegneg" library variants should be used.
  */
-static void fiddle_vdso(void)
+static void __init fiddle_vdso(void)
 {
 	extern u32 VDSO_NOTE_MASK; /* See ../kernel/vsyscall-note.S.  */
 	extern char vsyscall_int80_start;

