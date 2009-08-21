Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZHUGzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZHUGzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZHUGzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:55:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZHUGzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:55:15 -0400
Date: Fri, 21 Aug 2009 02:54:34 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       bernhard.walle@gmx.de, Fenghua Yu <fenghua.yu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090821065659.4855.46369.sendpatchset@localhost.localdomain>
In-Reply-To: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
Subject: [Patch 2/8] x86: add CONFIG_KEXEC_AUTO_RESERVE
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
@@ -1482,6 +1482,19 @@ config KEXEC
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
+	  On x86_32, 128M is reserved, on x86_64 1/32 of your memory is
+	  reserved, but it will not exceed 1T/32.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on X86_64 || (X86_32 && HIGHMEM)
