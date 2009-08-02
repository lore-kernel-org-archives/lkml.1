Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZHBWHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZHBWHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZHBWH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:07:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:50228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbZHBWHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:07:25 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Aug 2009 08:07:27 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19062.3615.711449.258305@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: PULL REQUEST - md fixes for 2.6.31
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 Sorry that these are a little late, but I've had a few
 distractions...

 Anyway, please pull the 8 small updates for drivers/md in 2.6.31.
 Most are straight bug fixes (Some tagged for -stable).
 A couple ('Push down data integrity' and 'Use revalidate disk') are
 code cleanups that make the code more obviously correct.

Thanks,
NeilBrown


The following changes since commit 7d3e91b8a1f5179d56a7412d4b499f2d5fc6b25d:
  Linus Torvalds (1):
        Merge branch 'hwmon-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Andre Noll (1):
      md: Push down data integrity code to personalities.

Dan Williams (1):
      md/raid6: release spare page at ->stop()

NeilBrown (6):
      md: when a level change reduces the number of devices, remove the excess.
      md: avoid array overflow with bad v1.x metadata
      md: Handle growth of v1.x metadata correctly.
      md/raid5: set reshape_position correctly when reshape starts.
      md: allow raid5_quiesce to work properly when reshape is happening.
      md: Use revalidate_disk to effect changes in size of device.

 drivers/md/linear.c    |    2 +
 drivers/md/md.c        |  143 +++++++++++++++++++++++++++++------------------
 drivers/md/md.h        |    2 +
 drivers/md/multipath.c |    5 +-
 drivers/md/raid0.c     |    1 +
 drivers/md/raid1.c     |    7 ++-
 drivers/md/raid10.c    |    4 +
 drivers/md/raid5.c     |   51 ++++++++---------
 8 files changed, 131 insertions(+), 84 deletions(-)
