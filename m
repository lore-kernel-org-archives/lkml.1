Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbZEFVxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbZEFVxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZEFVx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:53:26 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:64628 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbZEFVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:53:25 -0400
Message-ID: <4A020726.3020009@oracle.com>
Date: Wed, 06 May 2009 14:54:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dm-devel@redhat.com
Subject: [PATCH -next] dm-table: fix printk formats
References: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
In-Reply-To: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A0206BE.02C4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

drivers/md/dm-table.c:408: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'
drivers/md/dm-table.c:414: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-table.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- linux-next-20090506.orig/drivers/md/dm-table.c
+++ linux-next-20090506/drivers/md/dm-table.c
@@ -405,14 +405,16 @@ static int device_area_is_valid(struct d
 		return 1;
 
 	if (start & (hardsect_size_sectors - 1)) {
-		DMWARN("%s: start=%lu not aligned to h/w sector of %s",
-		       dm_device_name(ti->table->md), start, bdevname(bdev, b));
+		DMWARN("%s: start=%llu not aligned to h/w sector of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)start, bdevname(bdev, b));
 		return 0;
 	}
 
 	if (len & (hardsect_size_sectors - 1)) {
-		DMWARN("%s: len=%lu not aligned to h/w sector size %hu of %s",
-		       dm_device_name(ti->table->md), len,
+		DMWARN("%s: len=%llu not aligned to h/w sector size %hu of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)len,
 		       ti->limits.hardsect_size, bdevname(bdev, b));
 		return 0;
 	}
