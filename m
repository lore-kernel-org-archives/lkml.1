Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZFYKDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZFYKDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZFYKDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:03:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57892
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbZFYKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:03:39 -0400
Date: Thu, 25 Jun 2009 03:03:43 -0700 (PDT)
Message-Id: <20090625.030343.140417558.davem@davemloft.net>
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


1) Fix regressions wrt. unexpected IRQs during early device
   probe and startup.  From Bart.

2) Because the ID block bits were busted at the time of the
   call, until that was fixed the DMA info validity checker
   was always checking garbage.  Usually zeros.

   Now that it isn't checking garbage, it's triggering for
   all kinds of devices.  Those devices always functioned
   properly so the warning checks are just noise.

   So we simply remove them.  Fix from Bart.

3) cs5520's second port IRQ wasn't being setup properly.  With
   help from Bart and Alan Cox.

4) ide-cd had some warnings added when the CDROM advertises a
   strange block size.  But this check is overzealous, and since
   the code does correct the value it's only valuable to print
   this warning once instead of spamming your kernel log file
   every time your some daemon checks the CDROM for a present
   disc.

   From Frans Pop and your's truly.

5) Quantum fireball with APL.090 firmware needs ivb_list[] cable
   detection workaround.  From Bart.

6) Power management handling of requests isn't air tight.  Fix
   from Bart.

Please pull, thanks!

The following changes since commit 4e8a2372f9255a1464ef488ed925455f53fbdaa1:
  Mikael Pettersson (1):
        nvidiafb: fix boot-time printk string

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Bartlomiej Zolnierkiewicz (4):
      ide: fix handling of unexpected IRQs vs request_irq()
      ide: relax DMA info validity checking
      ide: add QUANTUM FIREBALLct20 30 with firmware APL.090 to ivb_list[]
      ide: improve handling of Power Management requests

David S. Miller (2):
      ide-cd: Don't warn on bogus block size unless it actually matters.
      ide cs5520: Initialize second port's interrupt number.

Frans Pop (1):
      ide-cd: Improve "weird block size" error message

 drivers/ide/cs5520.c    |    1 +
 drivers/ide/ide-cd.c    |   10 +++++---
 drivers/ide/ide-dma.c   |   21 ------------------
 drivers/ide/ide-io.c    |   54 +++++++++++++++++++---------------------------
 drivers/ide/ide-iops.c  |    4 +--
 drivers/ide/ide-probe.c |   23 +++++++++++++++++--
 include/linux/ide.h     |    2 -
 7 files changed, 50 insertions(+), 65 deletions(-)
