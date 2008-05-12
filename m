Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYELNjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYELNjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYELNi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:38:56 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:44201 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbYELNiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:38:55 -0400
Date: Mon, 12 May 2008 15:38:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jpr@f6fbb.org, linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/6] drivers/net/hamradio: remove null pointer dereference
Message-ID: <Pine.LNX.4.64.0805121538270.3694@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If dev is NULL, it is not possible to access its name field.  So I have
simply modified the error message to drop the printing of the name field.


This problem was found using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
--- a/drivers/net/hamradio/yam.c	2008-04-07 13:50:26.000000000 +0200
+++ b/drivers/net/hamradio/yam.c	2008-05-12 09:52:58.000000000 +0200
@@ -1123,8 +1123,7 @@ static int __init yam_init_driver(void)
 		dev = alloc_netdev(sizeof(struct yam_port), name,
 				   yam_setup);
 		if (!dev) {
-			printk(KERN_ERR "yam: cannot allocate net device %s\n",
-			       dev->name);
+			printk(KERN_ERR "yam: cannot allocate net device\n");
 			err = -ENOMEM;
 			goto error;
 		}
