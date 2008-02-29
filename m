Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYB2DuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYB2DuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 22:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYB2DuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 22:50:07 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36830 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751581AbYB2DuG (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 22:50:06 -0500
Date: Fri, 29 Feb 2008 14:50:00 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.25-rc4
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080229035000.7B24058C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_super.c |   14 +++++++-------
 fs/xfs/xfs_clnt.h            |    2 +-
 fs/xfs/xfs_ialloc.c          |    2 +-
 fs/xfs/xfs_mount.h           |    2 +-
 fs/xfs/xfs_vfsops.c          |    4 ++--
 5 files changed, 12 insertions(+), 12 deletions(-)

through these commits:

commit b7405bb65a83e819dd3b21a6d9636c279d9ce79a
Author: Niv Sardi <xaiki@sgi.com>
Date:   Fri Feb 29 13:58:40 2008 +1100

    [XFS] If you mount an XFS filesystem with no mount options at all, then
    the "ikeep" option is set rather than "noikeep".
    
    This regression was introduced in 970451.
    
    With no mount options specified, xfs_parseargs() does the following:
    
    int ikeep = 0;
    
    args->flags |= XFSMNT_BARRIER;
    
    args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
    
    if (!options)
    
    goto done;
    
    It only sets the above two options by default and before, it also used to
    set XFSMNT_IDELETE by default.
    
    If options are specified, then
    
    if (!(args->flags & XFSMNT_DMAPI) && !ikeep)
    
    args->flags |= XFSMNT_IDELETE;
    
    is executed later on which is skipped by the "goto done;" above.
    
    The solution is to invert the logic.
    
    SGI-PV: 977771
    SGI-Modid: xfs-linux-melb:xfs-kern:30590a
    
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
