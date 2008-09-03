Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYICNfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYICNfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYICNfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:35:41 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25867 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbYICNfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:35:41 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2008 09:35:40 EDT
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="18325095"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86/paravirt: Remove duplicate paravirt_pagetable_setup_{start,done}()
Date: Wed,  3 Sep 2008 14:36:40 +0100
Message-Id: <1220449000-15264-1-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 03 Sep 2008 13:35:39.0531 (UTC) FILETIME=[F4510DB0:01C90DC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were already called once in arch/x86/kernel/setup.c - we don't need to call them again.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index b5c1751..113ec2f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -460,11 +460,7 @@ static void __init pagetable_init(void)
 {
 	pgd_t *pgd_base = swapper_pg_dir;
 
-	paravirt_pagetable_setup_start(pgd_base);
-
 	permanent_kmaps_init(pgd_base);
-
-	paravirt_pagetable_setup_done(pgd_base);
 }
 
 #ifdef CONFIG_ACPI_SLEEP
-- 
1.5.4.3

