Return-Path: <linux-kernel-owner+w=401wt.eu-S967214AbYCSWyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967214AbYCSWyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966088AbYCSVWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:22:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765820AbYCSVWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:22:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Richard Henderson <rth@twiddle.net>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 8/8] powerpc ptrace: arch_ptrace -ENOSYS return
In-Reply-To: Roland McGrath's message of  Wednesday, 19 March 2008 14:17:14 -0700 <20080319211714.8B14226F995@magilla.localdomain>
References: <20080319211714.8B14226F995@magilla.localdomain>
X-Shopping-List: (1) Persistent superfluous pancake paradoxes
   (2) Capacious holidays
   (3) Propitious charismatic ghost-melts
Message-Id: <20080319212110.082F126F995@magilla.localdomain>
Date: Wed, 19 Mar 2008 14:21:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOSYS from arch_ptrace and compat_arch_ptrace
rather than calling ptrace_request or compat_ptrace_request.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c   |    2 +-
 arch/powerpc/kernel/ptrace32.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 2a9fe97..47b701e 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -843,7 +843,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	default:
-		ret = ptrace_request(child, request, addr, data);
+		ret = -ENOSYS;
 		break;
 	}
 	return ret;
diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index 4c1de6a..7383d15 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -306,7 +306,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		break;
 
 	default:
-		ret = compat_ptrace_request(child, request, addr, data);
+		ret = -ENOSYS;
 		break;
 	}
 
