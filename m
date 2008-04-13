Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbYDMPoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbYDMPoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 11:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYDMPor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 11:44:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:21454 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbYDMPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 11:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=LTqWLlR9thovFANfq3ds9ouu2RNYKHJZV23iODgaXXjgEQlxWhtv0Od9DowI2RSkh3pWwXHYGV03ad3B/Xjph+LAOmTgoS1Z/gr19NQy/woaoElC9BJ63MmofrNZUFxTkinD0iAJkKugYrCHwSVfn6W0VTWmGbvd1E0U61qwlZQ=
Message-ID: <48022990.3060104@gmail.com>
Date: Sun, 13 Apr 2008 17:41:04 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: pgtable_32.h - prototype and section mismatch fixes
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds extern to native_pagetable_setup_[start,done]() protypes and
fixes following section mismatch warning:

WARNING: arch/x86/mm/built-in.o(.text+0xf2): Section mismatch in reference from
the function paravirt_pagetable_setup_start()

paravirt_pagetable_setup_[start,done]() is used by __init pagetable_init().
Annotate both functions with __init.

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
 pgtable_32.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 6cbc520..248cfea 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -204,16 +204,16 @@ do {						\
  */
 #define update_mmu_cache(vma, address, pte) do { } while (0)

-void native_pagetable_setup_start(pgd_t *base);
-void native_pagetable_setup_done(pgd_t *base);
+extern void native_pagetable_setup_start(pgd_t *base);
+extern void native_pagetable_setup_done(pgd_t *base);

 #ifndef CONFIG_PARAVIRT
-static inline void paravirt_pagetable_setup_start(pgd_t *base)
+static inline void __init paravirt_pagetable_setup_start(pgd_t *base)
 {
 	native_pagetable_setup_start(base);
 }

-static inline void paravirt_pagetable_setup_done(pgd_t *base)
+static inline void __init paravirt_pagetable_setup_done(pgd_t *base)
 {
 	native_pagetable_setup_done(base);
 }
