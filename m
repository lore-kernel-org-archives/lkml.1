Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZHUGzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZHUGzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZHUGzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZHUGzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:55:39 -0400
Date: Fri, 21 Aug 2009 02:54:54 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       bernhard.walle@gmx.de, Fenghua Yu <fenghua.yu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090821065719.4855.68203.sendpatchset@localhost.localdomain>
In-Reply-To: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
Subject: [Patch 4/8] ia64: add CONFIG_KEXEC_AUTO_RESERVE
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
