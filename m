Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbXIRLZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbXIRLZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 07:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXIRLY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 07:24:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43914 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753567AbXIRLY5 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:24:57 -0400
Date: Tue, 18 Sep 2007 21:24:47 +1000
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.23
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070918112447.4315C58C4C09@chook.melbourne.sgi.com>
From: tes@sgi.com (Tim Shimmin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A couple of fixes for potential fs corruption.
And one fix to ensure that xfs_mru_cache is not
doing anything unless the cache has active objects.


Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_aops.c  |    1 +
 fs/xfs/linux-2.6/xfs_super.c |    4 ++-
 fs/xfs/xfs_buf_item.h        |    5 +++
 fs/xfs/xfs_filestream.c      |    3 +-
 fs/xfs/xfs_log_recover.c     |   51 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_mru_cache.c       |   72 ++++++++++++++++-------------------------
 fs/xfs/xfs_mru_cache.h       |    6 +--
 fs/xfs/xfs_trans_buf.c       |    1 +
 fs/xfs/xfs_vnodeops.c        |   20 +++++++-----
 9 files changed, 101 insertions(+), 62 deletions(-)

through these commits:

commit b394e43e995d08821588a22561c6a71a63b4ff27
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Sep 14 15:23:04 2007 +1000

    [XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer.
    
    SGI-PV: 969656
    SGI-Modid: xfs-linux-melb:xfs-kern:29676a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 776a75fa5cfb8f3602d3ca9d221dc34497133f4b
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Sep 14 15:22:50 2007 +1000

    [XFS] Ensure file size updates have been completed before writing inode to disk.
    
    SGI-PV: 968767
    SGI-Modid: xfs-linux-melb:xfs-kern:29675a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 65de5567564e70edd01b6d4e95e548d7ba284872
Author: David Chinner <dgc@sgi.com>
Date:   Thu Aug 16 15:21:11 2007 +1000

    [XFS] On-demand reaping of the MRU cache
    
    Instead of running the mru cache reaper all the time based on a timeout,
    we should only run it when the cache has active objects. This allows CPUs
    to sleep when there is no activity rather than be woken repeatedly just to
    check if there is anything to do.
    
    SGI-PV: 968554
    SGI-Modid: xfs-linux-melb:xfs-kern:29305a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

--Tim
