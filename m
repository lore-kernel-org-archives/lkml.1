Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbXJaWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbXJaWDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760528AbXJaWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:00:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759786AbXJaWAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:00:41 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/16] export math_state_restore
Date: Wed, 31 Oct 2007 16:14:51 -0300
Message-Id: <11938581351064-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1193858130443-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export math_state_restore symbol, so it can be used for hypervisors.
They are commonly loaded as modules (lguest being an example).

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/traps_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index d0c2bc7..a533ecd 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1077,6 +1077,7 @@ asmlinkage void math_state_restore(void)
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
+EXPORT_SYMBOL_GPL(math_state_restore);
 
 void __init trap_init(void)
 {
-- 
1.4.4.2

