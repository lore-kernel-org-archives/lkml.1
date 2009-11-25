Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZKYDGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZKYDGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbZKYDGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:06:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51632 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257AbZKYDGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:06:24 -0500
Date: Wed, 25 Nov 2009 14:06:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@us.ibm.com>, Jeff Layton <jlayton@redhat.com>
Subject: linux-next: manual merge of the ext3 tree with the cifs tree
Message-Id: <20091125140626.2b71fb0a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Today's linux-next merge of the ext3 tree got a conflict in fs/cifs/dir.c
between commit cea62343956c24452700c06cf028b72414c58a74 ("[CIFS]
Duplicate data on appending to some Samba servers") from the cifs tree
and commit 618903228b94b67a1d04634a83ea9cdb99c09e37 ("vfs: Implement
proper O_SYNC semantics") from the ext3 tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/cifs/dir.c
index 1f42f77,f1fe5cb..0000000
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@@ -214,7 -214,10 +214,8 @@@ int cifs_posix_open(char *full_path, st
  		posix_flags |= SMB_O_EXCL;
  	if (oflags & O_TRUNC)
  		posix_flags |= SMB_O_TRUNC;
- 	if (oflags & O_SYNC)
 -	if (oflags & O_APPEND)
 -		posix_flags |= SMB_O_APPEND;
+ 	/* be safe and imply O_SYNC for O_DSYNC */
+ 	if (oflags & O_DSYNC)
  		posix_flags |= SMB_O_SYNC;
  	if (oflags & O_DIRECTORY)
  		posix_flags |= SMB_O_DIRECTORY;
