Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab0BDReT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:34:19 -0500
Received: from kroah.org ([198.145.64.141]:34664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099Ab0BDRVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:44 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:00 2010
Message-Id: <20100204171500.492987815@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [21/74] Fix a leak in affs_fill_super()
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit afc70ed05a07bfe171f7a5b8fdc80bdb073d314f upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/affs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -316,6 +316,8 @@ static int affs_fill_super(struct super_
 				&blocksize,&sbi->s_prefix,
 				sbi->s_volume, &mount_flags)) {
 		printk(KERN_ERR "AFFS: Error parsing options\n");
+		kfree(sbi->s_prefix);
+		kfree(sbi);
 		return -EINVAL;
 	}
 	/* N.B. after this point s_prefix must be released */


