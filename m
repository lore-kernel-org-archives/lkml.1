Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYGaA3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYGaA3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762756AbYGaA0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:26:15 -0400
Received: from ns.suse.de ([195.135.220.2]:39801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760020AbYGaA0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:26:12 -0400
Date: Wed, 30 Jul 2008 17:00:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alex Nixon <Alex.Nixon@citrix.com>,
       Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 58/62] VFS: increase pseudo-filesystem block size to
	PAGE_SIZE
Message-ID: <20080731000001.GF12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vfs-increase-pseudo-filesystem-block-size-to-page_size.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Alex Nixon <alex.nixon@citrix.com>

commit 3971e1a917548977cff71418a7c3575ffbc9571f upstream

This commit:

    commit ba52de123d454b57369f291348266d86f4b35070
    Author: Theodore Ts'o <tytso@mit.edu>
    Date:   Wed Sep 27 01:50:49 2006 -0700

        [PATCH] inode-diet: Eliminate i_blksize from the inode structure

caused the block size used by pseudo-filesystems to decrease from
PAGE_SIZE to 1024 leading to a doubling of the number of context switches
during a kernbench run.

Signed-off-by: Alex Nixon <Alex.Nixon@citrix.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/libfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -216,8 +216,8 @@ int get_sb_pseudo(struct file_system_typ
 
 	s->s_flags = MS_NOUSER;
 	s->s_maxbytes = ~0ULL;
-	s->s_blocksize = 1024;
-	s->s_blocksize_bits = 10;
+	s->s_blocksize = PAGE_SIZE;
+	s->s_blocksize_bits = PAGE_SHIFT;
 	s->s_magic = magic;
 	s->s_op = ops ? ops : &simple_super_operations;
 	s->s_time_gran = 1;

-- 
