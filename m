Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYJQAsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYJQAsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYJQAsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:48:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYJQAsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:48:08 -0400
Date: Thu, 16 Oct 2008 20:48:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       linuxppc-dev@ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: powerpc: remove startup functions from tracing
In-Reply-To: <20081016181452.GA29739@yoda.jdub.homelinux.org>
Message-ID: <alpine.DEB.1.10.0810162046570.20570@gandalf.stny.rr.com>
References: <20080906050602.409299112@goodmis.org> <20080906120346.GA30964@elte.hu> <20081016181452.GA29739@yoda.jdub.homelinux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[
  Josh, can you see if this allows you to boot on PowerPC?
  It worked on my powerbook.
]

The early init code in PowerPC is not mapped to their final locations
and all jumps and memory references must be done with relative jumps
and accesses.

The lib files in the powerpc directory are called in early boot, and
since mcount will perform direct access to memory, the lib files need
not be traced.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/lib/Makefile |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-compile.git/arch/powerpc/lib/Makefile
===================================================================
--- linux-compile.git.orig/arch/powerpc/lib/Makefile	2008-10-16 19:26:39.000000000 -0400
+++ linux-compile.git/arch/powerpc/lib/Makefile	2008-10-16 19:26:49.000000000 -0400
@@ -2,6 +2,11 @@
 # Makefile for ppc-specific library files..
 #
 
+ifdef CONFIG_FTRACE
+ORIG_CFLAGS := $(KBUILD_CFLAGS)
+KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
+endif
+
 ifeq ($(CONFIG_PPC64),y)
 EXTRA_CFLAGS		+= -mno-minimal-toc
 endif


