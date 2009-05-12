Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbZELInx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbZELInx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759458AbZELImM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:42:12 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:55522 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596AbZELIlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:41:42 -0400
From: Li Yang <leoli@freescale.com>
To: akpm@linux-foundation.org, galak@kernel.crashing.org, davem@davemloft.net,
       mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, Li Yang <leoli@freescale.com>
Subject: [PATCH 6/6] rio: fix section mismatch
Date: Tue, 12 May 2009 16:36:03 +0800
Message-Id: <1242117363-14949-6-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1242117363-14949-5-git-send-email-leoli@freescale.com>
References: <1242117363-14949-1-git-send-email-leoli@freescale.com>
 <1242117363-14949-2-git-send-email-leoli@freescale.com>
 <1242117363-14949-3-git-send-email-leoli@freescale.com>
 <1242117363-14949-4-git-send-email-leoli@freescale.com>
 <1242117363-14949-5-git-send-email-leoli@freescale.com>
X-OriginalArrivalTime: 12 May 2009 08:41:23.0343 (UTC) FILETIME=[6E17D1F0:01C9D2DD]
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/rapidio/rio-scan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 0838fb2..e29be3c 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -296,7 +296,7 @@ static int __devinit rio_add_device(struct rio_dev *rdev)
  * to a RIO device on success or NULL on failure.
  *
  */
-static struct rio_dev *rio_setup_device(struct rio_net *net,
+static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 					struct rio_mport *port, u16 destid,
 					u8 hopcount, int do_enum)
 {
@@ -569,7 +569,7 @@ static void rio_net_add_mport(struct rio_net *net, struct rio_mport *port)
  * Recursively enumerates a RIO network.  Transactions are sent via the
  * master port passed in @port.
  */
-static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
+static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 			 u8 hopcount)
 {
 	int port_num;
@@ -728,7 +728,7 @@ static int rio_enum_complete(struct rio_mport *port)
  * Recursively discovers a RIO network.  Transactions are sent via the
  * master port passed in @port.
  */
-static int
+static int __devinit
 rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 	      u8 hopcount)
 {
-- 
1.5.4

