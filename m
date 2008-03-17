Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYCRFax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYCRFax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYCRFYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:25 -0400
Received: from gw.goop.org ([64.81.55.164]:37860 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbYCRFYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 19 of 31] xen: use phys_addr_t when referring to physical
	addresses
X-Mercurial-Node: 9591039c4a6cfc6d1d3ce87bb24d281893b15267
Message-Id: <9591039c4a6cfc6d1d3c.1205797030@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/xen/page.h |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/xen/page.h b/include/xen/page.h
--- a/include/xen/page.h
+++ b/include/xen/page.h
@@ -8,27 +8,15 @@
 
 #include <xen/features.h>
 
-#ifdef CONFIG_X86_PAE
 /* Xen machine address */
 typedef struct xmaddr {
-	unsigned long long maddr;
+	phys_addr_t maddr;
 } xmaddr_t;
 
 /* Xen pseudo-physical address */
 typedef struct xpaddr {
-	unsigned long long paddr;
+	phys_addr_t paddr;
 } xpaddr_t;
-#else
-/* Xen machine address */
-typedef struct xmaddr {
-	unsigned long maddr;
-} xmaddr_t;
-
-/* Xen pseudo-physical address */
-typedef struct xpaddr {
-	unsigned long paddr;
-} xpaddr_t;
-#endif
 
 #define XMADDR(x)	((xmaddr_t) { .maddr = (x) })
 #define XPADDR(x)	((xpaddr_t) { .paddr = (x) })


