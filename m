Return-Path: <linux-kernel-owner+w=401wt.eu-S934004AbXIMXst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004AbXIMXst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932444AbXIMXpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:12 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41163 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764078AbXIMXpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:09 -0400
Date: Thu, 13 Sep 2007 16:41:18 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: sysfs: spit a warning to users when they try to create a duplicate
	sysfs file
Message-ID: <20070913234118.GH10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We want to let people know when we create a duplicate sysfs file, as
they need to fix up their code.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/dir.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -428,8 +428,12 @@ void sysfs_addrm_start(struct sysfs_addr
  */
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
-	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
+	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
+		printk(KERN_WARNING, "sysfs: duplicate filename '%s' "
+		       "can not be created\n", sd->s_name);
+		WARN_ON(1);
 		return -EEXIST;
+	}
 
 	sd->s_parent = sysfs_get(acxt->parent_sd);
 
