Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZDIBP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZDIBP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 21:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZDIBPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 21:15:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZDIBPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 21:15:11 -0400
Date: Thu, 9 Apr 2009 02:14:24 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Neil Brown <neilb@suse.de>,
       Milan Broz <mbroz@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [git pull] device-mapper fixes for 2.6.30-rc2
Message-ID: <20090409011424.GP5098@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Neil Brown <neilb@suse.de>,
	Milan Broz <mbroz@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes for 2.6.30-rc2:

1) Fix a kcopyd race.
2) Support bio integrity.
3) Support barrier bios such that dm will no longer issue -EOPNOTSUPP in
response to an unsupported barrier but will instead emulate the barrier
internally.  This finally gets us the long-overdue replacement for the
issue_flush_fn that was removed oh-I-can't-remember-when...
(Split into 7 bisectable patches for readability.)

Alasdair G Kergon (3):
      dm: rearrange dm_wq_work
      dm: split DMF_BLOCK_IO flag into two
      dm: simplify dm_request loop

Martin K. Petersen (1):
      dm: add integrity support

Mikulas Patocka (6):
      dm: remove limited barrier support
      dm: rework queueing and suspension
      dm: remove dm_request loop
      dm: implement basic barrier support
      dm kcopyd: prepare for callback race fix
      dm kcopyd: fix callback race

 drivers/md/dm-ioctl.c         |   21 +++++
 drivers/md/dm-kcopyd.c        |   23 +++--
 drivers/md/dm-linear.c        |    1 -
 drivers/md/dm-table.c         |   59 ++++++++----
 drivers/md/dm.c               |  199 +++++++++++++++++++++++++++++------------
 drivers/md/dm.h               |    1 -
 include/linux/device-mapper.h |    1 -
 7 files changed, 218 insertions(+), 87 deletions(-)
 
Alasdair
-- 
agk@redhat.com
