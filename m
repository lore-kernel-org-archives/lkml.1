Return-Path: <linux-kernel-owner+w=401wt.eu-S965570AbXBFWMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbXBFWMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965577AbXBFWMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:12:52 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39723 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965570AbXBFWMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:12:44 -0500
Date: Tue, 6 Feb 2007 23:12:49 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, swhiteho@redhat.com
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: [-mm patch] make gfs2_writepages() static
Message-ID: <20070206221249.GJ27397@stusta.de>
References: <20070129204528.eb8d695e.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 08:45:28PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm2:
>...
>  git-gfs2-nmw.patch
>...
>  git trees
>...


This patch makes the needlessly global gfs2_writepages() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-rc6-mm3/fs/gfs2/ops_address.c.old	2007-02-06 08:30:19.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/gfs2/ops_address.c	2007-02-06 08:30:32.000000000 +0100
@@ -170,7 +170,8 @@
  * and write whole extents at once. This is a big reduction in the
  * number of I/O requests we send and the bmap calls we make in this case.
  */
-int gfs2_writepages(struct address_space *mapping, struct writeback_control *wbc)
+static int gfs2_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);

