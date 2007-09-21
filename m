Return-Path: <linux-kernel-owner+w=401wt.eu-S1764438AbXIUUuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764438AbXIUUuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbXIUUpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:32970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763287AbXIUUpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:00 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: eranian@hpl.hp.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [17/45] i386: make Oprofile call shutdown() only once per session
Message-Id: <20070921204458.EECA914EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephane Eranian <eranian@hpl.hp.com>

Oprofile: call model->shutdown() only once to avoid calling release_ev*() 
multiple times
    
Signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/oprofile/nmi_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/oprofile/nmi_int.c
===================================================================
--- linux.orig/arch/i386/oprofile/nmi_int.c
+++ linux/arch/i386/oprofile/nmi_int.c
@@ -269,7 +269,6 @@ static void nmi_cpu_shutdown(void * dumm
 	apic_write(APIC_LVTPC, saved_lvtpc[cpu]);
 	apic_write(APIC_LVTERR, v);
 	nmi_restore_registers(msrs);
-	model->shutdown(msrs);
 }
 
  
@@ -278,6 +277,7 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	model->shutdown(cpu_msrs);
 	free_msrs();
 }
 
