Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZJSInc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZJSInc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZJSInc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:43:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:34569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZJSInb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:43:31 -0400
Date: Mon, 19 Oct 2009 08:42:49 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, randy.dunlap@oracle.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <4ADBCCE8.3060300@oracle.com>
References: <4ADBCCE8.3060300@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Display better error messages on missing packages
Message-ID: <tip-1abc7f5500fff8422f34826a006648d8741d83d3@git.kernel.org>
Git-Commit-ID: 1abc7f5500fff8422f34826a006648d8741d83d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Oct 2009 08:42:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1abc7f5500fff8422f34826a006648d8741d83d3
Gitweb:     http://git.kernel.org/tip/1abc7f5500fff8422f34826a006648d8741d83d3
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Sun, 18 Oct 2009 19:20:24 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 19 Oct 2009 10:06:37 +0200

perf tools: Display better error messages on missing packages

Check for libelf headers and glibc headers separately so that
the error message correctly identifies which package
installation is missing/needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: paulus@samba.org
Cc: a.p.zijlstra@chello.nl
Cc: efault@gmx.de
Cc: fweisbec@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <4ADBCCE8.3060300@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2400e50..db89a6d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -431,8 +431,12 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]);
+endif
+
 ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
-	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
+	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
 endif
 
 ifdef NO_DEMANGLE
