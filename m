Return-Path: <linux-kernel-owner+w=401wt.eu-S934441AbZLGA1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441AbZLGA1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934412AbZLGA12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:27:28 -0500
Received: from kroah.org ([198.145.64.141]:34458 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505AbZLGANQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:16 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:50 2009
Message-Id: <20091207000650.383217514@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [058/119] rfkill: fix miscdev ops
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=rfkill-fix-miscdev-ops.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johannes Berg <johannes@sipsolutions.net>

commit 45ba564d765d6165330e9bb14a197bdd348c114d upstream.

The /dev/rfkill ops don't refer to the module,
so it is possible to unload the module while
file descriptors are open. Fix this oversight.

Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rfkill/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1180,6 +1180,7 @@ static long rfkill_fop_ioctl(struct file
 #endif
 
 static const struct file_operations rfkill_fops = {
+	.owner		= THIS_MODULE,
 	.open		= rfkill_fop_open,
 	.read		= rfkill_fop_read,
 	.write		= rfkill_fop_write,


