Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZEZDGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZEZDGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 23:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZEZDG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 23:06:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:54344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZEZDG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 23:06:26 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 May 2009 13:06:32 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18971.23736.279996.704625@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md - various fixed for 2.6.30
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 a few more md fixes turned up through on going testing.

 A couple involve refining the user-space interface (sysfs) so that
 some of the recent features can be used reliably.

 The 'bitmap' fix isn't strictly a bug fix, but is reduces a fair
 amount of CPU wastage.

 The "don't use locked_ioctl" patch is again strictly not a bug fix,
 but it is so trivial it didn't seem worth leaving it for .31.
 It just tells the block layer that md doesn't need lock_kernel, even
 for ioctls.

Thanks,
NeilBrown


The following changes since commit 59a3759d0fe8d969888c741bb33f4946e4d3750d:
  Linus Torvalds (1):
        Linux 2.6.30-rc7

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (7):
      md: always update level / chunk_size / layout when writing v1.x metadata.
      md: improve errno return when setting array_size
      md: bitmap: improve bitmap maintenance code.
      md: export 'frozen' resync state through sysfs
      md: raid5: avoid sector values going negative when testing reshape progress.
      md: don't update curr_resync_completed without also updating reshape_position.
      md: don't use locked_ioctl.

 drivers/md/bitmap.c |   13 +++++++------
 drivers/md/md.c     |   31 +++++++++++++++++++++----------
 drivers/md/raid5.c  |    6 +++---
 3 files changed, 31 insertions(+), 19 deletions(-)
