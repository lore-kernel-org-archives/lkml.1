Return-Path: <linux-kernel-owner+w=401wt.eu-S934207AbZHELTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbZHELTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934185AbZHELTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:19:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41946 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934177AbZHELTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:19:50 -0400
Date: Wed, 5 Aug 2009 07:19:12 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090805112133.6552.69619.sendpatchset@localhost.localdomain>
In-Reply-To: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
Subject: [Patch 1/7] x86: add CONFIG_KEXEC_AUTO_RESERVE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new config option KEXEC_AUTO_RESERVE for x86.

Signed-off-by: WANG Cong <amwang@redhat.com>

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
+	  On x86, 128M is reserved.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on X86_64 || (X86_32 && HIGHMEM)
