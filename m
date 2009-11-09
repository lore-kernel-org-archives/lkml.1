Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZKIVFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZKIVFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZKIVFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:05:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:41385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbZKIVFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:05:36 -0500
Message-ID: <4AF875D0.10602@kernel.org>
Date: Mon, 09 Nov 2009 12:04:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: pci_find_parent_resource patch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it seems this patch from Linus get lost ?

-----------------------------------------------------



from Linus

---
 drivers/pci/pci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -382,8 +382,12 @@ pci_find_parent_resource(const struct pc
 			continue;	/* Wrong type */
 		if (!((res->flags ^ r->flags) & IORESOURCE_PREFETCH))
 			return r;	/* Exact match */
-		if ((res->flags & IORESOURCE_PREFETCH) && !(r->flags & IORESOURCE_PREFETCH))
-			best = r;	/* Approximating prefetchable by non-prefetchable */
+		/* We can't insert a non-prefetch resource inside a prefetchable parent .. */
+		if (r->flags & IORESOURCE_PREFETCH)
+			continue;
+		/* .. but we can put a prefetchable resource inside a non-prefetchable one */
+		if (!best)
+			best = r;
 	}
 	return best;
 }
