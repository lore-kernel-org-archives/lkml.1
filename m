Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbYLPIDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYLPIDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYLPIDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:03:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56247 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYLPIDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:03:03 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Petr Tesarik <ptesarik@suse.cz>, Robin Holt <holt@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm][PATCH] ia64: typo fix of implement interrupt-enabling rwlocks
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081216170020.DBB4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 17:02:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Applied after: ia64-implement-interrupt-enabling-rwlocks.patch
==
Recently, __raw_read_lock_flags and __raw_write_lock_flags for ia64 was implemented.

But its patch has typo. then following warnings happend.

  CC      lib/spinlock_debug.o
lib/spinlock_debug.c: In function '_raw_read_lock':
lib/spinlock_debug.c:199: warning: passing argument 1 of '__raw_read_lock_flags' from incompatible pointer type
lib/spinlock_debug.c: In function '_raw_write_lock':
lib/spinlock_debug.c:274: warning: passing argument 1 of '__raw_write_lock_flags' from incompatible pointer type


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Petr Tesarik <ptesarik@suse.cz>
CC: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Luck, Tony" <tony.luck@intel.com>
---
 arch/ia64/include/asm/spinlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/arch/ia64/include/asm/spinlock.h
===================================================================
--- a/arch/ia64/include/asm/spinlock.h
+++ b/arch/ia64/include/asm/spinlock.h
@@ -123,7 +123,7 @@ do {											\
 #ifdef ASM_SUPPORTED
 
 static __always_inline void
-__raw_read_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+__raw_read_lock_flags(raw_rwlock_t *lock, unsigned long flags)
 {
 	__asm__ __volatile__ (
 		"tbit.nz p6, p0 = %1,%2\n"
@@ -174,7 +174,7 @@ do {								\
 #ifdef ASM_SUPPORTED
 
 static __always_inline void
-__raw_write_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+__raw_write_lock_flags(raw_rwlock_t *lock, unsigned long flags)
 {
 	__asm__ __volatile__ (
 		"tbit.nz p6, p0 = %1, %2\n"


