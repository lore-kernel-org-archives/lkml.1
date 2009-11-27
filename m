Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZK0GXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZK0GXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZK0GXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:23:16 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:19937 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZK0GXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:23:15 -0500
Message-ID: <4B0F7008.8000204@oracle.com>
Date: Thu, 26 Nov 2009 22:22:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH -next] misc/eeprom: fix at24 printk format
References: <20091126203837.b64fb4d3.sfr@canb.auug.org.au>
In-Reply-To: <20091126203837.b64fb4d3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B0F703B.0024:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/misc/eeprom/at24.c:230: warning: format '%zd' expects type 'signed size_t', but argument 6 has type 'int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Wolfram Sang <w.sang@pengutronix.de>
Cc:	David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/misc/eeprom/at24.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091126.orig/drivers/misc/eeprom/at24.c
+++ linux-next-20091126/drivers/misc/eeprom/at24.c
@@ -227,7 +227,7 @@ static ssize_t at24_eeprom_read(struct a
 			if (status == 2)
 				status = count;
 		}
-		dev_dbg(&client->dev, "read %zu@%d --> %zd (%ld)\n",
+		dev_dbg(&client->dev, "read %zu@%d --> %d (%ld)\n",
 				count, offset, status, jiffies);
 
 		if (status == count)
