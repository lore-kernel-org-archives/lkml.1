Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0BRS7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:59:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:4680 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab0BRS7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:59:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=nGExqdQ8yfJEj8Ie25eEikuMQeeyMrXzO37uYaa/XuhGmRYdouaKVvyze8tnbPK9Iq
         9G5VI8Aj1bDMXV8bN0M0ImCvTw0XQTnSOkmI1/4eTKmbNAMOTiAF04vPf7ostJjE1okP
         gMFWbqOIlSw1D0qxXTIWdm+G6nrQNZbmnzC3c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 18 Feb 2010 19:59:14 +0100
Message-Id: <20100218185914.16594.61415.sendpatchset@localhost>
Subject: [git patches] atang tree: parallel scanning improvements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DISCLAIMER: the fact of getting patches merged into atang tree means
that from now on they will be getting updates for changes happening
in atang tree and it should not be treated as an indication regarding
decisions taken by 'upstream' kernel trees


Allow parallel scan and the like to be set without having to stop using
the existing full helper functions (this is based on a upstream proposal
patch from Alan Cox) and add parallel scanning feature for older Intel
PATA controllers.

[ Patches for other controllers are welcomed and I will also continue
  progressively adding parallel scanning while fixing/testing drivers. ]


The following changes since commit e2adfa56bafbafb65cdb6d8efe4cac5ed7582f88:
  Bartlomiej Zolnierkiewicz (1):
        pata_pdc202xx_old: update documentation

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.6

Bartlomiej Zolnierkiewicz (3):
      libata: pass host flags into __ata_pci_sff_init_one() helper
      pata_oldpiix: add locking for parallel scanning
      pata_oldpiix: enable parallel scan

 drivers/ata/libata-sff.c    |    4 +++-
 drivers/ata/pata_ali.c      |    2 +-
 drivers/ata/pata_amd.c      |    2 +-
 drivers/ata/pata_artop.c    |    2 +-
 drivers/ata/pata_atiixp.c   |   18 ++----------------
 drivers/ata/pata_cmd640.c   |    2 +-
 drivers/ata/pata_cs5530.c   |    2 +-
 drivers/ata/pata_efar.c     |   18 ++----------------
 drivers/ata/pata_hpt366.c   |    2 +-
 drivers/ata/pata_it821x.c   |    2 +-
 drivers/ata/pata_ns87415.c  |    2 +-
 drivers/ata/pata_oldpiix.c  |   13 +++++++++++--
 drivers/ata/pata_sl82c105.c |    2 +-
 include/linux/libata.h      |    4 ++--
 14 files changed, 29 insertions(+), 46 deletions(-)
