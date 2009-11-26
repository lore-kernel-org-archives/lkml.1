Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbZKZDWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbZKZDWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932271AbZKZDV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:21:58 -0500
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:48237
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758323AbZKZDV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:21:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAJ6DDUt8qYZ9/2dsb2JhbACER78VkGCBL4IuVQSBcoEV
X-IronPort-AV: E=Sophos;i="4.47,290,1257091200"; 
   d="scan'208";a="605406280"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 0/3] autofs - series to replace autofs with autofs4
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 26 Nov 2009 11:21:47 +0800
Message-ID: <20091126030623.5691.33759.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to planned changes to locking for the path walking the autofs
module could easily deadlock during mount request callback. Since
the autofs4 module provides the needed support and a patch series
to overcome the locking change has been done, rather than attempt
to fix autofs I propose that the autofs module be replaced by the
autofs4 module.

To try and give people some warning before actually removing the
autofs4 directory I've left that in place, updated the Kconfig
help text to warn of the impending removal, and provided a make
that builds into the autofs4 directory from the updated autofs
directory source. The net result is that fs/autofs/autofs.ko and
fs/autofs4/autofs4.ko will be built from the same source.

Also, the defconfig configurations have not yet been changed but
that can be done upon actual removal.

Comments on this appraoch and the patch series are welcome.

---

Ian Kent (3):
      autofs - use consistent function naming
      autofs - rename autofs4 module to autofs
      autofs4 - coding style fixes


 fs/autofs/Kconfig      |   12 
 fs/autofs/Makefile     |    2 
 fs/autofs/autofs_i.h   |  317 +++++++++---
 fs/autofs/dev-ioctl.c  |  766 +++++++++++++++++++++++++++++
 fs/autofs/dirhash.c    |  250 ---------
 fs/autofs/expire.c     |  531 ++++++++++++++++++++
 fs/autofs/init.c       |   30 -
 fs/autofs/inode.c      |  406 +++++++++++----
 fs/autofs/root.c       | 1268 ++++++++++++++++++++++++++++++++++--------------
 fs/autofs/symlink.c    |   10 
 fs/autofs/waitq.c      |  474 +++++++++++++++---
 fs/autofs4/Kconfig     |   10 
 fs/autofs4/Makefile    |   10 
 fs/autofs4/autofs_i.h  |  304 ------------
 fs/autofs4/dev-ioctl.c |  765 -----------------------------
 fs/autofs4/expire.c    |  530 --------------------
 fs/autofs4/init.c      |   51 --
 fs/autofs4/inode.c     |  473 ------------------
 fs/autofs4/root.c      | 1109 ------------------------------------------
 fs/autofs4/symlink.c   |   25 -
 fs/autofs4/waitq.c     |  524 --------------------
 21 files changed, 3157 insertions(+), 4710 deletions(-)
 create mode 100644 fs/autofs/dev-ioctl.c
 delete mode 100644 fs/autofs/dirhash.c
 create mode 100644 fs/autofs/expire.c
 delete mode 100644 fs/autofs4/autofs_i.h
 delete mode 100644 fs/autofs4/dev-ioctl.c
 delete mode 100644 fs/autofs4/expire.c
 delete mode 100644 fs/autofs4/init.c
 delete mode 100644 fs/autofs4/inode.c
 delete mode 100644 fs/autofs4/root.c
 delete mode 100644 fs/autofs4/symlink.c
 delete mode 100644 fs/autofs4/waitq.c

-- 
Ian
