Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbYARUFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbYARUFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765590AbYARUEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765554AbYARUEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:34 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/10] add missing parameter for lookup_address
Date: Fri, 18 Jan 2008 15:20:16 -0200
Message-Id: <12006768362108-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <12006768251548-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lookup_address() receives two parameters, but efi_64.c call
is passing only one. It's actually preventing the tree from compiling

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/efi_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index f420819..1f8bbd9 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -45,9 +45,10 @@ static void __init early_mapping_set_exec(unsigned long start,
 					  int executable)
 {
 	pte_t *kpte;
+	int level;
 
 	while (start < end) {
-		kpte = lookup_address((unsigned long)__va(start));
+		kpte = lookup_address((unsigned long)__va(start), &level);
 		BUG_ON(!kpte);
 		if (executable)
 			set_pte(kpte, pte_mkexec(*kpte));
-- 
1.4.4.2

