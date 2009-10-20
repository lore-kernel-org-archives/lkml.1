Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZJTAzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZJTAzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbZJTAzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:55:04 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50794 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbZJTAzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:55:03 -0400
Date: Mon, 19 Oct 2009 20:55:03 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, nhorman@tuxdriver.com
Subject: Re: [PATCH 3/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091020005503.GD8886@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020005214.GA8886@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Add __NR_[get|set]prlimit syscall numbers to asm-generic.  I'm also adding them
    to asm-x86 since I was able to test on 32 and 64 bit intel locally here.
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 arch/x86/include/asm/unistd_32.h |    4 +++-
 arch/x86/include/asm/unistd_64.h |    4 ++++
 include/asm-generic/unistd.h     |    7 ++++++-
 include/asm-x86/asm-offsets.h    |    2 +-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 6fb3c20..06dbb34 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -342,10 +342,12 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_getprlimit		337
+#define __NR_setprlimit		338
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 337
+#define NR_syscalls 339
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 8d3ad0a..48ea56c 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -661,6 +661,10 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open			298
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_getprlimit				299
+__SYSCALL(__NR_getprlimit, sys_getprlimit)
+#define __NR_setprlimit				300
+__SYSCALL(__NR_setprlimit, sys_setprlimit)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index d76b66a..4912f71 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -623,8 +623,13 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open 241
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 
+#define __NR_getprlimit 242
+__SYSCALL(__NR_getprlimit, sys_getprlimit)
+#define __NR_setprlimit 243
+__SYSCALL(__NR_setprlimit, sys_setprlimit)
+
 #undef __NR_syscalls
-#define __NR_syscalls 242
+#define __NR_syscalls 244
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/asm-x86/asm-offsets.h b/include/asm-x86/asm-offsets.h
index 9858ff0..6a26521 100644
--- a/include/asm-x86/asm-offsets.h
+++ b/include/asm-x86/asm-offsets.h
@@ -74,7 +74,7 @@
 
 #define crypto_tfm_ctx_offset 88 /* offsetof(struct crypto_tfm, __crt_ctx)	# */
 
-#define __NR_syscall_max 298 /* sizeof(syscalls) - 1	# */
+#define __NR_syscall_max 300 /* sizeof(syscalls) - 1	# */
 
 #define BP_scratch 484 /* offsetof(struct boot_params, scratch)	# */
 #define BP_loadflags 529 /* offsetof(struct boot_params, hdr.loadflags)	# */
