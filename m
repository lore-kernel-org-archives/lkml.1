Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbYCUXHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbYCUXHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbYCUWvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:51:53 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41247 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbYCUWvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:51 -0400
Message-Id: <20080321224418.349888715@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:35 -0700
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
       Auke Kok <auke-jan.h.kok@intel.com>, Jeff Garzik <jeff@garzik.org>,
       Mike Pagano <mike@mpagano.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 45/76] e1000e: Fix CRC stripping in hardware context bug
Content-Disposition: inline; filename=e1000e-fix-crc-stripping-in-hardware-context-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Auke Kok <auke-jan.h.kok@intel.com>

CRC stripping was only correctly enabled for packet split recieves
which is used when receiving jumbo frames. Correctly enable SECRC
also for normal buffer packet receives.

Tested by Andy Gospodarek and Johan Andersson, see bugzilla #9940.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Mike Pagano <mike@mpagano.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/e1000e/netdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -1686,6 +1686,9 @@ static void e1000_setup_rctl(struct e100
 	else
 		rctl |= E1000_RCTL_LPE;
 
+	/* Enable hardware CRC frame stripping */
+	rctl |= E1000_RCTL_SECRC;
+
 	/* Setup buffer sizes */
 	rctl &= ~E1000_RCTL_SZ_4096;
 	rctl |= E1000_RCTL_BSEX;
@@ -1751,9 +1754,6 @@ static void e1000_setup_rctl(struct e100
 
 		/* Enable Packet split descriptors */
 		rctl |= E1000_RCTL_DTYP_PS;
-		
-		/* Enable hardware CRC frame stripping */
-		rctl |= E1000_RCTL_SECRC;
 
 		psrctl |= adapter->rx_ps_bsize0 >>
 			E1000_PSRCTL_BSIZE0_SHIFT;

-- 
