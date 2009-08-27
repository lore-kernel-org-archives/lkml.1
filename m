Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbZH0DRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbZH0DRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZH0DRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:17:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZH0DRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:17:14 -0400
Date: Wed, 26 Aug 2009 23:16:31 -0400
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
Message-Id: <20090827031858.4534.6233.sendpatchset@localhost.localdomain>
In-Reply-To: <20090827031800.4534.94868.sendpatchset@localhost.localdomain>
References: <20090827031800.4534.94868.sendpatchset@localhost.localdomain>
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
