Return-Path: <linux-kernel-owner+w=401wt.eu-S1763389AbYCUXrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763389AbYCUXrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYCUXpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:39 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60187 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYCUXp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:27 -0400
Message-Id: <20080321224332.857974471@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:56 -0700
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
       Matheos Worku <matheos.worku@sun.com>,
       David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/76] NIU: Fix BMAC alternate MAC address indexing.
Content-Disposition: inline; filename=niu-fix-bmac-alternate-mac-address-indexing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Matheos Worku <matheos.worku@sun.com>

Upstream commit: 3b5bcedeeb755b6e813537fcf4c32f010b490aef

BMAC port alternate MAC address index needs to start at 1. Index 0 is
used for the main MAC address.

Signed-off-by: Matheos Worku <matheos.worku@sun.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/net/niu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -5148,7 +5148,12 @@ static void niu_set_rx_mode(struct net_d
 			index++;
 		}
 	} else {
-		for (i = 0; i < niu_num_alt_addr(np); i++) {
+		int alt_start;
+		if (np->flags & NIU_FLAGS_XMAC)
+			alt_start = 0;
+		else
+			alt_start = 1;
+		for (i = alt_start; i < niu_num_alt_addr(np); i++) {
 			err = niu_enable_alt_mac(np, i, 0);
 			if (err)
 				printk(KERN_WARNING PFX "%s: Error %d "

-- 
