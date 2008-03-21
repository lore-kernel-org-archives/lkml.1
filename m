Return-Path: <linux-kernel-owner+w=401wt.eu-S1763836AbYCUXs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763836AbYCUXs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYCUXpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:38 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60182 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbYCUXp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:26 -0400
Message-Id: <20080321224331.992750489@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matheos Worku <Matheos.Worku@Sun.COM>,
       David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 05/76] NIU: More BMAC alt MAC address fixes.
Content-Disposition: inline; filename=niu-more-bmac-alt-mac-address-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Matheos Worku <Matheos.Worku@Sun.COM>

Upstream commit: fa907895b7b776208a1406efe5ba7ffe0f49f507

From: Matheos Worku <Matheos.Worku@Sun.COM>

1) niu_enable_alt_mac() needs to be adjusted so that the mask
   is computed properly for the BMAC case.

2) BMAC has 6 alt MAC addresses available, not 7.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/net/niu.c |    9 +++++----
 drivers/net/niu.h |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -1616,12 +1616,13 @@ static int niu_enable_alt_mac(struct niu
 	if (index >= niu_num_alt_addr(np))
 		return -EINVAL;
 
-	if (np->flags & NIU_FLAGS_XMAC)
+	if (np->flags & NIU_FLAGS_XMAC) {
 		reg = XMAC_ADDR_CMPEN;
-	else
+		mask = 1 << index;
+	} else {
 		reg = BMAC_ADDR_CMPEN;
-
-	mask = 1 << index;
+		mask = 1 << (index + 1);
+	}
 
 	val = nr64_mac(reg);
 	if (on)
--- a/drivers/net/niu.h
+++ b/drivers/net/niu.h
@@ -499,7 +499,7 @@
 #define BMAC_ADDR2			0x00110UL
 #define  BMAC_ADDR2_ADDR2		0x000000000000ffffULL
 
-#define BMAC_NUM_ALT_ADDR		7
+#define BMAC_NUM_ALT_ADDR		6
 
 #define BMAC_ALT_ADDR0(NUM)		(0x00118UL + (NUM)*0x18UL)
 #define  BMAC_ALT_ADDR0_ADDR0		0x000000000000ffffULL

-- 
