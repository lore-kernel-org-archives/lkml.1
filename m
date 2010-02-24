Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0BXIK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:10:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:58741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab0BXIKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:10:24 -0500
Date: Wed, 24 Feb 2010 08:09:58 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4B8493A0.6080501@kernel.org>
References: <4B8493A0.6080501@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, legacy_irq: Remove duplicate vector assigment
Message-ID: <tip-8cdf5dcab80d5933b048118368caf75df21d2788@git.kernel.org>
Git-Commit-ID: 8cdf5dcab80d5933b048118368caf75df21d2788
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:10:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cdf5dcab80d5933b048118368caf75df21d2788
Gitweb:     http://git.kernel.org/tip/8cdf5dcab80d5933b048118368caf75df21d2788
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 23 Feb 2010 18:49:04 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:23:29 -0800

x86, legacy_irq: Remove duplicate vector assigment

Remove duplicated cfg[i].vector assignment.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B8493A0.6080501@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b9d08f0..b758d49 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -161,8 +161,6 @@ int __init arch_early_irq_init(void)
 	node= cpu_to_node(boot_cpu_id);
 
 	for (i = 0; i < count; i++) {
-		if (i < legacy_pic->nr_legacy_irqs)
-			cfg[i].vector = IRQ0_VECTOR + i;
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
