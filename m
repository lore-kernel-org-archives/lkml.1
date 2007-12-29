Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbXL2RJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbXL2RJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 12:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbXL2RJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 12:09:13 -0500
Received: from elvis.franken.de ([193.175.24.41]:47497 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXL2RJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 12:09:12 -0500
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
cc: horms@verge.net.au, davem@davemloft.net
Subject: [PATCH] Fix broken ip= parsing
Message-Id: <20071229170849.C2E68C2EEE@solo.franken.de>
Date: Sat, 29 Dec 2007 18:08:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a6c05c3d064dbb83be88cba3189beb5db9d2dfc3 breaks ip= parsing
completly, because ic_enable is never set. The patch below puts
back the way ic_enable was set before.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

 net/ipv4/ipconfig.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 420f56a..4266528 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1440,6 +1440,7 @@ static int __init ip_auto_config_setup(char *addrs)
 	int num = 0;
 
 	ic_set_manually = 1;
+	ic_enable = *addrs;
 
 	if (ic_proto_name(addrs))
 		return 1;
