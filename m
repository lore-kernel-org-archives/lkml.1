Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbYAYIQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbYAYIQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763200AbYAYIAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:44 -0500
Received: from ns1.suse.de ([195.135.220.2]:59437 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760209AbYAYH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 142/196] PCMCIA: use proper call to driver_create_file
Date: Thu, 24 Jan 2008 23:32:51 -0800
Message-Id: <1201246425-5058-63-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try to call the "raw" sysfs_create_file when we already have a
helper function to do this kind of work for us.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pcmcia/ds.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 5cf89a9..15c18f5 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -312,8 +312,7 @@ pcmcia_create_newid_file(struct pcmcia_driver *drv)
 {
 	int error = 0;
 	if (drv->probe != NULL)
-		error = sysfs_create_file(&drv->drv.kobj,
-					  &driver_attr_new_id.attr);
+		error = driver_create_file(&drv->drv, &driver_attr_new_id);
 	return error;
 }
 
-- 
1.5.3.8

