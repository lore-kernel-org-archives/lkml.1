Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbZLGAg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbZLGAg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbZLGAM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:28 -0500
Received: from kroah.org ([198.145.64.141]:34154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075AbZLGAM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:26 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:41 2009
Message-Id: <20091207000641.261029358@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Suresh Jayaraman <sjayaraman@suse.de>, Jeff Layton <jlayton@redhat.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [004/119] cifs: clear server inode number flag while autodisabling
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=cifs-clear-server-inode-number-flag-while-autodisabling.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Suresh Jayaraman <sjayaraman@suse.de>

commit f534dc994397560343be4a3223b9bbaa8e739e1f upstream.

Fix the commit ec06aedd44 that intended to turn off querying for server inode
numbers when server doesn't consistently support inode numbers. Presumably
the commit didn't actually clear the CIFS_MOUNT_SERVER_INUM flag, perhaps a
typo.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -710,7 +710,7 @@ void
 cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
-		cifs_sb->mnt_cifs_flags &= CIFS_MOUNT_SERVER_INUM;
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
 		cERROR(1, ("Autodisabling the use of server inode numbers on "
 			   "%s. This server doesn't seem to support them "
 			   "properly. Hardlinks will not be recognized on this "


