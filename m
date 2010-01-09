Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707Ab0AIBGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab0AIBGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 20:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049Ab0AIBGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 20:06:49 -0500
Received: from mx2.netapp.com ([216.240.18.37]:24768 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0AIBGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 20:06:48 -0500
X-IronPort-AV: E=Sophos;i="4.49,245,1262592000"; 
   d="scan'208";a="299364794"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [RFC PATCH 0/2] Fix up the NFS mmap code
To: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Date: Fri, 08 Jan 2010 19:56:24 -0500
Message-ID: <20100109005624.7473.33215.stgit@localhost.localdomain>
In-Reply-To: <1262913974.2659.101.camel@localhost>
References: <1262913974.2659.101.camel@localhost>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 09 Jan 2010 01:06:30.0222 (UTC) FILETIME=[FA178EE0:01CA90C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about something like the following. I chose to wrap the call to
do_mmap_pgoff() instead of making a special ->pre_mmap(), since that
seems more consistent with the way we handle ->read() and ->write().

I also left sys_uselib() and do_execve() to rely on revalidate at
open(), since executables and libraries really are not ever expected to
change while open.

Cheers
  Trond

---

Trond Myklebust (2):
      NFS: Fix a potential deadlock in nfs_file_mmap()
      VFS: Add a mmap_file() callback to struct file_operations


 fs/nfs/file.c      |   28 ++++++++++++++++++++++------
 fs/nfs/inode.c     |    4 ++++
 include/linux/fs.h |    5 +++++
 mm/filemap.c       |   23 +++++++++++++++++++++++
 mm/mmap.c          |   11 ++++++++---
 mm/nommu.c         |   11 ++++++++---
 6 files changed, 70 insertions(+), 12 deletions(-)

-- 
Signature
