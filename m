Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0BSRB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:29 -0500
Received: from kroah.org ([198.145.64.141]:57709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab0BSRA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:59 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:49 2010
Message-Id: <20100219163248.766868152@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [66/93] befs: fix leak
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 8dd5ca532c2d2c2b85f16bc038ebfff05b8853e1 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/befs/linuxvfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -873,6 +873,7 @@ befs_fill_super(struct super_block *sb,
 	brelse(bh);
 
       unacquire_priv_sbp:
+	kfree(befs_sb->mount_opts.iocharset);
 	kfree(sb->s_fs_info);
 
       unacquire_none:


