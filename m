Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZLBITs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZLBITs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZLBITs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:19:48 -0500
Received: from bamako.nerim.net ([62.4.17.28]:59080 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbZLBITr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:19:47 -0500
Date: Wed, 2 Dec 2009 09:19:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michel =?ISO-8859-15?B?RORuemVy?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] therm_adt746x: Don't access non-existing register
Message-ID: <20091202091951.5ec6bb83@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel, Darrick,

Apparently you are using the therm_adt746x driver, so maybe you would
be interested in testing and carrying the following patch. I've sent it
to Colin Leroy, who is listed as the maintainer for this driver, 1.5
month ago, but did not hear back.

* * * * *

The ADT746x don't have any register at sub-address 0, so better use an
existing register for the initial test read.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Tim Shepard <shep@alum.mit.edu>
Cc: Colin Leroy <colin@colino.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 drivers/macintosh/therm_adt746x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32-rc4.orig/drivers/macintosh/therm_adt746x.c	2009-10-12 11:53:59.000000000 +0200
+++ linux-2.6.32-rc4/drivers/macintosh/therm_adt746x.c	2009-10-14 17:27:46.000000000 +0200
@@ -387,7 +387,7 @@ static int probe_thermostat(struct i2c_c
 	i2c_set_clientdata(client, th);
 	th->clt = client;
 
-	rc = read_reg(th, 0);
+	rc = read_reg(th, CONFIG_REG);
 	if (rc < 0) {
 		dev_err(&client->dev, "Thermostat failed to read config!\n");
 		kfree(th);


-- 
Jean Delvare
