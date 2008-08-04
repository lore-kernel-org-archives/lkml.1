Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYHDNiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYHDNiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYHDNiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:38:12 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:19209 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYHDNiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:38:12 -0400
Message-Id: <4897228E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 04 Aug 2008 14:38:54 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix spin_is_contended()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The masked difference is what needs to be compared against 1, rather
than the difference of masked values (which can be negative).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 include/asm-x86/spinlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.27-rc1/include/asm-x86/spinlock.h	2008-07-31 17:08:34.000000000 +0200
+++ 2.6.27-rc1-x86-spin-is-contended/include/asm-x86/spinlock.h	2008-08-04 11:09:33.000000000 +0200
@@ -65,7 +65,7 @@ static inline int __ticket_spin_is_conte
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
-	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
+	return (((tmp >> 8) - tmp) & 0xff) > 1;
 }
 
 static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
@@ -127,7 +127,7 @@ static inline int __ticket_spin_is_conte
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
-	return (((tmp >> 16) & 0xffff) - (tmp & 0xffff)) > 1;
+	return (((tmp >> 16) - tmp) & 0xffff) > 1;
 }
 
 static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)



