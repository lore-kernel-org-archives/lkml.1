Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYFCSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYFCSta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYFCSso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:48:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:26799 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbYFCSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=spS+jus7aruav7T9YfLA9/TX+orMc/0+q7KoODviUYEQ9yd20J7A91sCg1vYWFDpTjv0bJGjXiXNbI+e0Vl9KuJ5Y3ZtLtPigBlh8h3AkhtKgGllq+7xUj01HfF/c2uzGulvMREHeg9gz41GohMNkhHXG3kCRh5ooshcETbnF0k=
References: <20080603184648.162308982@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: [patch 2/2] x86: watchdog - check for CPU is being supported
Content-Disposition: inline; filename=nmi-watchdog-ureserve-check
Message-ID: <48459207.0407560a.301b.231b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does check if CPU is being recongnized
before call the unreserve(). Since enable_lapic_nmi_watchdog()
does have such a check the same is make sense here too
in a sake of code consistency (but nothing more).

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/cpu/perfctr-watchdog.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-06-03 20:48:26.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-06-03 21:26:00.000000000 +0400
@@ -181,7 +181,9 @@ void disable_lapic_nmi_watchdog(void)
 		return;
 
 	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
-	wd_ops->unreserve();
+
+	if (wd_ops)
+		wd_ops->unreserve();
 
 	BUG_ON(atomic_read(&nmi_active) != 0);
 }

-- 
