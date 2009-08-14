Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZHNMmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZHNMmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZHNMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:42:46 -0400
Received: from www.tglx.de ([62.245.132.106]:49707 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668AbZHNMmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:42:45 -0400
Message-Id: <20090814122657.114987508@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:42:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 00/11] Cleanup unload_nls() calls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking through the BKL call sites in fs/* I noticed that most
callsites of unload_nls() do 

	  if (nls) 
	     	   unload_nls(nls);

The patch series moves the NULL pointer check into unload_nls() and
cleans up the various users.

Thanks,

	tglx
---
befs/linuxvfs.c |    7 +------
cifs/cifsfs.c   |    3 +--
fat/inode.c     |   16 ++++------------
hfs/mdb.c       |    6 ++----
hfsplus/super.c |    6 ++----
isofs/inode.c   |    8 ++------
jfs/super.c     |    9 +++------
ncpfs/inode.c   |   12 ++----------
ncpfs/ioctl.c   |    6 ++----
nls/nls_base.c  |    3 ++-
ntfs/super.c    |   10 ++++------
smbfs/inode.c   |   10 ++--------
12 files changed, 27 insertions(+), 69 deletions(-)
             


