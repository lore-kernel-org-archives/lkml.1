Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZCEXjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZCEXjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbZCEXjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:39:40 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:45728 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbZCEXjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:39:39 -0500
Message-Id: <20090305225518.363979815@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       "William L. Irwin" <wli@holomorphy.com>
Subject: [RFC patch 30/41] LTTng build
Content-Disposition: inline; filename=lttng-build-instrumentation-menu.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the basic LTTng config options.

sparc32 needs to have ltt/ added to core-y for some reason (seems broken).

ltt/Kconfig is sourced from kernel/Kconfig.instrumentation.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: William L. Irwin <wli@holomorphy.com>
---
 Makefile            |    2 +-
 arch/sparc/Makefile |    2 +-
 init/Kconfig        |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/sparc/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Makefile	2009-03-05 15:57:40.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/Makefile	2009-03-05 15:57:45.000000000 -0500
@@ -81,7 +81,7 @@ drivers-$(CONFIG_OPROFILE)	+= arch/sparc
 # Export what is needed by arch/sparc/boot/Makefile
 export VMLINUX_INIT VMLINUX_MAIN
 VMLINUX_INIT := $(head-y) $(init-y)
-VMLINUX_MAIN := $(core-y) kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+VMLINUX_MAIN := $(core-y) kernel/ mm/ fs/ ipc/ security/ crypto/ block/ ltt/
 VMLINUX_MAIN += $(patsubst %/, %/lib.a, $(libs-y)) $(libs-y)
 VMLINUX_MAIN += $(drivers-y) $(net-y)
 
Index: linux-2.6-lttng/Makefile
===================================================================
--- linux-2.6-lttng.orig/Makefile	2009-03-05 15:57:40.000000000 -0500
+++ linux-2.6-lttng/Makefile	2009-03-05 15:57:45.000000000 -0500
@@ -630,7 +630,7 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ ltt/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2009-03-05 15:57:40.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2009-03-05 15:57:45.000000000 -0500
@@ -987,6 +987,8 @@ config MARKERS
 
 source "arch/Kconfig"
 
+source "ltt/Kconfig"
+
 endmenu		# General setup
 
 config HAVE_GENERIC_DMA_COHERENT

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
