Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYJ3V2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYJ3V2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYJ3V2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:28:38 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42924 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536AbYJ3V2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:28:38 -0400
Subject: [PATCH] fix compile breakage casued by x86: move
	prefill_possible_map calling early
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:28:35 -0500
Message-Id: <1225402115.19324.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2947cdda39c36e5a0d56fe0c6b70a17526abb5b5 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 30 Oct 2008 15:51:22 -0500
Subject: [VOYAGER] add prefill_possible_mask() to fix linker breakage

Before

commit 329513a35d1a2b6b28d54f5c2c0dde4face8200b
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Wed Jul 2 18:54:40 2008 -0700

    x86: move prefill_possible_map calling early

prefill_possible_mask() was hidden under CONFIG_HOTPLUG_CPU rendering
it invisitble to voyager.  Since this commit it's exposed, but not
provided by the voyager subarch, so add a dummy stub to fix the link
breakage.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 761d491..ece93b1 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -346,6 +346,12 @@ static void do_quad_bootstrap(void)
 	}
 }
 
+void prefill_possible_map(void)
+{
+	/* This is empty on voyager because we need a much
+	 * earlier detection which is done in find_smp_config */
+}
+
 /* Set up all the basic stuff: read the SMP config and make all the
  * SMP information reflect only the boot cpu.  All others will be
  * brought on-line later. */
-- 
1.5.6.5



