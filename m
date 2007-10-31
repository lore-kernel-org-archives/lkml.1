Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbXJaG3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbXJaG3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXJaG3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:29:18 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:10368 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXJaG3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:29:17 -0400
Date: Wed, 31 Oct 2007 00:28:42 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] [POWERPC] mpc5200: Fix Kconfig dependancies on MPC5200	FEC
 device driver
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-id: <20071031062842.7966.99739.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

When not building an arch/powerpc kernel, the mpc5200 FEC driver depends
on some symbols which are not defined (BESTCOMM & BESTCOMM_FEC).

This patch flips around the dependancy logic so that it cannot be
selected unless BESTCOMM_FEC is selected first.  Kconfig stops
complaining this way.

Also, the driver only works for arch/powerpc (not arch/ppc) anyway so
it should depend on PPC_MERGE also.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/net/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 867cb73..5f800a6 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1883,9 +1883,7 @@ config FEC2
 
 config FEC_MPC52xx
 	tristate "MPC52xx FEC driver"
-	depends on PPC_MPC52xx
-	select PPC_BESTCOMM
-	select PPC_BESTCOMM_FEC
+	depends on PPC_MERGE && PPC_MPC52xx && PPC_BESTCOMM_FEC
 	select CRC32
 	select PHYLIB
 	---help---

