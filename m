Return-Path: <linux-kernel-owner+w=401wt.eu-S934662AbZIEA0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934662AbZIEA0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964903AbZIEA0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:26:14 -0400
Received: from kroah.org ([198.145.64.141]:42280 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934668AbZIEAVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:55 2009
Message-Id: <20090905001455.686767014@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>
Subject: [patch 54/71] xfs: fix spin_is_locked assert on uni-processor builds
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=xfs-fix-spin_is_locked-assert-on-uni-processor-builds.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Hellwig <hch@infradead.org>

upstream commit a8914f3a6d72c97328597a556a99daaf5cc288ae

Without SMP or preemption spin_is_locked always returns false,
so we can't do an assert with it.  Instead use assert_spin_locked,
which does the right thing on all builds.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reported-by: Johannes Engel <jcnengel@googlemail.com>
Tested-by: Johannes Engel <jcnengel@googlemail.com>
Signed-off-by: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3180,7 +3180,7 @@ try_again:
 STATIC void
 xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
 {
-	ASSERT(spin_is_locked(&log->l_icloglock));
+	assert_spin_locked(&log->l_icloglock);
 
 	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		xlog_state_switch_iclogs(log, iclog, 0);


