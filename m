Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbYCFGNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbYCFGNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYCFGNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:13:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54757 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752804AbYCFGNO (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:13:14 -0500
Date: Thu, 06 Mar 2008 17:13:07 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.25-rc5
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080306061308.0808658C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/xfs_iget.c      |    1 +
 fs/xfs/xfs_trans_ail.c |   17 ++++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

through these commits:

commit 72772a3b5b158cddcfbbff3ef13b26b03a905158
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:49:43 2008 +1100

    [XFS] fix inode leak in xfs_iget_core()
    
    If the radix_tree_preload() fails, we need to destroy the inode we just
    read in before trying again. This could leak xfs_vnode structures when
    there is memory pressure. Noticed by Christoph Hellwig.
    
    SGI-PV: 977823
    SGI-Modid: xfs-linux-melb:xfs-kern:30606a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>

commit 92d9cd1059f80b9c89dee191ffb88b0872e6a7ae
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:45:10 2008 +1100

    [XFS] 977545 977545 977545 977545 977545 977545 xfsaild causing too many
    wakeups
    
    Idle state is not being detected properly by the xfsaild push code. The
    current idle state is detected by an empty list which may never happen
    with mostly idle filesystem or one using lazy superblock counters. A
    single dirty item in the list that exists beyond the push target can
    result repeated looping attempting to push up to the target because it
    fails to check if the push target has been acheived or not.
    
    Fix by considering a dirty list with everything past the target as an idle
    state and set the timeout appropriately.
    
    SGI-PV: 977545
    SGI-Modid: xfs-linux-melb:xfs-kern:30532a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
