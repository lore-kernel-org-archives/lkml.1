Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZLKK2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZLKK2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZLKK2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:28:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:38640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbZLKK2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:28:08 -0500
Date: Fri, 11 Dec 2009 10:27:32 GMT
From: tip-bot for Jamie Iles <jamie.iles@picochip.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jamie.iles@picochip.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, jamie.iles@picochip.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1260523260-15694-2-git-send-email-jamie.iles@picochip.com>
References: <1260523260-15694-2-git-send-email-jamie.iles@picochip.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Allow cross compiling
Message-ID: <tip-cc835752ae3634acd2d487fdf5152f6075f45aef@git.kernel.org>
Git-Commit-ID: cc835752ae3634acd2d487fdf5152f6075f45aef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc835752ae3634acd2d487fdf5152f6075f45aef
Gitweb:     http://git.kernel.org/tip/cc835752ae3634acd2d487fdf5152f6075f45aef
Author:     Jamie Iles <jamie.iles@picochip.com>
AuthorDate: Fri, 11 Dec 2009 09:21:00 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Dec 2009 11:24:13 +0100

perf tools: Allow cross compiling

For embedded platforms, we want to be able to build the perf
tools on a build machine to run on a different arch. This patch
allows $CROSS_COMPILE to set the cross compiler.

Additionally, if NO_LIBPERL is set, then don't use perl include
paths as they will be for the host arch.

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1260523260-15694-2-git-send-email-jamie.iles@picochip.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 23ec660..e2ee3b5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -237,8 +237,8 @@ lib = lib
 
 export prefix bindir sharedir sysconfdir
 
-CC = gcc
-AR = ar
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
 RM = rm -f
 TAR = tar
 FIND = find
@@ -492,8 +492,10 @@ else
 	LIB_OBJS += util/probe-finder.o
 endif
 
+ifndef NO_LIBPERL
 PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
 PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+endif
 
 ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; echo 'int main(void) { perl_alloc(); return 0; }') | $(CC) -x c - $(PERL_EMBED_CCOPTS) -o /dev/null $(PERL_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
 	BASIC_CFLAGS += -DNO_LIBPERL
