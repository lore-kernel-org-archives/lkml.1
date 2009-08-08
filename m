Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZHHMOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZHHMOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 08:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZHHMOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 08:14:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:48468 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754507AbZHHMOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 08:14:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/COvh/qyfCNoPF9PAU79hKOBYuOrmxUOlJEjnnmn
	fFpvCGQKFpDq7l
Subject: [patch] perf_counter tools: fix libbfd detection for systems with
 libz dependency
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 14:14:15 +0200
Message-Id: <1249733655.6929.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_counter tools: fix libbfd detection for systems with libz dependency

Due to a libz dependency in some distro's binutils package, demangle
support isn't compiled in despite the necessary libraries being available.
Fix this by adding a -lz link test to the dependency detection rules.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

 tools/perf/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1916e44..60411e9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -387,10 +387,14 @@ else
 
 	has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
 
+	has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
+
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
 	else ifeq ($(has_bfd_iberty),y)
 		EXTLIBS += -lbfd -liberty
+	else ifeq ($(has_bfd_iberty_z),y)
+		EXTLIBS += -lbfd -liberty -lz
 	else
 		msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
 		BASIC_CFLAGS += -DNO_DEMANGLE


