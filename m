Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZLKJjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZLKJjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZLKJjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:39:40 -0500
Received: from mail2.picochip.com ([82.111.145.34]:35858 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753062AbZLKJji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:39:38 -0500
X-Greylist: delayed 793 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 04:39:37 EST
From: Jamie Iles <jamie.iles@picochip.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@picochip.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] perf tools: allow cross compiling
Date: Fri, 11 Dec 2009 09:21:00 +0000
Message-Id: <1260523260-15694-2-git-send-email-jamie.iles@picochip.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 11 Dec 2009 09:19:54 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For embedded platforms, we want to be able to build the perf
tools on a build machine to run on a different arch. This patch
allows $CROSS_COMPILE to set the cross compiler. Additionally, if
NO_LIBPERL is set, then don't use perl include paths as they will
be for the host arch.

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
CC: Peter Zijlstra <peterz@infradead.org>
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
-- 
1.6.5.4

