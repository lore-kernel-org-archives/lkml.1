Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbYF2LAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbYF2LAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbYF2K7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:57300 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYF2K7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=OpZLTfcllJoOUsq7Dcb7QAmFS0Z3ugTy16q1rUxAZNHnXBEbhC+XBefJ9LT9u3fCY3
         bE8Ecm0u/3xaXkD+R9z57WYio1nT1VPBZJ37ziggwRBEu5iJ5HXFOP6d3w/KvdJ31LlV
         Go4viXmrjD3AwilMLbk6akCkgsUYv+/i19POw=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 01/16] ide: push pc callback pointer into the ide_drive_t structure
Date: Sun, 29 Jun 2008 12:59:04 +0200
Message-Id: <1214737159-1078-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refrain from carrying the callback ptr with every packet command since the
callback function is only one anyways. ide_drive_t is probably not the most
suitable place for it right now but is the more sane solution. Besides, these
structs are going to be reorganized anyways during the generic ide rewrite.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 include/linux/ide.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/ide.h b/include/linux/ide.h
index 5ddae9b..be1e5c9 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -286,7 +286,7 @@ struct ide_acpi_drive_link;
 struct ide_acpi_hwif_link;
 #endif
 
-typedef struct ide_drive_s {
+struct ide_drive_s {
 	char		name[4];	/* drive name, such as "hda" */
         char            driver_req[10];	/* requests specific driver */
 
@@ -379,7 +379,12 @@ typedef struct ide_drive_s {
 	struct list_head list;
 	struct device	gendev;
 	struct completion gendev_rel_comp;	/* to deal with device release() */
-} ide_drive_t;
+
+	/* callback for packet commands */
+	void (*pc_callback)(struct ide_drive_s *);
+};
+
+typedef struct ide_drive_s ide_drive_t;
 
 #define to_ide_device(dev)container_of(dev, ide_drive_t, gendev)
 
-- 
1.5.5.4

