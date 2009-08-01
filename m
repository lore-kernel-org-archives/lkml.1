Return-Path: <linux-kernel-owner+w=401wt.eu-S1751332AbZHALWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbZHALWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 07:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZHALWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 07:22:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:50563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZHALWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 07:22:46 -0400
Date: Sat, 1 Aug 2009 11:22:01 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter tools: Fix link errors with older toolchains
Message-ID: <tip-2d1b6949d2c855f195de0f5146625015ecca3944@git.kernel.org>
Git-Commit-ID: 2d1b6949d2c855f195de0f5146625015ecca3944
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 01 Aug 2009 11:22:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d1b6949d2c855f195de0f5146625015ecca3944
Gitweb:     http://git.kernel.org/tip/2d1b6949d2c855f195de0f5146625015ecca3944
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 1 Aug 2009 13:15:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 1 Aug 2009 13:15:36 +0200

perf_counter tools: Fix link errors with older toolchains

On older distros (F8 for example) the perf build could fail
with such missing symbols:

    LINK perf
/usr/lib/gcc/x86_64-redhat-linux/4.3.2/../../../../lib64/libbfd.a(bfd.o): In function `bfd_demangle':
(.text+0x2b3): undefined reference to `cplus_demangle'
/usr/lib/gcc/x86_64-redhat-linux/4.3.2/../../../../lib64/libbfd.a(bfd.o): In function `bfd_demangle':

Link in -liberty too.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a5e9b87..4b20fa4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -345,7 +345,7 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS = -lbfd
+EXTLIBS = -lbfd -liberty
 
 #
 # Platform specific tweaks
