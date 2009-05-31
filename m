Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZEaOe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZEaOe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbZEaOeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:34:02 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49478 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbZEaOeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AIEyCdJTEvHyhJcSC+ZDn2jp+IDbBQFwC9vis0tG3LizE3y2XkbqUNVKeUjxr/DepJ
         sQLvOBy/LUIgi/6z2KMGR2ddQfVenvspsUydPLp6Ics4mwWLaNSp9z/lGYrxz2hYLHTK
         tZ/fV+uH6j8oIMK4NbSozSgjrLAKuIlIetYE0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Date: Sun, 31 May 2009 16:39:18 +0200
Message-Id: <20090531143918.7164.14969.sendpatchset@localhost.localdomain>
In-Reply-To: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/4] partitions: warn about the partition exceeding device capacity
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] partitions: warn about the partition exceeding device capacity

The current warning message says only about the kernel's action taken
without mentioning the underlying reason behind it.

Noticed-by: Robert Hancock <hancockrwd@gmail.com>
Cc: Frans Pop <elendil@planet.nl>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 fs/partitions/check.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/fs/partitions/check.c
===================================================================
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -574,7 +574,8 @@ int rescan_partitions(struct gendisk *di
 			 * creating invalid block devices
 			 */
 			printk(KERN_WARNING
-			       "%s: p%d size %llu limited to end of disk\n",
+			       "%s: p%d size %llu exceeds device capacity, "
+			       "limited to end of disk\n",
 			       disk->disk_name, p, (unsigned long long) size);
 			size = get_capacity(disk) - from;
 		}
