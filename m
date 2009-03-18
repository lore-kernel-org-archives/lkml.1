Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZCRN0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZCRN0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZCRN0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbZCRN0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:33 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
Subject: [GFS2] Pre-pull patch posting
Date: Wed, 18 Mar 2009 12:23:35 +0000
Message-Id: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So as the merge window draws closer, here is the current content of the
GFS2 git tree. The major item this time is patch 5 in the series. This
contians by far the majority of the changes, and the majority of those
changes are actually removal of code. The patch merges the lock_dlm
module (not the dlm itself, but GFS2's interface to the dlm) into
GFS2 itself. This means that a number of optimisations are then
possible in terms of merging strucutures resulting in a considerable
saving in memory.

Since that patch is so large (I'm afraid that it really doesn't make
any sense to split it up) its been in the -nmw git tree for the whole
period since the last merge window and has also been posted for review
on cluster-devel on a number of occasions before that. We've run a
number of tests on it as well in that period, so I believe that its
pretty stable now. It certainly makes the code a lot cleaner and
easier to follow in that area.

The remainder of the patches are mostly bug fixes, but there are one
or two other interesting features, those being:

 o GFS2 now supports the discard I/O requests for thin provisioning, etc
 o A new "demote a glock" interface is added to sysfs to help in
   testing GFS2
 o With a new mkfs.gfs2 which writes UUIDs, the UUID is now included
   in uevent messages (with older filesystems which don't have UUIDs,
   we just don't send that information)

The GFS2 tracing patches which I posted a little while back are not
included in this patch set. I think I can see what I need to do in
order to avoid patching blktrace now, so my plan is to look at those
patches again after this merge window, and when all the queued patches
for the tracing subsystem have been merged.

As always, please let us know if you spot any issues in the patches,

Steve.


