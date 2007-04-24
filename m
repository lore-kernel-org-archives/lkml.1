Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXDXKAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXDXKAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXDXKAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:00:16 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:47853 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbXDXKAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:00:14 -0400
Date: Tue, 24 Apr 2007 13:59:55 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@osdl.org>
Cc: Matt Reimer <mreimer@vpop.net>, linux-kernel@vger.kernel.org
Subject: [1/2] w1: allow bus master to have reset and byte ops.
Message-ID: <20070424095954.GA16473@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 24 Apr 2007 14:00:00 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/w1_int.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 357a2e0..258defd 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -100,7 +100,8 @@ int w1_add_master_device(struct w1_bus_master *master)
 
         /* validate minimum functionality */
         if (!(master->touch_bit && master->reset_bus) &&
-            !(master->write_bit && master->read_bit)) {
+            !(master->write_bit && master->read_bit) &&
+	    !(master->write_byte && master->read_byte && master->reset_bus)) {
 		printk(KERN_ERR "w1_add_master_device: invalid function set\n");
 		return(-EINVAL);
         }

-- 
	Evgeniy Polyakov
