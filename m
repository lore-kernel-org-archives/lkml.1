Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbZIDKMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbZIDKMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933583AbZIDKMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbZIDKMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:12:14 -0400
Date: Fri, 4 Sep 2009 06:09:16 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Amerigo Wang <amwang@redhat.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       "M. Mohan Kumar" <mohan@in.ibm.com>, akpm@linux-foundation.org,
       bernhard.walle@gmx.de, Fenghua Yu <fenghua.yu@intel.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090904101143.5220.61131.sendpatchset@localhost.localdomain>
In-Reply-To: <20090904101047.5220.20618.sendpatchset@localhost.localdomain>
References: <20090904101047.5220.20618.sendpatchset@localhost.localdomain>
Subject: [Patch 5/8] powerpc: add CONFIG_KEXEC_AUTO_RESERVE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new config option KEXEC_AUTO_RESERVE for powerpc.

Signed-off-by: WANG Cong <amwang@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

---

Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig
+++ linux-2.6/arch/powerpc/Kconfig
@@ -346,6 +346,17 @@ config KEXEC
 	  support.  As of this writing the exact hardware interface is
 	  strongly in flux, so no good recommendation can be made.
 
+config KEXEC_AUTO_RESERVE
+	bool "automatically reserve memory for kexec kernel"
+	depends on KEXEC
+	default y
+	---help---
+	  Automatically reserve memory for a kexec kernel, so that you don't
+	  need to specify numbers for the "crashkernel=X@Y" boot option,
+	  instead you can use "crashkernel=auto". To make this work, you need
+	  to have more than 2G memory. On PPC, 128M or 256M is reserved, on
+	  PPC64 1/32 of your physical memory, but it will not exceed 4G.
+
 config CRASH_DUMP
 	bool "Build a kdump crash kernel"
 	depends on PPC64 || 6xx
