Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYENJUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYENJUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYENJUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:20:36 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35161
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYENJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:20:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix crash on cpu hotplug on pat-incapable machines
Date: Wed, 14 May 2008 12:20:32 +0300
Message-Id: <1210756832-31749-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pat_disable() is __init, which means it goes away after booting is complete.
Unfortunately it is used by the hotplug code if the machine is not
pat-capable, causing a crash.

Fix by marking pat_disable() as __cpuinit.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 60adbe2..5a969c9 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -28,7 +28,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_wc_enabled = 1;
 
-void __init pat_disable(char *reason)
+void __cpuinit pat_disable(char *reason)
 {
 	pat_wc_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
-- 
1.5.5.1

