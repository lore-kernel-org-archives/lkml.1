Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYCNHz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYCNHz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYCNHzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:55:49 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:23001
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbYCNHzs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:55:48 -0400
Message-Id: <47DA3DC0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Fri, 14 Mar 2008 07:56:32 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: simplify sync_test_bit()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There really is no need for a redundant implementation here, just keep
the alternative name for allowing consumers to use consistent naming.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- a/include/asm-x86/sync_bitops.h
+++ b/include/asm-x86/sync_bitops.h
@@ -130,26 +130,7 @@ static inline int sync_test_and_change_b
 	return oldbit;
 }
 
-static __always_inline int sync_constant_test_bit(int nr, const volatile unsigned long *addr)
-{
-	return ((1UL << (nr & 31)) &
-		(((const volatile unsigned int *)addr)[nr >> 5])) != 0;
-}
-
-static inline int sync_var_test_bit(int nr, const volatile unsigned long * addr)
-{
-	int oldbit;
-
-	__asm__ __volatile__("btl %2,%1\n\tsbbl %0,%0"
-			     :"=r" (oldbit)
-			     :"m" (ADDR),"Ir" (nr));
-	return oldbit;
-}
-
-#define sync_test_bit(nr,addr)			\
-	(__builtin_constant_p(nr) ?		\
-	 sync_constant_test_bit((nr),(addr)) :	\
-	 sync_var_test_bit((nr),(addr)))
+#define sync_test_bit test_bit
 
 #undef ADDR
 



