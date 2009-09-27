Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZI0HWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZI0HWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 03:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZI0HWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 03:22:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:47880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbZI0HWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 03:22:21 -0400
Message-ID: <4ABF1297.90709@kernel.org>
Date: Sun, 27 Sep 2009 00:21:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: reget cfg_new in case reuse/move irq_desc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when irq_desc is moved, we need to make sure to use right cfg_new

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3169,6 +3169,7 @@ unsigned int create_irq_nr(unsigned int
 			continue;
 
 		desc_new = move_irq_desc(desc_new, node);
+		cfg_new = desc_new->chip_data;
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
