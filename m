Return-Path: <linux-kernel-owner+w=401wt.eu-S933653AbZIDKKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653AbZIDKKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbZIDKK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933632AbZIDKKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:10:23 -0400
Date: Fri, 4 Sep 2009 06:08:55 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Michael Ellerman <michael@ellerman.id.au>,
       Amerigo Wang <amwang@redhat.com>, "M. Mohan Kumar" <mohan@in.ibm.com>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090904101122.5220.45724.sendpatchset@localhost.localdomain>
In-Reply-To: <20090904101047.5220.20618.sendpatchset@localhost.localdomain>
References: <20090904101047.5220.20618.sendpatchset@localhost.localdomain>
Subject: [Patch 3/8] ia64: add CONFIG_KEXEC_AUTO_RESERVE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new config option KEXEC_AUTO_RESERVE for ia64.

Signed-off-by: WANG Cong <amwang@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

---

Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig
+++ linux-2.6/arch/ia64/Kconfig
@@ -582,6 +582,20 @@ config KEXEC
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
+	  to have more than 4G memory.
+
+	  The reserved memory size is different depends on how much memory
+	  you actually have. Please check Documentation/kdump/kdump.txt.
+	  If you doubt, say N.
+
 config CRASH_DUMP
 	  bool "kernel crash dumps"
 	  depends on IA64_MCA_RECOVERY && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
