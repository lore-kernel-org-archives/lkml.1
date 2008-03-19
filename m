Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYCSTj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYCSTj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYCSTaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:30:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbYCSTae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:34 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH] build fix for smp
Date: Wed, 19 Mar 2008 14:11:07 -0300
Message-Id: <12059466674071-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

smp.c won't build when reboot.c is not compiled in,
due to the reboot_force dependency. It is always okay
for x86_64, but should be conditional on x86_32

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 16c52aa..0ee8ad5 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -274,8 +274,10 @@ static void native_smp_send_stop(void)
 	int nolock;
 	unsigned long flags;
 
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_BIOS_REBOOT)
 	if (reboot_force)
 		return;
+#endif
 
 	/* Don't deadlock on the call lock in panic */
 	nolock = !spin_trylock(&call_lock);
-- 
1.5.0.6

