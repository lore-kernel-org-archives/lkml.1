Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbXEUTuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbXEUTuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXEUT3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52635 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934060AbXEUT3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:05 -0400
Message-Id: <20070521191752.499928000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:10 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de
Subject: [patch 58/69] SPARC64: Be more resiliant with PCI I/O space regs.
Content-Disposition: inline; filename=sparc64-be-more-resiliant-with-pci-i-o-space-regs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

If we miss on the ranges, just toss the translation up to the parent
instead of failing.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/sparc64/kernel/of_device.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2.6.21.1.orig/arch/sparc64/kernel/of_device.c
+++ linux-2.6.21.1/arch/sparc64/kernel/of_device.c
@@ -508,6 +508,13 @@ static int __init build_one_resource(str
 			return 0;
 	}
 
+	/* When we miss an I/O space match on PCI, just pass it up
+	 * to the next PCI bridge and/or controller.
+	 */
+	if (!strcmp(bus->name, "pci") &&
+	    (addr[0] & 0x03000000) == 0x01000000)
+		return 0;
+
 	return 1;
 }
 

-- 
