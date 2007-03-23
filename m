Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbXCWArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbXCWArT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934252AbXCWArS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:47:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934249AbXCWArK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:47:10 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 11:47:04 +1100
Message-Id: <1070323004704.28989@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 004 of 4] knfsd: nfsd4: remove superfluous cancel_delayed_work() call
References: <20070323114512.28822.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>

This cancel_delayed_work call is called from a function that is only
called from a piece of code that immediate follows a cancel and
destruction of the workqueue, so it's clearly a mistake.

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4state.c |    1 -
 1 file changed, 1 deletion(-)

diff .prev/fs/nfsd/nfs4state.c ./fs/nfsd/nfs4state.c
--- .prev/fs/nfsd/nfs4state.c	2007-03-23 11:19:14.000000000 +1100
+++ ./fs/nfsd/nfs4state.c	2007-03-23 11:19:34.000000000 +1100
@@ -3260,7 +3260,6 @@ __nfs4_state_shutdown(void)
 		unhash_delegation(dp);
 	}
 
-	cancel_delayed_work(&laundromat_work);
 	nfsd4_shutdown_recdir();
 	nfs4_init = 0;
 }
