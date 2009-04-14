Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZDNJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZDNJRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZDNJRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:17:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:55042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZDNJRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:17:05 -0400
Date: Tue, 14 Apr 2009 09:15:38 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, davem@davemloft.net, fweisbec@gmail.com,
       tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davem@davemloft.net, fweisbec@gmail.com,
       tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20090414144317.026498df.sfr@canb.auug.org.au>
References: <20090414144317.026498df.sfr@canb.auug.org.au>
Subject: [tip:core/urgent] lockdep: warn about lockdep disabling after kernel taint, fix
Message-ID: <tip-27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445@git.kernel.org>
Git-Commit-ID: 27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 09:15:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445
Gitweb:     http://git.kernel.org/tip/27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 14 Apr 2009 11:03:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 11:11:52 +0200

lockdep: warn about lockdep disabling after kernel taint, fix

Impact: build fix for Sparc and s390

Stephen Rothwell reported that the Sparc build broke:

 In file included from kernel/panic.c:12:
 include/linux/debug_locks.h: In function '__debug_locks_off':
 include/linux/debug_locks.h:15: error: implicit declaration of function 'xchg'

due to:

 9eeba61: lockdep: warn about lockdep disabling after kernel taint

There is some inconsistency between architectures about where exactly
xchg() is defined.

The traditional place is in system.h but the more logical point for it
is in atomic.h - where most architectures (especially new ones) have
it defined. These architecture also still offer it via system.h.

Some, such as Sparc or s390 only have it in asm/system.h and not available
via asm/atomic.h at all.

Use the widest set of headers in debug_locks.h and also include asm/system.h.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090414144317.026498df.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/debug_locks.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 493dedb..29b3ce3 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <asm/atomic.h>
+#include <asm/system.h>
 
 struct task_struct;
 
