Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbYEQEBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbYEQEBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 00:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYEQEBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 00:01:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYEQEBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 00:01:38 -0400
Date: Sat, 17 May 2008 00:01:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, sam@ravnborg.org, acme@redhat.com,
       srostedt@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Pekka Paalanen <pq@iki.fi>, proski@gnu.org,
       Soeren Sandmann Pedersen <sandmann@redhat.com>, a.p.zijlstra@chello.nl,
       paulus@samba.org, Sebastian Siewior <bigeasy@linutronix.de>
Subject: [PATCH] ftrace: add have dynamic ftrace config for archs
In-Reply-To: <20080514.001150.119391237.davem@davemloft.net>
Message-ID: <Pine.LNX.4.58.0805162349570.13829@gandalf.stny.rr.com>
References: <20080514063055.GA21369@elte.hu> <20080514065156.GA3159@uranus.ravnborg.org>
 <20080514070148.GA10549@elte.hu> <20080514.001150.119391237.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that ftrace is being ported to other architectures, it has become
apparent that DYNAMIC_FTRACE is dependent on whether or not that
architecture implements dynamic ftrace. FTRACE itself may be ported to
an architecture without porting dynamic ftrace.

This patch adds HAVE_DYNAMIC_FTRACE to allow architectures to port ftrace
without having to also port the dynamic aspect as well.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/Kconfig |    1 +
 arch/sparc64/Kconfig |    1 +
 arch/x86/Kconfig     |    1 +
 kernel/trace/Kconfig |    4 ++++
 4 files changed, 7 insertions(+)

Index: linux-tip.git/arch/powerpc/Kconfig
===================================================================
--- linux-tip.git.orig/arch/powerpc/Kconfig	2008-05-16 20:26:20.000000000 -0700
+++ linux-tip.git/arch/powerpc/Kconfig	2008-05-16 20:27:47.000000000 -0700
@@ -107,6 +107,7 @@ config PPC
 	default y
 	select HAVE_IDE
 	select HAVE_IMMEDIATE
+	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
Index: linux-tip.git/arch/sparc64/Kconfig
===================================================================
--- linux-tip.git.orig/arch/sparc64/Kconfig	2008-05-16 20:26:20.000000000 -0700
+++ linux-tip.git/arch/sparc64/Kconfig	2008-05-16 20:27:24.000000000 -0700
@@ -11,6 +11,7 @@ config SPARC
 config SPARC64
 	bool
 	default y
+	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_IDE
 	select HAVE_LMB
Index: linux-tip.git/arch/x86/Kconfig
===================================================================
--- linux-tip.git.orig/arch/x86/Kconfig	2008-05-16 20:26:20.000000000 -0700
+++ linux-tip.git/arch/x86/Kconfig	2008-05-16 20:27:32.000000000 -0700
@@ -23,6 +23,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-05-16 20:28:11.000000000 -0700
+++ linux-tip.git/kernel/trace/Kconfig	2008-05-16 20:35:07.000000000 -0700
@@ -4,6 +4,9 @@
 config HAVE_FTRACE
 	bool

+config HAVE_DYNAMIC_FTRACE
+	bool
+
 config TRACER_MAX_TRACE
 	bool

@@ -102,6 +105,7 @@ config CONTEXT_SWITCH_TRACER
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FTRACE
+	depends on HAVE_DYNAMIC_FTRACE
 	default y
 	help
          This option will modify all the calls to ftrace dynamically


