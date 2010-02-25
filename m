Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab0BYWsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:48:12 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:34366 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934287Ab0BYWsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:48:09 -0500
Date: Thu, 25 Feb 2010 14:41:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH -next] staging/pohmelfs: fix write_inode parameter warning
Message-Id: <20100225144122.d9ba8810.randy.dunlap@oracle.com>
In-Reply-To: <20100225183523.80361261.sfr@canb.auug.org.au>
References: <20100225183523.80361261.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B86FCEF.013E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

sparse warns that:
drivers/staging/pohmelfs/inode.c:1797: warning: initialization from incompatible pointer type

so fix pohmelfs_write_inode() to have the expected parameters.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/pohmelfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20100225.orig/drivers/staging/pohmelfs/inode.c
+++ linux-next-20100225/drivers/staging/pohmelfs/inode.c
@@ -396,7 +396,8 @@ int pohmelfs_remove_child(struct pohmelf
 /*
  * Writeback for given inode.
  */
-static int pohmelfs_write_inode(struct inode *inode, int sync)
+static int pohmelfs_write_inode(struct inode *inode,
+				struct writeback_control *wbc)
 {
 	struct pohmelfs_inode *pi = POHMELFS_I(inode);
 
