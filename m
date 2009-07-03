Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbZGCTT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbZGCTT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZGCTTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:19:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbZGCTTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:19:19 -0400
Date: Fri, 3 Jul 2009 19:18:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
       arnd@arndb.de, dhowells@redhat.com, fweisbec@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       arnd@arndb.de, fweisbec@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.01.0907030942260.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907030942260.3210@localhost.localdomain>
Subject: [tip:perfcounters/urgent] x86: atomic64: Clean up atomic64_sub_and_test() and atomic64_add_negative()
Message-ID: <tip-ddf9a003d32f720805ac30bcc15755e9289073de@git.kernel.org>
Git-Commit-ID: ddf9a003d32f720805ac30bcc15755e9289073de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 19:18:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddf9a003d32f720805ac30bcc15755e9289073de
Gitweb:     http://git.kernel.org/tip/ddf9a003d32f720805ac30bcc15755e9289073de
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 3 Jul 2009 20:11:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 21:15:08 +0200

x86: atomic64: Clean up atomic64_sub_and_test() and atomic64_add_negative()

Linus noticed that the variable name 'old_val' is
confusingly named in these functions - the correct
naming is 'new_val'.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <alpine.LFD.2.01.0907030942260.3210@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/lib/atomic64_32.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index a804f96..1d98c9e 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -175,9 +175,9 @@ EXPORT_SYMBOL(atomic64_sub);
  */
 int atomic64_sub_and_test(u64 delta, atomic64_t *ptr)
 {
-	u64 old_val = atomic64_sub_return(delta, ptr);
+	u64 new_val = atomic64_sub_return(delta, ptr);
 
-	return old_val == 0;
+	return new_val == 0;
 }
 EXPORT_SYMBOL(atomic64_sub_and_test);
 
@@ -244,8 +244,8 @@ EXPORT_SYMBOL(atomic64_inc_and_test);
  */
 int atomic64_add_negative(u64 delta, atomic64_t *ptr)
 {
-	long long old_val = atomic64_add_return(delta, ptr);
+	s64 new_val = atomic64_add_return(delta, ptr);
 
-	return old_val < 0;
+	return new_val < 0;
 }
 EXPORT_SYMBOL(atomic64_add_negative);
