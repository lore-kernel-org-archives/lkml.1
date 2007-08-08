Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbXHHHLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbXHHHLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbXHHHIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbXHHHIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:10 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 10/25] [PATCH] export math_state_restore
Date: Wed,  8 Aug 2007 01:18:57 -0300
Message-Id: <11865467931543-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1186546789356-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export math_state_restore symbol, so it can be used for hypervisors.
They are commonly loaded as modules.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/traps.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index 0388842..aacbe12 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -1081,6 +1081,7 @@ asmlinkage void math_state_restore(void)
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
+EXPORT_SYMBOL_GPL(math_state_restore);
 
 void __init trap_init(void)
 {
-- 
1.4.4.2

