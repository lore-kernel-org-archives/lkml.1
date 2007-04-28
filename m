Return-Path: <linux-kernel-owner+w=401wt.eu-S1163293AbXD1SPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163293AbXD1SPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163441AbXD1SOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:14:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:38602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163279AbXD1Rwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:39 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [14/35] i386: mtrr range check correction
Message-Id: <20070428175238.C4334151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>

Whether a region is below 1Mb is determined by its start rather than
its end.

This hunk got erroneously dropped from a previous patch.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux/arch/i386/kernel/cpu/mtrr/generic.c
@@ -428,7 +428,7 @@ int generic_validate_add_page(unsigned l
 		}
 	}
 
-	if (base + size < 0x100) {
+	if (base < 0x100) {
 		printk(KERN_WARNING "mtrr: cannot set region below 1 MiB (0x%lx000,0x%lx000)\n",
 		       base, size);
 		return -EINVAL;
