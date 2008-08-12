Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYHLMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYHLMZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYHLMZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:25:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYHLMZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:25:47 -0400
Subject: [PATCH] Fix date output in x86 microcode driver.
From: David Woodhouse <dwmw2@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 12 Aug 2008 13:25:44 +0100
Message-Id: <1218543944.2977.164.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The microcode stores its date in a uint32_t in some weird order
approximating pdp-endian. Rather than printing it like that, print it
properly in ISO standard form.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 652fa5c..394fbdd 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -343,8 +343,9 @@ static void apply_microcode(int cpu)
 		return;
 	}
 	printk(KERN_INFO "microcode: CPU%d updated from revision "
-	       "0x%x to 0x%x, date = %08x \n",
-	       cpu_num, uci->rev, val[1], uci->mc->hdr.date);
+	       "0x%x to 0x%x, date = %04x-%02x-%02x \n",
+	       cpu_num, uci->rev, val[1], uci->mc->hdr.date & 0xffff,
+	       uci->mc->hdr.date >> 24, (uci->mc->hdr.date >> 16) & 0xff);
 	uci->rev = val[1];
 }
 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



