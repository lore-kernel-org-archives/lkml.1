Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZGCMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZGCMoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZGCMoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:44:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:59822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbZGCMoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:44:07 -0400
Date: Fri, 3 Jul 2009 12:42:34 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
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
In-Reply-To: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
Subject: [tip:perfcounters/urgent] x86: atomic64: The atomic64_t data type should be 8 bytes aligned on 32-bit too
Message-ID: <tip-bbf2a330d92c5afccfd17592ba9ccd50f41cf748@git.kernel.org>
Git-Commit-ID: bbf2a330d92c5afccfd17592ba9ccd50f41cf748
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:42:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbf2a330d92c5afccfd17592ba9ccd50f41cf748
Gitweb:     http://git.kernel.org/tip/bbf2a330d92c5afccfd17592ba9ccd50f41cf748
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Fri, 3 Jul 2009 00:08:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 13:26:38 +0200

x86: atomic64: The atomic64_t data type should be 8 bytes aligned on 32-bit too

Locked instructions on two cache lines at once are painful. If
atomic64_t uses two cache lines, my test program is 10x slower.

The chance for that is significant: 4/32 or 12.5%.

Make sure an atomic64_t is 8 bytes aligned.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
[ changed it to __aligned(8) as per Andrew's suggestion ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/atomic_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 2503d4e..ae0fbb5 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -250,7 +250,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 /* An 64bit atomic type */
 
 typedef struct {
-	unsigned long long counter;
+	unsigned long long __aligned(8) counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(val)	{ (val) }
