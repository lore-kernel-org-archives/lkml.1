Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXLKGYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXLKGYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 01:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXLKGYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 01:24:33 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42786 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXLKGYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 01:24:32 -0500
Date: Tue, 11 Dec 2007 11:54:02 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: akpm@linux-foundation.org
Cc: lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com, sam@ravnborg.org
Subject: [PATCH 2/2 V2] Kprobes: Build kretprobe examples only if arch supports kretprobes
Message-ID: <20071211062402.GB10166@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071211062219.GA10166@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211062219.GA10166@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch builds samples/kprobes/kretprobe_example.c only on archs that
support kretprobes. Thanks to Sam Ravnborg for Kconfig suggestions.

V2: Updated dependency on CONFIG_KRETPROBES

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 samples/Kconfig          |    5 +++++
 samples/kprobes/Makefile |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc4/samples/kprobes/Makefile
===================================================================
--- linux-2.6.24-rc4.orig/samples/kprobes/Makefile
+++ linux-2.6.24-rc4/samples/kprobes/Makefile
@@ -1,5 +1,5 @@
 # builds the kprobes example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
-obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
-		kretprobe_example.o
+obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
+obj-$(CONFIG_SAMPLE_KRETPROBES) += kretprobe_example.o
Index: linux-2.6.24-rc4/samples/Kconfig
===================================================================
--- linux-2.6.24-rc4.orig/samples/Kconfig
+++ linux-2.6.24-rc4/samples/Kconfig
@@ -28,5 +28,10 @@ config SAMPLE_KPROBES
 	help
 	  This build several kprobes example modules.
 
+config SAMPLE_KRETPROBES
+	tristate "Build kretprobes example -- loadable modules only"
+	default m
+	depends on SAMPLE_KPROBES && KRETPROBES
+
 endif # SAMPLES
 
