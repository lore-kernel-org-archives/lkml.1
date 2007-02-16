Return-Path: <linux-kernel-owner+w=401wt.eu-S1946208AbXBPVLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946208AbXBPVLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946241AbXBPVLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:11:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:39645 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946208AbXBPVLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:11:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=kUn7jhUh3xJ3Ro7yxZcbaCgsBS1nS99+5fFu4cf/DShVP51+hUtkitcJO+NJtbw2EvwX5bjXcaK1m8edtb6Rh4NrbBgyQq+5/owQuOkWNHapeEpZ5GRA11eQX+ZeA4QhlXm4zOrrSvogCZRgaiqSYO0tHZOWIGOTgxOYa9gl1ms=
Date: Sat, 17 Feb 2007 00:08:44 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Randy Vinson <rvinson@mvista.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] DS1374: check for workqueue creation
Message-ID: <20070216210844.GB10190@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks if workqueue creation failed.
Further usage of NULL pointed workqueue is not
good I guess ;)

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>

---

 drivers/i2c/chips/ds1374.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/chips/ds1374.c b/drivers/i2c/chips/ds1374.c
index 15edf40..8a2ff0c 100644
--- a/drivers/i2c/chips/ds1374.c
+++ b/drivers/i2c/chips/ds1374.c
@@ -207,6 +207,10 @@ static int ds1374_probe(struct i2c_adapter *adap, int addr, int kind)
 	client->driver = &ds1374_driver;
 
 	ds1374_workqueue = create_singlethread_workqueue("ds1374");
+	if (!ds1374_workqueue) {
+		kfree(client);
+		return -ENOMEM;	/* most expected reason */
+	}
 
 	if ((rc = i2c_attach_client(client)) != 0) {
 		kfree(client);

