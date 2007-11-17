Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbXKQLDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbXKQLDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 06:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXKQLDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 06:03:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:53762 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXKQLDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 06:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=HL+pVpU3C7MTnYrT88QYyvQUFogHQBuWva9zisGFyo+MqJorZXNG/wz7iMflHoqXWVbuqor20Asrp6UrKUN3r4xva+Ie02rJDMIwRvy7wa3zfKqN2n4teqtsOydvxG9P1bY/EwEbjHJEVyh2CxmMWkBnv4y+UsjScqmA20ki2vM=
Date: Sat, 17 Nov 2007 19:57:38 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] partitions: use kasprintf
Message-ID: <20071117105738.GB4861@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use kasprintf instead of kmalloc()-strcpy()-strcat().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/partitions/check.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: 2.6-mm/fs/partitions/check.c
===================================================================
--- 2.6-mm.orig/fs/partitions/check.c
+++ 2.6-mm/fs/partitions/check.c
@@ -453,16 +453,11 @@ void add_partition(struct gendisk *disk,
 static char *make_block_name(struct gendisk *disk)
 {
 	char *name;
-	static char *block_str = "block:";
-	int size;
 	char *s;
 
-	size = strlen(block_str) + strlen(disk->disk_name) + 1;
-	name = kmalloc(size, GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, "block:%s", disk->disk_name);
 	if (!name)
 		return NULL;
-	strcpy(name, block_str);
-	strcat(name, disk->disk_name);
 	/* ewww... some of these buggers have / in name... */
 	s = strchr(name, '/');
 	if (s)
