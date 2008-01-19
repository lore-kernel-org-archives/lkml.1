Return-Path: <linux-kernel-owner+w=401wt.eu-S1765759AbYASCBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765759AbYASCBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 21:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764334AbYASB7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:59:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764293AbYASB7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:59:30 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 6/6] export __supported_pte_mask
Date: Fri, 18 Jan 2008 23:59:10 -0200
Message-Id: <1200707981233-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1200707976298-git-send-email-gcosta@redhat.com>
References: <1200707950911-git-send-email-gcosta@redhat.com> <12007079562927-git-send-email-gcosta@redhat.com> <12007079613080-git-send-email-gcosta@redhat.com> <12007079663929-git-send-email-gcosta@redhat.com> <1200707971507-git-send-email-gcosta@redhat.com> <1200707976298-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export __supported_pte_mask variable as GPL symbol.
lguest is a user of it.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/setup64.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index 8fa0de8..5cc1339 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -41,6 +41,8 @@ struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.page_aligned")));
 
 unsigned long __supported_pte_mask __read_mostly = ~0UL;
+EXPORT_SYMBOL_GPL(__supported_pte_mask);
+
 static int do_not_nx __cpuinitdata = 0;
 
 /* noexec=on|off
-- 
1.5.0.6

