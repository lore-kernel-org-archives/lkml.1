Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbXITJLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbXITJLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXITJKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:10:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbXITJKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:10:50 -0400
Date: Thu, 20 Sep 2007 05:10:35 -0400
Message-Id: <200709200910.l8K9AZId001323@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 0/7] fix setuid/setgid clearing in networked filesystems (rev 7)
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the 7th revision for fixing the clearing of setuid and
setgid bits in networked filesystems. It should apply cleanly to
2.6.23-rc6-mm1.

The first four patches in the set are cleanup patches to make sure that
those filesystems don't trip the new BUG() call in notify_change. The
fifth patch (the main one) fixes notify_change to not clear the
ATTR_KILL_S*ID bits when interpreting them into a mode change. The final
two patches change NFS and CIFS to take advantage of the new scheme.

This is basically the same patchset as version 6. The main differences
are changes to ecryptfs and unionfs patches to accomodate changes made
in recent -mm patches. Also, when I sent out the 6th revision I forgot
to mention that the knfsd patch had been changed to more closely reflect
the existing behavior when receiving a setattr call that changes the
mode and uid/gid.

This patchset is being submitted for inclusion into -mm.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
