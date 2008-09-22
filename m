Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYIVQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYIVQjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYIVQix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:38:53 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35084 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbYIVQiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:38:51 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 0/4] atmel-mci: updates for 2.6.28
Date: Mon, 22 Sep 2008 18:38:13 +0200
Message-Id: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 22 Sep 2008 16:38:05.0938 (UTC) FILETIME=[96BB7520:01C91CD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

The following patches does a few cleanups of the atmel-mci driver,
adds support for multiple MMC slots (AT32AP7000 support two, but this
should be fairly easy to extend in the future), and adds optional DMA
support. If it looks fine to you (and everyone else who wants to look
over it), please queue it up for 2.6.28.

The DMA support _appears_ to work fine, but the last time I was ready
to submit it, it failed miserably on the last card in my test deck. So
I'm hoping others can help me test it as well -- if no one manages to
break it before 2.6.28 is released, I'll submit a patch to remove the
EXPERIMENTAL tag for 2.6.29.

Thanks!

Haavard Skinnemoen (4):
      atmel-mci: Implement tasklet as a state machine
      atmel-mci: Platform code for supporting multiple mmc slots
      atmel-mci: support multiple mmc slots
      atmel-mci: Add experimental DMA support

 arch/avr32/boards/atngw100/setup.c      |    7 +-
 arch/avr32/boards/atstk1000/atstk1002.c |   18 +-
 arch/avr32/boards/atstk1000/atstk1003.c |   12 +-
 arch/avr32/boards/atstk1000/atstk1004.c |   12 +-
 arch/avr32/include/asm/atmel-mci.h      |   26 +-
 arch/avr32/mach-at32ap/at32ap700x.c     |   90 ++-
 drivers/mmc/host/Kconfig                |   11 +
 drivers/mmc/host/atmel-mci-regs.h       |    6 +-
 drivers/mmc/host/atmel-mci.c            | 1238 +++++++++++++++++++++----------
 9 files changed, 1013 insertions(+), 407 deletions(-)

Haavard
