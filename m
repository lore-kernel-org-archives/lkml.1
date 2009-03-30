Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZC3Ni6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZC3Ni6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZC3Nit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:38:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43511 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZC3Nis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:38:48 -0400
To: torvalds@linux-foundation.org
Subject: [RESEND: git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20090330133843.50AB94CB418@norville.austin.ibm.com>
Date: Mon, 30 Mar 2009 08:38:43 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/Kconfig        |    1 +
 fs/jfs/jfs_extent.c   |   63 +++++-------
 fs/jfs/jfs_imap.c     |   10 +--
 fs/jfs/jfs_metapage.c |   18 +++-
 fs/jfs/jfs_types.h    |   29 ------
 fs/jfs/jfs_xtree.c    |  263 +------------------------------------------------
 fs/jfs/jfs_xtree.h    |    2 -
 fs/jfs/super.c        |    4 +
 8 files changed, 46 insertions(+), 344 deletions(-)

through these ChangeSets:

commit c68a65da35906b32505bbb8eecab316e6736e28b
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Mon Feb 2 11:20:55 2009 -0800

    jfs: needs crc32_le
    
    JFS needs crc32_le(), so select its library config symbol:
    
    fs/built-in.o: In function `jfs_statfs':
    super.c:(.text+0x7c8c0): undefined reference to `crc32_le'
    super.c:(.text+0x7c8d5): undefined reference to `crc32_le'
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit 8db0c5d5ef3ab99fe9e5151872b75f45c4282e3c
Merge: 1ad53a9 45c82b5
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Mon Feb 2 13:40:55 2009 -0600

    Merge branch 'master' of /home/shaggy/git/linus-clean/

commit 1ad53a98c927a9b5b1b57288ac0edec562fbcf8d
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Fri Jan 30 14:09:06 2009 -0600

    jfs: Fix error handling in metapage_writepage()
    
    Improved error handling so that last_write_complete(), and thus
    end_page_writeback(), gets called only once.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Reported-by: Eric Sesterhenn <snakebyte@gmx.de>

commit b5c816a4f177604ae708892bba074b1d534fcbee
Author: Coly Li <coly.li@suse.de>
Date:   Wed Jan 21 00:05:39 2009 +0800

    jfs: return f_fsid for statfs(2)
    
    This patch makes jfs return f_fsid info for statfs(2). By Andreas'
    suggestion, this patch populates a persistent f_fsid between boots/mounts
    with help of on-disk uuid record.
    
    Signed-off-by: Coly Li <coly.li@suse.de>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit fec1878fe952b994125a3be7c94b1322db586f3b
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Fri Jan 9 15:42:04 2009 -0600

    jfs: remove xtLookupList()
    
    xtLookupList() was a more generalized version of xtLookup() with a
    nastier interface.  Its only caller, extHint(), is actually better
    suited to using xtLookup() than xtLookupList().  This also lets us
    remove the definition of lxd_t, an obnoxious packed structure that was
    only used in-memory.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit da9c138e9e1cc08aa3a4e8c09411a5d08f866445
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Fri Jan 9 10:53:35 2009 -0600

    jfs: clean up a dangling comment
    
    viro cleaned up an hlist hack, but left a comment where it no longer
    belongs.  Combine the old comment with his new one.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
