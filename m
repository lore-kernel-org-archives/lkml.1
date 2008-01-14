Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYANCYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYANCYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 21:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYANCY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 21:24:26 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:44555 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYANCYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 21:24:25 -0500
Date: Sun, 13 Jan 2008 19:24:24 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Fix kprobes on ia64
Message-ID: <20080114022423.GH18741@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If CONFIG_KPROBES is set, we get the error during build:

kernel/kprobes.c:1057: error: __ksymtab_jprobe_return causes a section
type conflict

This is because ia64 defines a static inline jprobe_return which kprobes
attempts to EXPORT_SYMBOL.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e3a5d81..ecc25b3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1053,11 +1053,11 @@ EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
+
 #ifdef CONFIG_KPROBES
+#ifndef __ia64__ /* It's static inline */
 EXPORT_SYMBOL_GPL(jprobe_return);
 #endif
-
-#ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(register_kretprobe);
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
 #endif

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
