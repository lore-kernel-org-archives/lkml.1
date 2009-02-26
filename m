Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZBZPJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZBZPJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZBZPJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:09:13 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:44296 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZBZPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:09:12 -0500
Subject: [GIT PULL] Btrfs updates for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: torvalds@transmeta.com, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 10:09:00 -0500
Message-Id: <1235660940.4631.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49A6B091.0268:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

We've had good results in testing Josef's initial enospc support for
btrfs.  This mainly deals with better accounting of the data extents
that have been allocated for delalloc, and properly returning enospc for
new data writes that can't possibly succeed.

There is some metadata enospc support as well, but there is more work to
be done in that area.  Because this code changes the time at which some
deep call chains are done, it also cuts down on the btrfs stack usage.

Linus, if you pull the master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

You'll find:

Josef Bacik (2):
      Btrfs: add better -ENOSPC handling
      Btrfs: try committing transaction before returning ENOSPC


 b/fs/btrfs/btrfs_inode.h |    8 +
 b/fs/btrfs/ctree.h       |   40 ++++++--
 b/fs/btrfs/extent-tree.c |   57 ++++++++++--
 b/fs/btrfs/file.c        |   16 ++-
 b/fs/btrfs/inode.c       |   62 +++----------
 b/fs/btrfs/ioctl.c       |    6 -
 fs/btrfs/extent-tree.c   |  215
+++++++++++++++++++++++++++++++++++++++++++----
 7 files changed, 318 insertions(+), 86 deletions(-)


