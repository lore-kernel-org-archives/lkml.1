Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYKTMpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYKTMpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYKTMo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:44:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47007 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYKTMo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:44:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Deal with the warning from dmi_low_memory_corruption() being
	unused
To: torvalds@osdl.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: dhowells@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Date: Thu, 20 Nov 2008 12:44:11 +0000
Message-ID: <20081120124411.17087.11596.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deal with the warning from dmi_low_memory_corruption() being unused when
CONFIG_X86_RESERVE_LOW_64K is not set:

arch/x86/kernel/setup.c:742: warning: 'dmi_low_memory_corruption' defined but not used

This was introduced by fc38151947477596aa27df6c4306ad6008dc6711.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0fa6790..c35ec3f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -738,6 +738,7 @@ void start_periodic_check_for_corruption(void)
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -749,6 +750,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {

