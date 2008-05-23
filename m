Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYEWNpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYEWNpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYEWNoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:21 -0400
Received: from gw.goop.org ([64.81.55.164]:53237 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbYEWNoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:18 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 04 of 12] xen: make dummy_shared_info non-static
X-Mercurial-Node: d29aba0fc84ccbe1109dc60f2277633364acbf14
Message-Id: <d29aba0fc84ccbe1109d.1211550071@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:11 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename dummy_shared_info to xen_dummy_shared_info and make it
non-static, in anticipation of users outside of enlighten.c

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    6 +++---
 arch/x86/xen/xen-ops.h   |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -75,13 +75,13 @@
 struct start_info *xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
 
-static /* __initdata */ struct shared_info dummy_shared_info;
+struct shared_info xen_dummy_shared_info;
 
 /*
  * Point at some empty memory to start with. We map the real shared_info
  * page as soon as fixmap is up and running.
  */
-struct shared_info *HYPERVISOR_shared_info = (void *)&dummy_shared_info;
+struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
 
 /*
  * Flag to determine whether vcpu info placement is available on all
@@ -104,7 +104,7 @@
 	int err;
 	struct vcpu_info *vcpup;
 
-	BUG_ON(HYPERVISOR_shared_info == &dummy_shared_info);
+	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 
 	if (!have_vcpu_info_placement)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -15,6 +15,7 @@
 DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
 extern struct start_info *xen_start_info;
+extern struct shared_info xen_dummy_shared_info;
 extern struct shared_info *HYPERVISOR_shared_info;
 
 char * __init xen_memory_setup(void);


