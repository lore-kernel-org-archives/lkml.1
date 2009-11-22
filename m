Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZKVNcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZKVNcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 08:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZKVNcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 08:32:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:55457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbZKVNcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 08:32:42 -0500
Date: Sun, 22 Nov 2009 13:30:46 GMT
From: "tip-bot for Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, mst@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, mst@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091122131311.GA24318@redhat.com>
References: <20091122131311.GA24318@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Suggest static libraries as well
Message-ID: <tip-b197c7ef7169bd5f11fb9d803b322d0daef7e256@git.kernel.org>
Git-Commit-ID: b197c7ef7169bd5f11fb9d803b322d0daef7e256
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b197c7ef7169bd5f11fb9d803b322d0daef7e256
Gitweb:     http://git.kernel.org/tip/b197c7ef7169bd5f11fb9d803b322d0daef7e256
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 22 Nov 2009 15:13:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Nov 2009 14:26:06 +0100

perf tools: Suggest static libraries as well

On error, suggest installing static libraries
along with shared libraries.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091122131311.GA24318@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 31da6be..fce4c3f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -483,7 +483,7 @@ endif
 
 ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]);
+	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
 endif
 
 	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
@@ -523,7 +523,7 @@ else
 					EXTLIBS += -liberty
 					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 				else
-					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
+					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
 					BASIC_CFLAGS += -DNO_DEMANGLE
 				endif
 			endif
