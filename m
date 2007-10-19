Return-Path: <linux-kernel-owner+w=401wt.eu-S965826AbXJSIae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826AbXJSIae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 04:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbXJSIa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 04:30:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42401 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755021AbXJSIaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 04:30:25 -0400
Date: Fri, 19 Oct 2007 18:30:19 +1000
To: torvalds@linux-foundation.org
Cc: tes@sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.24-rc1
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071019083019.6F53058C38F1@chook.melbourne.sgi.com>
From: tes@sgi.com (Tim Shimmin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A couple of Christoph patches for XFS ...
A fid one for nfs exports which akpm is waiting for.
Thanks.

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_export.c |    6 +++---
 fs/xfs/linux-2.6/xfs_export.h |    6 +++---
 fs/xfs/linux-2.6/xfs_ioctl.c  |   24 ++++++++++++------------
 fs/xfs/xfs_dmops.c            |   21 ++++-----------------
 fs/xfs/xfs_fs.h               |   29 ++++++-----------------------
 fs/xfs/xfs_qmops.c            |   22 +++++++---------------
 fs/xfs/xfs_vfsops.c           |    9 ++++-----
 fs/xfs/xfs_vfsops.h           |    4 ++--
 fs/xfs/xfs_vnodeops.c         |   13 ++-----------
 fs/xfs/xfs_vnodeops.h         |    2 +-
 10 files changed, 44 insertions(+), 92 deletions(-)

through these commits:

commit c6143911a7e0f8abef0319c801eb36718f57dfde
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Sep 14 15:22:37 2007 +1000

    [XFS] cleanup fid types mess
    
    Currently XFs has three different fid types: struct fid, struct xfs_fid
    and struct xfs_fid2 with hte latter two beeing identicaly and the first
    one beeing the same size but an unstructured array with the same size.
    
    This patch consolidates all this to alway uuse struct xfs_fid.
    
    This patch is required for an upcoming patch series from me that revamps
    the nfs exporting code and introduces a Linux-wide struct fid.
    
    SGI-PV: 970336
    SGI-Modid: xfs-linux-melb:xfs-kern:29651a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit c8fcfac5a257f8a04f7ba3d397dedccffef19be2
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Oct 19 16:57:01 2007 +1000

    [XFS] fixups after behavior removal merge into mainline git
    
    Fixup for lack of dmapi support and no quota module support.
    
    SGI-PV: 969985
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
