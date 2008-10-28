Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYJ1Xnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYJ1Xnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYJ1XnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:43:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37325 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYJ1XnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:43:21 -0400
Date: Tue, 28 Oct 2008 16:43:14 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, garyhade@us.ibm.com
Subject: x86_64: remove debug code from arch_add_memory()
Message-ID: <20081028234314.GA16140@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gets rid of dmesg spam created during physical memory hot-add which
will very likely confuse users.  The change removes what appears to
be debugging code which I assume was unintentionally included in:
  x86: arch/x86/mm/init_64.c printk fixes
  commit 10f22dde556d1ed41d55355d1fb8ad495f9810c8

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/mm/init_64.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.28-rc2/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.28-rc2.orig/arch/x86/mm/init_64.c	2008-10-28 15:39:05.000000000 -0700
+++ linux-2.6.28-rc2/arch/x86/mm/init_64.c	2008-10-28 15:39:32.000000000 -0700
@@ -836,7 +836,6 @@
 		max_pfn_mapped = last_mapped_pfn;
 
 	ret = __add_pages(zone, start_pfn, nr_pages);
-	WARN_ON(1);
 
 	return ret;
 }
