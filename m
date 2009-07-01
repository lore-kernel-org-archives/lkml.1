Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbZGAA5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbZGAA5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761409AbZGAAeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:44 -0400
Received: from kroah.org ([198.145.64.141]:60309 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761436AbZGAAem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:25 2009
Message-Id: <20090701002425.282771625@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: [patch 039/108] jfs: fix regression preventing coalescing of extents
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=jfs-fix-regression-preventing-coalescing-of-extents.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit f7c52fd17a7dda42fc9e88c2b2678403419bfe63 upstream.

Commit fec1878fe952b994125a3be7c94b1322db586f3b caused a regression in
which contiguous blocks being allocated to the end of an extent were
getting a new extent created.  This typically results in files entirely
made up of 1-block extents even though the blocks are contiguous on
disk.

Apparently grub doesn't handle a jfs file being fragmented into too many
extents, since it refuses to boot a kernel from jfs that was created by
the 2.6.30 kernel.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Reported-by: Alex <alevkovich@tut.by>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jfs/jfs_extent.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -391,6 +391,7 @@ int extHint(struct inode *ip, s64 offset
 		}
 		XADaddress(xp, xaddr);
 		XADlength(xp, xlen);
+		XADoffset(xp, prev);
 		/*
 		 * only preserve the abnr flag within the xad flags
 		 * of the returned hint.


