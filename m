Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbZKVNRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbZKVNRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 08:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZKVNRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 08:17:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbZKVNRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 08:17:49 -0500
Date: Sun, 22 Nov 2009 15:13:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] perf: suggest static libraries as well
Message-ID: <20091122131311.GA24318@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On error, suggest installing static libraries
along with shared libraries.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ab35b0f..f57aeeb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -470,7 +470,7 @@ endif
 
 ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]);
+	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
 endif
 
 	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
@@ -510,7 +510,7 @@ else
 					EXTLIBS += -liberty
 					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 				else
-					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
+					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
 					BASIC_CFLAGS += -DNO_DEMANGLE
 				endif
 			endif
-- 
1.6.5.2.143.g8cc62
