Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbXLLPpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbXLLPpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759609AbXLLPli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:41:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759607AbXLLPlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:41:37 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/6] export math_state_restore
Date: Wed, 12 Dec 2007 10:57:22 -0200
Message-Id: <11974642553841-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974642471600-git-send-email-gcosta@redhat.com>
References: <11974642471600-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export math_state_restore symbol, so it can be used for hypervisors.
They are commonly loaded as modules (lguest being an example).

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/traps_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 3ef3bbe..38a29f9 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1073,6 +1073,7 @@ asmlinkage void math_state_restore(void)
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
+EXPORT_SYMBOL_GPL(math_state_restore);
 
 void __init trap_init(void)
 {
-- 
1.4.4.2

