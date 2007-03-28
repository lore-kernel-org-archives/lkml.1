Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXC1Anx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXC1Anx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 20:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXC1Anx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 20:43:53 -0400
Received: from imf18aec.mail.bellsouth.net ([205.152.59.66]:57887 "EHLO
	imf18aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934300AbXC1Anv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 20:43:51 -0400
Date: Tue, 27 Mar 2007 19:43:49 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jareguero@telefonica.net, atl1-devel@lists.sourceforge.net
Subject: [PATCH] atl1: remove unnecessary crc inversion
Message-ID: <20070328004349.GA2792@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

The original vendor driver contained a private ether_crc_le() function
that produced an inverted crc.  When we changed to the kernel version of
ether_crc_le(), we neglected to undo the inversion.  Let's do it now.
Discovered by and patch proffered by Jose Alberto Reguero.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---

 drivers/net/atl1/atl1_hw.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atl1/atl1_hw.c b/drivers/net/atl1/atl1_hw.c
index 314dbaa..69482e0 100644
--- a/drivers/net/atl1/atl1_hw.c
+++ b/drivers/net/atl1/atl1_hw.c
@@ -334,7 +334,6 @@ u32 atl1_hash_mc_addr(struct atl1_hw *hw, u8 *mc_addr)
 	int i;
 
 	crc32 = ether_crc_le(6, mc_addr);
-	crc32 = ~crc32;
 	for (i = 0; i < 32; i++)
 		value |= (((crc32 >> i) & 1) << (31 - i));
 
