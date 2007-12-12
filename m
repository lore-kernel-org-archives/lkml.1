Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbXLLPTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbXLLPTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXLLPTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:19:25 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:20128
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859AbXLLPTY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:19:24 -0500
Message-Id: <47600A3D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 12 Dec 2007 15:20:13 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tony.luck@intel.com>
Cc: <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ia64: remove dead code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither __cpu_down() nor __cpu_die() are being referenced without
CONFIG_HOTPLUG_CPU.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/ia64/kernel/smpboot.c |   11 -----------
 1 file changed, 11 deletions(-)

--- linux-2.6.24-rc5/arch/ia64/kernel/smpboot.c	2007-12-12 12:27:11.000000000 +0100
+++ 2.6.24-rc5-ia64-cpu-die/arch/ia64/kernel/smpboot.c	2007-12-07 16:12:33.000000000 +0100
@@ -767,17 +767,6 @@ void __cpu_die(unsigned int cpu)
 	}
  	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
-#else /* !CONFIG_HOTPLUG_CPU */
-int __cpu_disable(void)
-{
-	return -ENOSYS;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We said "no" in __cpu_disable */
-	BUG();
-}
 #endif /* CONFIG_HOTPLUG_CPU */
 
 void



