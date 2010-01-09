Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493Ab0AIT0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0AIT0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 14:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189Ab0AIT0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 14:26:34 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37452 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0AIT0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 14:26:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UZBfWm3WBfY3WwWJCK79yQcYonz0Hjn/8Pq2v5YQWwwp/McMWeuYkir8t6c76UAl3K
         uGtizAWilvMA8ZiRCJ/XpjQ+yv6QLkTTBj+8U9lzQyUbEy6ZyehpUYSDi5IC+9OAB2eF
         MnqxBep8R0mkkX4sqI+ZzLpHUuuLwkNUoSonA=
Message-ID: <4B48D95D.5000106@gmail.com>
Date: Sat, 09 Jan 2010 20:30:37 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cifs: remove redundant test in cifs_lookup() and cifs_do_rename()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rc != -EOPNOTSUPP is true as well if rc is -EINVAL.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/cifs/dir.c   |    2 +-
 fs/cifs/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Or maybe there is ==/!= or &&/|| confusion?

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6ccf726..f5cfdd6 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -690,7 +690,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			 */
 			if ((rc == 0) || (rc == -ENOENT))
 				posix_open = true;
-			else if ((rc == -EINVAL) || (rc != -EOPNOTSUPP))
+			else if (rc != -EOPNOTSUPP)
 				pTcon->broken_posix_open = true;
 		}
 		if (!posix_open)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cf18ee7..aec2928 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1264,7 +1264,7 @@ cifs_do_rename(int xid, struct dentry *from_dentry, const char *fromPath,
 	 * source Note that cross directory moves do not work with
 	 * rename by filehandle to various Windows servers.
 	 */
-	if (rc == 0 || rc != -ETXTBSY)
+	if (rc != -ETXTBSY)
 		return rc;
 
 	/* open the file to be renamed -- we need DELETE perms */
