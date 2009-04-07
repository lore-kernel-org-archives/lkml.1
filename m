Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbZDGOsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbZDGOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZDGOso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:48:44 -0400
Received: from mx1.emlix.com ([193.175.82.87]:47997 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZDGOso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:48:44 -0400
From: Johannes Weiner <jw@emlix.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] i2c-s6000: don't use device->bus_id directly
Date: Tue,  7 Apr 2009 16:50:18 +0200
Message-Id: <1239115818-22035-1-git-send-email-jw@emlix.com>
In-Reply-To: <20090407100012.GA13800@fluff.org.uk>
References: <20090407100012.GA13800@fluff.org.uk>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the dev_name() helper to get a name string for a device instead of
open-coding random device field accesses.

With '1fa5ae8 driver core: get rid of struct device's bus_id string
array' in place, this is not just a cleanup but a compilation fix.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 drivers/i2c/busses/i2c-s6000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Sorry, went unnoticed until the compilation broke on a newer kernel
with the above mentioned commit.  Please apply.

diff --git a/drivers/i2c/busses/i2c-s6000.c b/drivers/i2c/busses/i2c-s6000.c
index c91359f..a19af51 100644
--- a/drivers/i2c/busses/i2c-s6000.c
+++ b/drivers/i2c/busses/i2c-s6000.c
@@ -276,7 +276,7 @@ static int __devinit s6i2c_probe(struct platform_device *dev)
 	}
 	iface->res = request_mem_region(iface->res->start,
 					resource_size(iface->res),
-					dev->dev.bus_id);
+					dev_name(&dev->dev));
 	if (!iface->res) {
 		rc = -EBUSY;
 		goto err_out;
-- 
1.6.2.107.ge47ee

