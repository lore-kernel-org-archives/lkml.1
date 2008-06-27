Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbYF0NUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbYF0NUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYF0NUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:20:39 -0400
Received: from verein.lst.de ([213.95.11.210]:53839 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYF0NUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:20:39 -0400
Date: Fri, 27 Jun 2008 15:20:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: xfs-masters@oss.sgi.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: linux-next: Tree for June 24 (XFS x2)
Message-ID: <20080627132013.GA23854@lst.de>
References: <20080624175612.cdf29651.sfr@canb.auug.org.au> <20080624171809.42bbdf68.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624171809.42bbdf68.randy.dunlap@oracle.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 05:18:09PM -0700, Randy Dunlap wrote:
> XFS shows 2 build problems today.
> 
> 1. xfs_stats.h problem
> 
>   CC      fs/xfs/xfs_rtalloc.o
> In file included from /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_linux.h:91,
>                  from /local/linsrc/linux-next-20080624/fs/xfs/xfs.h:44,
>                  from /local/linsrc/linux-next-20080624/fs/xfs/xfs_rtalloc.c:18:
> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_stats.h: In function 'xfs_init_procfs':
> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_stats.h:150: error: expected ';' before '}' token
> make[3]: *** [fs/xfs/xfs_rtalloc.o] Error 1

This should fix the problem, although I can't find a way to drop
CONFIG_PROC_FS from my test config to actually verify it:


Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.h	2008-06-27 15:16:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h	2008-06-27 15:19:18.000000000 +0200
@@ -146,11 +146,12 @@ extern void xfs_cleanup_procfs(void);
 
 static inline int xfs_init_procfs(void)
 {
-	return 0
-};
+	return 0;
+}
+
 static inline void xfs_cleanup_procfs(void)
 {
-};
+}
 
 #endif	/* !CONFIG_PROC_FS */
 
