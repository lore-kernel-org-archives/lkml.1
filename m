Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYJ3VDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYJ3VDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYJ3VCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:02:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56460 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303AbYJ3VCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:02:55 -0400
Subject: [VOYAGER] fix smp_intr_init() compile breakage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:02:52 -0500
Message-Id: <1225400572.19324.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4d4d1ebea1e30d0ea51784139f18aa15acbff5d9 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 29 Oct 2008 11:13:33 -0500
Subject: [VOYAGER] x86: fix smp_intr_init() compile breakage

Looks like this became static on the rest of x86.  Fix it up by adding
an external definition to mach-voyager/setup.c

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 6bbdd63..7c6ff1a 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -24,6 +24,7 @@ static struct irqaction irq2 = {
 	.name = "cascade",
 };
 
+extern void smp_intr_init(void);
 void __init intr_init_hook(void)
 {
 #ifdef CONFIG_SMP
@@ -62,7 +63,6 @@ void __init time_init_hook(void)
 char *__init machine_specific_memory_setup(void)
 {
 	char *who;
-	int new_nr;
 
 	who = "NOT VOYAGER";
 
-- 
1.5.6.5



