Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375Ab0AKNvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0AKNvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178Ab0AKNvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:51:21 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53852 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0AKNvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:51:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 11 Jan 2010 14:49:28 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] perf tools: Test if programs with -fstack-prtoector-all link
To: LKML <linux-kernel@vger.kernel.org>, linux-kernel@vger.kernel.org
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Message-id: <1263217768-6950-1-git-send-email-m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The -fstack-protector may need additional library to be present in
system thus it is not enough to test if compiler compiles program
but also whether linker links it thus "-c" flag has been removed

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 As I was corss-compiling perf compiler handled -fstack-protector-all
 nicely and so the flag has been added to CFLAGS however test for
 presence of libelf failed because linker could not link with ssp_nonshared
 library.  Removing "-c" from the -fstack-protector-all test code fixed
 problem by forcing linking and thus testing if not only compiler but the
 whole toolchain supported stack protector.

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 652a470..223e5f5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -250,7 +250,7 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
-ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o /dev/null "$(QUIET_STDERR)" && echo y"), y)
+ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -Werror -fstack-protector-all - -o /dev/null "$(QUIET_STDERR)" && echo y"), y)
   CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
 
-- 
1.6.5


