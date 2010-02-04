Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab0BDRdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:33:49 -0500
Received: from kroah.org ([198.145.64.141]:34677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab0BDRVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:47 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:02 2010
Message-Id: <20100204171502.144174986@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [24/74] fix leak in romfs_fill_super()
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7e32b7bb734047c5e3cecf2e896b9cf8fc35d1e8 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/romfs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -544,6 +544,7 @@ error:
 error_rsb_inval:
 	ret = -EINVAL;
 error_rsb:
+	kfree(rsb);
 	return ret;
 }
 


