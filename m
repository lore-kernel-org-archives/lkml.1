Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbZF2WGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbZF2WGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZF2WGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:06:48 -0400
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:37699 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZF2WGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:06:47 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 18:06:47 EDT
From: Wolfgang Illmeyer <wolfgang@illmeyer.com>
To: akpm@linux-foundation.org
Subject: [PATCH 001/001] hostfs: set maximum filesize in superblock for proper LFS support
Date: Mon, 29 Jun 2009 23:59:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29.1; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, jdike@addtoit.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906292359.01834.wolfgang@illmeyer.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Df-Sender: wolfgang@illmeyer.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Illmeyer <wolfgang@illmeyer.com>

Maximum file size for hostfs mounts defaults to 2GB, so bigger files cannot be 
read/written through hostfs. This patch initializes the maximum file size to 
MAX_LFS_SIZE.
Signed-off-by: Wolfgang Illmeyer <wolfgang@illmeyer.com>
---
This patch applies against linux-2.6.30. It fixes 
http://bugzilla.kernel.org/show_bug.cgi?id=13531
It is a revamped version of the patch I attached to the bug, using additional 
input from Andrew Morton (thanks). This is my first patch for the kernel, I 
hope I didn't break too many rules ;)

For any feedback from the mailing list please add me to "To" or CC me - I'm 
not on the list.

--- fs/hostfs/hostfs_kern.c.orig   2009-06-29 23:13:05.000000000 +0200
+++ fs/hostfs/hostfs_kern.c        2009-06-29 23:14:43.000000000 +0200
@@ -972,6 +972,7 @@ static int hostfs_fill_sb_common(struct
        sb->s_blocksize_bits = 10;
        sb->s_magic = HOSTFS_SUPER_MAGIC;
        sb->s_op = &hostfs_sbops;
+       sb->s_maxbytes = MAX_LFS_FILESIZE;

        /* NULL is printed as <NULL> by sprintf: avoid that. */
        if (req_root == NULL)

