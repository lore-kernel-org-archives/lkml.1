Return-Path: <linux-kernel-owner+w=401wt.eu-S935402AbXEVPZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935402AbXEVPZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934804AbXEVPTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:34 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4983
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965698AbXEVPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:15 -0400
Message-Id: <20070522141252.222749334@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:57 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 16/33] xen: xen: add pinned page flag
Content-Disposition: inline; filename=xen-add-pinned-pageflag.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new definition for PG_owner_priv_1 to define PG_pinned on Xen
pagetable pages.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/linux/page-flags.h |    5 +++++
 1 file changed, 5 insertions(+)

===================================================================
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -93,6 +93,7 @@
 
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
+#define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */
 
 #if (BITS_PER_LONG > 32)
 /*
@@ -170,6 +171,10 @@ static inline void SetPageUptodate(struc
 #define PageChecked(page)	test_bit(PG_checked, &(page)->flags)
 #define SetPageChecked(page)	set_bit(PG_checked, &(page)->flags)
 #define ClearPageChecked(page)	clear_bit(PG_checked, &(page)->flags)
+
+#define PagePinned(page)	test_bit(PG_pinned, &(page)->flags)
+#define SetPagePinned(page)	set_bit(PG_pinned, &(page)->flags)
+#define ClearPagePinned(page)	clear_bit(PG_pinned, &(page)->flags)
 
 #define PageReserved(page)	test_bit(PG_reserved, &(page)->flags)
 #define SetPageReserved(page)	set_bit(PG_reserved, &(page)->flags)

-- 

