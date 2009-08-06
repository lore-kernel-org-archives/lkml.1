Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZHFGVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZHFGVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZHFGVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:21:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbZHFGVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:21:47 -0400
Date: Thu, 6 Aug 2009 02:19:16 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Amerigo Wang <amwang@redhat.com>,
       akpm@linux-foundation.org, Fenghua Yu <fenghua.yu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090806062137.5578.10276.sendpatchset@localhost.localdomain>
In-Reply-To: <20090806062125.5578.72123.sendpatchset@localhost.localdomain>
References: <20090806062125.5578.72123.sendpatchset@localhost.localdomain>
Subject: [Patch 1/7] x86: add CONFIG_KEXEC_AUTO_RESERVE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new config option KEXEC_AUTO_RESERVE for x86.

Signed-off-by: WANG Cong <amwang@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

---
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -1482,6 +1482,16 @@ config KEXEC
 	  support.  As of this writing the exact hardware interface is
 	  strongly in flux, so no good recommendation can be made.
 
+config KEXEC_AUTO_RESERVE
+	bool "automatically reserve memory for kexec kernel"
+	depends on KEXEC
+	default y
+	---help---
+	  Automatically reserve memory for a kexec kernel, so that you don't
+	  need to specify numbers for the "crashkernel=X@Y" boot option,
+	  instead you can use "crashkernel=auto".
+	  On x86, 128M is reserved and only when you have memory > 4G.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on X86_64 || (X86_32 && HIGHMEM)
