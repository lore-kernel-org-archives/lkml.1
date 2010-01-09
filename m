Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310Ab0AIKKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0AIKKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 05:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580Ab0AIKKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 05:10:47 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44575 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0AIKKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 05:10:46 -0500
Date: Sat, 9 Jan 2010 15:40:38 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: suresh.b.siddha@intel.com, Linus Torvalds <torvalds@linux-foundation.org>
Cc: yinghai@kernel.org, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [PATCH] Make Intel 8-way Xeons boot again
Message-ID: <20100109101038.GA17555@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an 8-way system with Intel Xeon X7350 CPUs, booting 2.6.32 or newer
kernels fails at:

...
CPU0: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz stepping 0b
Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Brought up 8 CPUs
Total of 8 processors activated (46906.05 BogoMIPS).

Git bisect showed 2fbd07a5f as the offending commit.

With the patch below, I am able to boot the latest Linus' git tree on
the machine. If this patch is correct, it needs to get into the stable
tree too.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c	2010-01-09 14:54:29.000000000 +0530
+++ linux-2.6/arch/x86/kernel/apic/probe_64.c	2010-01-09 14:57:53.000000000 +0530
@@ -70,7 +70,7 @@
 	if (apic == &apic_flat) {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_INTEL:
-			if (num_processors > 8)
+			if (num_processors >= 8)
 				apic = &apic_physflat;
 			break;
 		case X86_VENDOR_AMD:
