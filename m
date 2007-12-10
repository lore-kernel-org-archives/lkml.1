Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXLJJxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXLJJxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXLJJxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:53:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46383 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXLJJxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:53:47 -0500
Date: Mon, 10 Dec 2007 15:23:50 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: akpm@linux-foundation.org
Cc: lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com
Subject: [PATCH 2/2] Kprobes: Build kretprobe samples only if arch supports kretprobes
Message-ID: <20071210095350.GB19425@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071210095221.GA19425@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210095221.GA19425@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch builds samples/kprobes/kretprobe_example.c only on archs that
support kretprobes.


Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 samples/kprobes/Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc4/samples/kprobes/Makefile
===================================================================
--- linux-2.6.24-rc4.orig/samples/kprobes/Makefile
+++ linux-2.6.24-rc4/samples/kprobes/Makefile
@@ -1,5 +1,8 @@
 # builds the kprobes example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
-obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
-		kretprobe_example.o
+obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
+
+ifeq ($(CONFIG_HAVE_KRETPROBES),y)
+obj-$(CONFIG_SAMPLE_KPROBES) += kretprobe_example.o
+endif
