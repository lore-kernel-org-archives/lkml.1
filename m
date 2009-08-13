Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZHMBCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZHMBCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 21:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZHMBCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 21:02:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:49446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbZHMBCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 21:02:04 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Aug 2009 11:02:17 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19075.26137.683216.283090@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Snitzer <snitzer@redhat.com>
Subject: [PULL REQUEST] a few more md fixes for 2.6.31
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus, 
 please pull as follows.
 The first listed patch fixes a recent regression.
    http://bugzilla.kernel.org/show_bug.cgi?id=13944
 The remainder are some small fixes, particularly relating to
 restarting an reshape (e.g. raid5->raid6 migration) which was
 aborted in the middle.

Thanks,
NeilBrown


The following changes since commit 7b2aa037e878c939676675969983284a02958ae3:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (6):
      Remove deadlock potential in md_open
      md: never advance 'events' counter by more than 1.
      md/raid5: allow new reshape modes to be restarted in the middle.
      md/raid5: make sure a reshape restarts at the correct address.
      md/raid5: Properly remove excess drives after shrinking a raid5/6
      md: allow upper limit for resync/reshape to be set when array is read-only

 drivers/md/md.c    |   32 ++++++++++++++++----------------
 drivers/md/md.h    |   10 ++++++++++
 drivers/md/raid5.c |   34 ++++++++++++++++++++++++++++++----
 3 files changed, 56 insertions(+), 20 deletions(-)
