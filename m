Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbYLOXjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbYLOXjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYLOXjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:39:22 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:35782 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbYLOXjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:39:20 -0500
Message-ID: <4946EA7F.1@oracle.com>
Date: Mon, 15 Dec 2008 15:38:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] mtd: fix nettel printk formats
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
In-Reply-To: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4946EA73.0031:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format references:

drivers/mtd/maps/nettel.c:361: warning: format '%d' expects type 'int', but argument 2 has type 'uint64_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mtd/maps/nettel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20081215.orig/drivers/mtd/maps/nettel.c
+++ linux-next-20081215/drivers/mtd/maps/nettel.c
@@ -357,8 +357,8 @@ static int __init nettel_init(void)
 		*intel1par = 0;
 	}
 
-	printk(KERN_NOTICE "SNAPGEAR: Intel flash device size = %dK\n",
-		(intel_mtd->size >> 10));
+	printk(KERN_NOTICE "SNAPGEAR: Intel flash device size = %lluK\n",
+		(unsigned long long)(intel_mtd->size >> 10));
 
 	intel_mtd->owner = THIS_MODULE;
 
