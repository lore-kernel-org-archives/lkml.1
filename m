Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbZGJMB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbZGJMB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZGJMBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:01:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZGJMBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:01:20 -0400
Date: Fri, 10 Jul 2009 12:00:36 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090708180353.GH5301@lenovo>
References: <20090708180353.GH5301@lenovo>
Subject: [tip:x86/cleanups] x86: Clean up idt_descr and idt_tableby using NR_VECTORS instead of hardcoded number
Message-ID: <tip-9ff80942992cd5abd0779c815f310f65b7b83860@git.kernel.org>
Git-Commit-ID: 9ff80942992cd5abd0779c815f310f65b7b83860
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 12:00:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ff80942992cd5abd0779c815f310f65b7b83860
Gitweb:     http://git.kernel.org/tip/9ff80942992cd5abd0779c815f310f65b7b83860
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 8 Jul 2009 22:03:53 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 13:57:13 +0200

x86: Clean up idt_descr and idt_tableby using NR_VECTORS instead of hardcoded number

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090708180353.GH5301@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/traps.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f1961c0..d6f27c9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -982,7 +982,7 @@ static __init int setup_disablecpuid(char *arg)
 __setup("clearcpuid=", setup_disablecpuid);
 
 #ifdef CONFIG_X86_64
-struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
+struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5204332..7e4b1f5 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -76,7 +76,7 @@ char ignore_fpu_irq;
  * F0 0F bug workaround.. We have a special link segment
  * for this.
  */
-gate_desc idt_table[256]
+gate_desc idt_table[NR_VECTORS]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 #endif
 
