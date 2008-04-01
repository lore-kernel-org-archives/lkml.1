Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYDAPou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYDAPou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbYDAPom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:44:42 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:21992 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYDAPol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:44:41 -0400
Date: Tue, 1 Apr 2008 17:41:26 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] x86: switch x86_64 to generic find_first_bit
Message-ID: <20080401154126.GA26062@mailshack.com>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401094618.GA24862@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 01 Apr 2008 17:44:21 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.78; VDF: 7.0.3.103; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: switch x86_64 to generic find_first_bit

Switch x86_64 to generic find_first_bit. The x86_64-specific
implementation is not removed.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---
 arch/x86/Kconfig            |    2 +-
 arch/x86/lib/bitops_64.c    |    2 ++
 include/asm-x86/bitops_64.h |    2 ++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fa7d16d..e37e286 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -81,7 +81,7 @@ config GENERIC_BUG
 	depends on BUG
 
 config GENERIC_FIND_FIRST_BIT
-	def_bool X86_32
+	def_bool y
 
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
diff --git a/arch/x86/lib/bitops_64.c b/arch/x86/lib/bitops_64.c
index 0eeb704..568467d 100644
--- a/arch/x86/lib/bitops_64.c
+++ b/arch/x86/lib/bitops_64.c
@@ -1,3 +1,4 @@
+#ifndef CONFIG_GENERIC_FIND_FIRST_BIT
 #include <linux/bitops.h>
 
 #undef find_first_zero_bit
@@ -105,3 +106,4 @@ long find_first_bit(const unsigned long * addr, unsigned long size)
 
 EXPORT_SYMBOL(find_first_bit);
 EXPORT_SYMBOL(find_first_zero_bit);
+#endif
diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
index d133520..4081d7e 100644
--- a/include/asm-x86/bitops_64.h
+++ b/include/asm-x86/bitops_64.h
@@ -5,6 +5,7 @@
  * Copyright 1992, Linus Torvalds.
  */
 
+#ifndef CONFIG_GENERIC_FIND_FIRST_BIT
 extern long find_first_zero_bit(const unsigned long *addr, unsigned long size);
 extern long find_first_bit(const unsigned long *addr, unsigned long size);
 
@@ -24,6 +25,7 @@ static inline long __scanbit(unsigned long val, unsigned long max)
 	((__builtin_constant_p((size)) && (size) <= BITS_PER_LONG	\
 	  ? (__scanbit(~*(unsigned long *)(addr), (size)))		\
 	  : find_first_zero_bit((addr), (size))))
+#endif
 
 static inline void set_bit_string(unsigned long *bitmap, unsigned long i,
 				  int len)
-- 
1.5.2.5


