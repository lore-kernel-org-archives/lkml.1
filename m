Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZDGJhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZDGJhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZDGJh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:37:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:59932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZDGJh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:37:28 -0400
Date: Tue, 7 Apr 2009 09:36:45 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090406094518.445450972@chello.nl>
References: <20090406094518.445450972@chello.nl>
Subject: [tip:perfcounters/core] x86, perfcounters: add atomic64_xchg()
Message-ID: <tip-b226fa12991d6ee9b6b13a7e1de88ec5d25f5007@git.kernel.org>
Git-Commit-ID: b226fa12991d6ee9b6b13a7e1de88ec5d25f5007
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:36:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b226fa12991d6ee9b6b13a7e1de88ec5d25f5007
Gitweb:     http://git.kernel.org/tip/b226fa12991d6ee9b6b13a7e1de88ec5d25f5007
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 7 Apr 2009 11:30:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 11:32:43 +0200

x86, perfcounters: add atomic64_xchg()

Complete atomic64_t support on the 32-bit side by adding atomic64_xch().

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090406094518.445450972@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/atomic_32.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 977250e..a9fef6c 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -306,6 +306,12 @@ static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
 	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
 }
 
+static inline void
+atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
+{
+	atomic64_set(ptr, new_val);
+}
+
 /**
  * atomic64_read - read atomic64 variable
  * @ptr:      pointer to type atomic64_t
