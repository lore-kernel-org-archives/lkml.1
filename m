Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbYJEQaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbYJEQaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbYJEQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:49 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62758 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086AbYJEQWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:38 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v2 0/7] atmel-mci: updates for 2.6.28
Date: Sun,  5 Oct 2008 18:21:23 +0200
Message-Id: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 05 Oct 2008 16:21:15.0056 (UTC) FILETIME=[6391DB00:01C92706]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

The following patches does a few cleanups of the atmel-mci driver,
adds support for multiple MMC slots (AT32AP7000 support two, but this
should be fairly easy to extend in the future), and adds optional DMA
support. If it looks fine to you (and everyone else who wants to look
over it), please queue it up for 2.6.28.

The DMA support appears to work fine with all the cards I have
available. The CPU usage is a bit high if the card is fast, but that's
something I intend to look into later. It's a lot better and faster
than the current driver.

Changes since the last version of this patchset:
  - The clock is no longer stopped between transfers.
  - The clock speed is limited to the speed of the slowest card when
    using multiple slots, but there may still be issues I don't fully
    understand, so I added a warning for the board code. Boards which
    use only one slot should not be affected, however.
  - A few DMA-related kerneldoc comments were moved into the DMA patch.
  - A data transfer error while not using DMA could hang the state
    machine. This has been fixed.
  - A missing call to flush_dcache_page() in the PIO code was added.
    This is a no-op on avr32, so it probably doesn't deserve
    backporting to 2.6.27 or -stable.

Haavard Skinnemoen (7):
      atmel-mci: Implement tasklet as a state machine
      atmel-mci: Don't stop the clock between transfers
      atmel-mci: Platform code for supporting multiple mmc slots
      atmel-mci: support multiple mmc slots
      atmel-mci: Add experimental DMA support
      atmel-mci: Don't overwrite error bits when NOTBUSY is set
      atmel-mci: Add missing flush_dcache_page() in PIO transfer code

 arch/avr32/boards/atngw100/setup.c      |    7 +-
 arch/avr32/boards/atstk1000/atstk1002.c |   18 +-
 arch/avr32/boards/atstk1000/atstk1003.c |   12 +-
 arch/avr32/boards/atstk1000/atstk1004.c |   12 +-
 arch/avr32/include/asm/atmel-mci.h      |   32 +-
 arch/avr32/mach-at32ap/at32ap700x.c     |   90 ++-
 drivers/mmc/host/Kconfig                |   11 +
 drivers/mmc/host/atmel-mci-regs.h       |    6 +-
 drivers/mmc/host/atmel-mci.c            | 1352 ++++++++++++++++++++++---------
 9 files changed, 1127 insertions(+), 413 deletions(-)

Haavard
