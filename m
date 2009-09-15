Return-Path: <linux-kernel-owner+w=401wt.eu-S1750903AbZIOIxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903AbZIOIxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbZIOIxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:53:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52934
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZIOIxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:53:00 -0400
Date: Tue, 15 Sep 2009 01:53:17 -0700 (PDT)
Message-Id: <20090915.015317.23043536.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Minor IDE cleanups and enhancement to debug logging to make
   problems easier to diagnose.  From Borislav Petkov

2) Various bug fixes from Bartlomiej Zolnierkiewicz including
   a fix for races with user invoked SET XFER commands.

3) ->proc_fops conversion from Alexey Dobriyan.

4) Add quirk fixup for a Fujitsu disk, from Wu Zhangjin.

Please pull, thanks a lot!

The following changes since commit 90bc1a658a53f8832ee799685703977a450e5af9:
  Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-next-2.6.git master

Alexey Dobriyan (1):
      ide: convert to ->proc_fops

Bartlomiej Zolnierkiewicz (2):
      ide: allow ide_dev_read_id() to be called from the IRQ context
      ide: fix races in handling of user-space SET XFER commands

Borislav Petkov (2):
      ide-tape: convert to ide_debug_log macro
      ide-tape: fix handling of postponed rqs

David S. Miller (1):
      ide: Fix annoying warning in ide_pio_bytes().

Jaswinder Singh Rajput (1):
      ide: ide-taskfile.c fix style problems

Jean Delvare (1):
      IDE: Save a call to PageHighMem()

Julia Lawall (1):
      drivers/ide/ide-cd.c: Use DIV_ROUND_CLOSEST

Kevin Hilman (1):
      IDE: palm_bk3710: convert clock usage after clkdev conversion

Mark de Wever (1):
      ide-tape: fix debug call

Sergey Matyukevich (1):
      at91_ide: remove headers specific for at91sam9263

Wu Zhangjin (1):
      ide: fixup for fujitsu disk

 drivers/ide/at91_ide.c        |    2 -
 drivers/ide/ide-cd.c          |   32 +++--
 drivers/ide/ide-disk_proc.c   |  129 ++++++++++------
 drivers/ide/ide-floppy_proc.c |   30 +++-
 drivers/ide/ide-ioctls.c      |    8 +-
 drivers/ide/ide-iops.c        |   17 +--
 drivers/ide/ide-probe.c       |   31 +++--
 drivers/ide/ide-proc.c        |  340 ++++++++++++++++++++++++++---------------
 drivers/ide/ide-tape.c        |  160 ++++++++++----------
 drivers/ide/ide-taskfile.c    |  126 ++++++++--------
 drivers/ide/palm_bk3710.c     |    2 +-
 include/linux/ide.h           |   30 +---
 12 files changed, 522 insertions(+), 385 deletions(-)
