Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZDYNHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZDYNHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 09:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZDYNHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 09:07:37 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:54065 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZDYNHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 09:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=HYXJ3bipAtyDoF/RSpnhZzIkazJWJAWm1uaciirJ5sdjX5KWLSzyQDJZc/vFiF0+qf
         Y+sWJi30+EYTrZymUST+ZeKVWtvXfHw+cUj1s8reHHY29DBv5hVKOG20KsUVzjwsTiQm
         Li5wlvpOxNhYdRAwfMUiaThUegdIbMdDCPsHY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: unsik Kim <donari75@gmail.com>
Subject: [PATCH 1/3] mg_disk: fix CONFIG_LBD=y warning
Date: Sat, 25 Apr 2009 15:03:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904251503.23211.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/block/mg_disk.c: In function ‘mg_dump_status’:
drivers/block/mg_disk.c:265: warning: format ‘%ld’ expects type ‘long int’, but
argument 2 has type ‘sector_t’

Cc: unsik Kim <donari75@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
few more mg_disk patches on top of http://lkml.org/lkml/2009/4/24/334

 drivers/block/mg_disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/block/mg_disk.c
===================================================================
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -262,7 +262,7 @@ static void mg_dump_status(const char *m
 			if (host->breq) {
 				req = elv_next_request(host->breq);
 				if (req)
-					printk(", sector=%ld", req->sector);
+					printk(", sector=%u", (u32)req->sector);
 			}
 
 		}
