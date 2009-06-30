Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbZF3W4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbZF3W4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbZF3Wzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:55:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:39337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759246AbZF3Wzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:55:49 -0400
Date: Tue, 30 Jun 2009 22:55:22 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A4A0A8702000078000082E8@vpn.id2.novell.com>
References: <4A4A0A8702000078000082E8@vpn.id2.novell.com>
Subject: [tip:x86/urgent] x86: Fix fixmap ordering
Message-ID: <tip-789d03f584484af85dbdc64935270c8e45f36ef7@git.kernel.org>
Git-Commit-ID: 789d03f584484af85dbdc64935270c8e45f36ef7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 22:55:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  789d03f584484af85dbdc64935270c8e45f36ef7
Gitweb:     http://git.kernel.org/tip/789d03f584484af85dbdc64935270c8e45f36ef7
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 30 Jun 2009 11:52:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 00:12:22 +0200

x86: Fix fixmap ordering

The merge of the 32- and 64-bit fixmap headers made a latent
bug on x86-64 a real one: with the right config settings
it is possible for FIX_OHCI1394_BASE to overlap the FIX_BTMAP_*
range.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <stable@kernel.org> # for 2.6.30.x
LKML-Reference: <4A4A0A8702000078000082E8@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/fixmap.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 2d81af3..3eb0f79 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -114,9 +114,6 @@ enum fixed_addresses {
 	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE1,
 	__end_of_permanent_fixed_addresses,
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
@@ -129,6 +126,9 @@ enum fixed_addresses {
 	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif
