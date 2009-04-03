Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbZDCKgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbZDCKgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762812AbZDCKgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:36:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762689AbZDCKgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:36:04 -0400
Date: Fri, 3 Apr 2009 10:34:33 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237898630.25315.83.camel@penberg-laptop>
References: <1237898630.25315.83.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace-v2] kmemtrace, fs: fix linux/fdtable.h header file dependencies
Message-ID: <tip-21e5445928af0d80f7cf803a77f2b65e9e147890@git.kernel.org>
Git-Commit-ID: 21e5445928af0d80f7cf803a77f2b65e9e147890
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:34:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21e5445928af0d80f7cf803a77f2b65e9e147890
Gitweb:     http://git.kernel.org/tip/21e5445928af0d80f7cf803a77f2b65e9e147890
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 25 Mar 2009 16:29:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:13:03 +0200

kmemtrace, fs: fix linux/fdtable.h header file dependencies

Impact: cleanup

We want to remove percpu.h from rcupdate.h (for upcoming kmemtrace
changes), but this is not possible currently without breaking the
build because fdtable.h has an implicit include file dependency: it
uses __init does not include init.h.

This can cause build failures on non-x86 architectures:

 /home/mingo/tip/include/linux/fdtable.h:66: error: expected '=', ',',
 ';', 'asm' or '__attribute__' before 'files_defer_init'
 make[2]: *** [fs/locks.o] Error 1

We got this header included indirectly via rcupdate.h's percpu.h
inclusion - but if that is not there the build will break.

Fix it.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/fdtable.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 09d6c5b..a2ec74b 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -5,12 +5,14 @@
 #ifndef __LINUX_FDTABLE_H
 #define __LINUX_FDTABLE_H
 
-#include <asm/atomic.h>
 #include <linux/posix_types.h>
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/types.h>
+#include <linux/init.h>
+
+#include <asm/atomic.h>
 
 /*
  * The default fd array needs to be at least BITS_PER_LONG,
