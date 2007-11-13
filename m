Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbXKMPuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbXKMPuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXKMPu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:50:29 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48953 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbXKMPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:50:28 -0500
Date: Tue, 13 Nov 2007 21:20:06 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, hch@infradead.org,
       randy.dunlap@oracle.com,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       mathieu.desnoyers@polymtl.ca, davem@davemloft.net,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Subject: [patch 2/2] Kprobes: Build kretprobe samples only if arch supports kretprobes
Message-ID: <20071113155006.GC25095@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071021123919.GA7648@in.ibm.com> <20071113040045.0440e575.akpm@linux-foundation.org> <20071113153924.GA25095@in.ibm.com> <20071113154710.GB25095@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113154710.GB25095@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch builds samples/kprobes/kretprobe_example.c only on archs that
support kretprobes.


Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 samples/kprobes/Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

Index: kernel-13nov/samples/kprobes/Makefile
===================================================================
--- kernel-13nov.orig/samples/kprobes/Makefile
+++ kernel-13nov/samples/kprobes/Makefile
@@ -1,5 +1,8 @@
 # builds the kprobes example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
-obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
-		kretprobe_example.o
+obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
+
+ifeq ($(CONFIG_ARCH_SUPPORTS_KRETPROBES),y)
+obj-$(CONFIG_SAMPLE_KPROBES) += kretprobe_example.o
+endif
