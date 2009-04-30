Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZD3Kli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZD3Kli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 06:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZD3Kl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 06:41:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:60422 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbZD3Kl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 06:41:28 -0400
Date: Thu, 30 Apr 2009 10:39:41 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tglx@linutronix.de,
       jdb@comx.dk, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       jdb@comx.dk, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain>
References: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain>
Subject: [tip:x86/kbuild] x86: boot/compressed/vmlinux.lds.S: fix build of bzImage with 64 bit compiler
Message-ID: <tip-83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f@git.kernel.org>
Git-Commit-ID: 83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 10:39:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f
Gitweb:     http://git.kernel.org/tip/83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Thu, 30 Apr 2009 12:03:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Apr 2009 12:36:50 +0200

x86: boot/compressed/vmlinux.lds.S: fix build of bzImage with 64 bit compiler

Jesper reported that he saw following build issue:

 > ld:arch/x86/boot/compressed/vmlinux.lds:9: syntax error
 > make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
 > make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
 > make: *** [bzImage] Error 2

CPP defines the symbol "i386" to "1".
Undefine this to fix it.

[ Impact: build fix with certain tool chains ]

Reported-by: Jesper Dangaard Brouer <jdb@comx.dk>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/boot/compressed/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index ffcb191..0d26c92 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -1,5 +1,7 @@
 OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 
+#undef i386
+
 #ifdef CONFIG_X86_64
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(startup_64)
