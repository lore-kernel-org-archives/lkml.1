Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbXJIWHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbXJIWHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXJIWH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:07:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57717 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbXJIWH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:07:26 -0400
Date: Tue, 9 Oct 2007 15:08:24 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
Subject: [PATCH] ibmpex: Release IPMI user if hwmon registration fails
Message-ID: <20071009220824.GL16752@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164905.GM32667@tree.beaverton.ibm.com> <20070828232504.GP32667@tree.beaverton.ibm.com> <20070911132335.GJ31992@jupiter.solarsys.private> <20070914193346.GM30825@tree.beaverton.ibm.com> <20071009120044.GP3835@jupiter.solarsys.private> <470BAFD7.10305@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470BAFD7.10305@tiscali.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <12o3l@tiscali.nl> found a minor defect in the init code if
hwmon device registration fails.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmpex.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index fe2c261..c462824 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -498,8 +498,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 		printk(KERN_ERR DRVNAME ": Error, unable to register hwmon "
 		       "class device for interface %d\n",
 		       data->interface);
-		kfree(data);
-		return;
+		goto out_user;
 	}
 
 	/* finally add the new bmc data to the bmc data list */
