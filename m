Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZF3Cyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZF3Cyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZF3CyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:54:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47510
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756327AbZF3CyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:54:25 -0400
Date: Mon, 29 Jun 2009 19:54:30 -0700 (PDT)
Message-Id: <20090629.195430.05775132.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE fixes
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Sizing of temp ID buffer allocated is insufficient for
   HDIO_OBSOLETE_IDENTITY ioctl.  Fix from Christian Engelmayer.

2) ide-floppy and ide-tape uses esoteric IDE custom command completion
   routine which does horrible things such as partial command
   completions on errors, and even forgets to signal error codes at all
   in some cases.  Stop using this turd and use the generic block
   layer requst completion interfaces to fix these bugs.  Fix from
   Bart.

3) With IDEACPI sometimes resume breaks, fix by adding helper function
   to check all the necessary cases.  Fix from Bart.

4) Handle properly devices which clear DRQ during the last word of
   a packet (these actually exist).  This also pointed out an error
   in ATA_ERR bit handling, also fixed here.  Fix from Borislav Petkov.

Please pull, thanks a lot!

The following changes since commit 52989765629e7d182b4f146050ebba0abf2cb0b7:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Bartlomiej Zolnierkiewicz (3):
      ide: fix ide_kill_rq() for special ide-{floppy,tape} driver requests
      ide: always kill the whole request on error
      ide: fix resume for CONFIG_BLK_DEV_IDEACPI=y

Borislav Petkov (1):
      ide-cd: handle fragmented packet commands gracefully

Christian Engelmayer (1):
      ide: memory overrun in ide_get_identity_ioctl() on big endian machines using ioctl HDIO_OBSOLETE_IDENTITY

 drivers/ide/ide-acpi.c    |   37 +++++++------------------------------
 drivers/ide/ide-cd.c      |   14 ++++++++++++--
 drivers/ide/ide-devsets.c |    2 +-
 drivers/ide/ide-eh.c      |    2 +-
 drivers/ide/ide-floppy.c  |    2 +-
 drivers/ide/ide-io.c      |   14 ++------------
 drivers/ide/ide-ioctls.c  |    3 ++-
 drivers/ide/ide-pm.c      |   30 ++++++++++++++++++------------
 include/linux/ide.h       |    3 ++-
 9 files changed, 46 insertions(+), 61 deletions(-)
