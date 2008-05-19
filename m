Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbYESUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbYESUvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761147AbYESUub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:50:31 -0400
Received: from mx1.riseup.net ([204.13.164.18]:47514 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760725AbYESUua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:50:30 -0400
Message-Id: <20080519204839.185643940@kaehlcke.net>
References: <20080519204838.612046856@kaehlcke.net>
User-Agent: quilt/0.46-1
Date: Mon, 19 May 2008 22:48:39 +0200
From: matthias@kaehlcke.net
To: khali@linux-fr.org, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [patch 1/2] i2c_del_adapter(): use list_for_each_entry_safe()
Content-Disposition: inline; filename=i2c_del_adapter-list_for_each_entry_safe.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c-core.c: use list_for_each_entry_safe() in i2c_del_adapter()

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--- linux-2.6.orig/drivers/i2c/i2c-core.c	2008-05-19 22:30:41.000000000 +0200
+++ linux-2.6/drivers/i2c/i2c-core.c	2008-05-19 22:30:59.000000000 +0200
@@ -582,8 +582,7 @@
  */
 int i2c_del_adapter(struct i2c_adapter *adap)
 {
-	struct list_head  *item, *_n;
-	struct i2c_client *client;
+	struct i2c_client *client, *_n;
 	int res = 0;
 
 	mutex_lock(&core_lock);
@@ -604,10 +603,9 @@
 
 	/* detach any active clients. This must be done first, because
 	 * it can fail; in which case we give up. */
-	list_for_each_safe(item, _n, &adap->clients) {
+	list_for_each_entry_safe(client, _n, &adap->clients, list) {
 		struct i2c_driver	*driver;
 
-		client = list_entry(item, struct i2c_client, list);
 		driver = client->driver;
 
 		/* new style, follow standard driver model */

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
