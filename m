Return-Path: <linux-kernel-owner+w=401wt.eu-S935583AbXEVP3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935583AbXEVP3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934885AbXEVPTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:48 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4993
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965778AbXEVPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:16 -0400
Message-Id: <20070522141251.429681560@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:48 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 07/33] xen: paravirt: export __supported_pte_mask
Content-Disposition: inline; filename=paravirt-export-supported_pte_mask.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__supported_pte_mask is needed when constructing pte values.  Xen
device drivers need to do this to make mappings of foreign pages (ie,
pages granted to us by other domains).

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/i386/mm/init.c |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -473,6 +473,7 @@ void zap_low_mappings (void)
 
 static int disable_nx __initdata = 0;
 u64 __supported_pte_mask __read_mostly = ~_PAGE_NX;
+EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 /*
  * noexec = on|off

-- 

