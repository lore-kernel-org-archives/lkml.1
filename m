Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZBBRxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZBBRxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757144AbZBBRxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:53:24 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:34426 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbZBBRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:53:23 -0500
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Feb 2009 12:53:22 EST
Date: Mon, 2 Feb 2009 18:28:22 +0100
From: Luca Bigliardi <shammash@artha.org>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com
Subject: [PATCH] Fix vde network backend in user mode linux
Message-ID: <20090202172822.GA2801@pintsize>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Keyserver: http://keyserver.linux.it
X-GPG-Keynumber: 0x0AF24BF4
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Replace kmalloc() with uml_kmalloc()
  (fix build failure)
* Remove unnecessary UM_KERN_INFO in printk()
  (don't display '<6>' while printing info)

Signed-off-by: Luca Bigliardi <shammash@artha.org>
---
 arch/um/drivers/vde_user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index 56533db..c5c4325 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 {
 	struct vde_open_args *args;
 
-	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
+	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
 		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
@@ -91,8 +91,8 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 	args->group = init->group;
 	args->mode = init->mode ? init->mode : 0700;
 
-	args->port ?  printk(UM_KERN_INFO "port %d", args->port) :
-		printk(UM_KERN_INFO "undefined port");
+	args->port ?  printk("port %d", args->port) :
+		printk("undefined port");
 }
 
 int vde_user_read(void *conn, void *buf, int len)
-- 
1.5.6.5

