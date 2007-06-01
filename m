Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbXFATlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbXFATlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762208AbXFATln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:41:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60449 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762143AbXFATlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:41:42 -0400
Subject: Re: [1/3] 2.6.22-rc3: known regressions with patches v2
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Chinner <dgc@sgi.com>, jffs-dev@axis.com,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Uwe Bugla <uwe.bugla@gmx.de>, viro@zeniv.linux.org.uk,
       Ken Chen <kenchen@google.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       Qi Yong <qiyong@fc-cn.com>, Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <46600F44.3030109@googlemail.com>
References: <46600F44.3030109@googlemail.com>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 20:41:22 +0100
Message-Id: <1180726882.25232.52.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 14:21 +0200, Michal Piotrowski wrote:
> File systems
> 
> Subject    : JFFS2 issues
> References :
> http://lists.infradead.org/pipermail/linux-mtd/2007-May/018426.html
> Submitter  : Haavard Skinnemoen <hskinnemoen@atmel.com>
> Caused-By  : commit 10731f83009e2556f98ffa5c7c2cbffe66dacfb3
>              Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Handled-By : Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Patch      :
> http://lists.infradead.org/pipermail/linux-mtd/2007-May/018453.html
> Status     : patch available

Linus, please pull from git://git.infradead.org/mtd-2.6.git

It contains the fix for the above regression, along with a small number
of other bug fixes -- specifically for XATTR-related oopses, and broken
handling of setattr() in JFFS2. There's actually a couple of things
which aren't strictly bug fixes too, but those are very minor. If you
insist, I could redo the history to omit them, but it's probably cleaner
not to.

Artem Bityutskiy (1):
      [JFFS2] Fix buffer length calculations in jffs2_get_inode_nodes()

David Howells (1):
      [MTD] generalise the handling of MTD-specific superblocks

David Woodhouse (4):
      [JFFS2] Fix BUG() caused by failing to discard xattrs on deleted files.
      [JFFS2] Fix potential memory leak of dead xattrs on unmount.
      [MTD] Fix error checking after get_mtd_device() in get_sb_mtd functions
      [JFFS2] Fix obsoletion of metadata nodes in jffs2_add_tn_to_tree()

Mike Frysinger (1):
      [MTD] [MAPS] don't force uclinux mtd map to be root dev

 drivers/mtd/Makefile       |    3 +-
 drivers/mtd/maps/uclinux.c |    5 -
 drivers/mtd/mtdsuper.c     |  232 ++++++++++++++++++++++++++++++++++++++++++++
 fs/jffs2/readinode.c       |   22 +++-
 fs/jffs2/super.c           |  194 ++++---------------------------------
 fs/jffs2/xattr.c           |    6 +-
 include/linux/fs.h         |    1 +
 include/linux/mtd/super.h  |   30 ++++++
 8 files changed, 304 insertions(+), 189 deletions(-)



-- 
dwmw2

