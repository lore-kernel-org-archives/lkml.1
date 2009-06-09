Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZFIBI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZFIBI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZFIBIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:08:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33063 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZFIBIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:08:16 -0400
Date: Tue, 9 Jun 2009 11:08:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Mike Frysinger <vapier@gentoo.org>
Subject: linux-next: manual merge of the vfs tree with the  tree
Message-Id: <20090609110815.0abd1de0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
include/linux/magic.h between commit
81ebac1be35a2c2fe1f4d3810a8e57d315600a32 ("CUSE: implement CUSE -
Character device in Userspace") from the fuse tree and commit
5b88aed76b5a1470ec9705c03cf3f0480c018513 ("linux/magic.h: move cramfs
magic out of cramfs_fs.h") from the vfs tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/magic.h
index 4596c9e,192f980..0000000
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@@ -3,11 -3,12 +3,13 @@@
  
  #define ADFS_SUPER_MAGIC	0xadf5
  #define AFFS_SUPER_MAGIC	0xadff
 -#define AFS_SUPER_MAGIC                0x5346414F
 +#define AFS_SUPER_MAGIC		0x5346414F
  #define AUTOFS_SUPER_MAGIC	0x0187
  #define CODA_SUPER_MAGIC	0x73757245
+ #define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
+ #define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
 -#define DEBUGFS_MAGIC          0x64626720
 +#define CUSE_SUPER_MAGIC	0x43555345
 +#define DEBUGFS_MAGIC		0x64626720
  #define SYSFS_MAGIC		0x62656572
  #define SECURITYFS_MAGIC	0x73636673
  #define TMPFS_MAGIC		0x01021994
