Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZHJOxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZHJOxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZHJOxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:53:00 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:33363 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZHJOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:52:59 -0400
Date: Mon, 10 Aug 2009 16:52:42 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Greg K-H <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Martyn Welch <martyn.welch@gefanuc.com>
Subject: [PATCH] Staging: vme: fix {master,slave}_get check bug
Message-ID: <20090810145242.GA22320@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803210111.GB28430@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's checking the wrong functions; fix it.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/vme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 8ee1192..ed2eeb0 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -338,7 +338,7 @@ int vme_slave_get (struct vme_resource *resource, int *enabled,
 
 	image = list_entry(resource->entry, struct vme_slave_resource, list);
 
-	if (bridge->slave_set == NULL) {
+	if (bridge->slave_get == NULL) {
 		printk("vme_slave_get not supported\n");
 		return -EINVAL;
 	}
@@ -499,7 +499,7 @@ int vme_master_get (struct vme_resource *resource, int *enabled,
 
 	image = list_entry(resource->entry, struct vme_master_resource, list);
 
-	if (bridge->master_set == NULL) {
+	if (bridge->master_get == NULL) {
 		printk("vme_master_set not supported\n");
 		return -EINVAL;
 	}
-- 
1.6.3.3

