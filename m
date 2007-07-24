Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbXGXMqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbXGXMqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXGXMqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:46:03 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43035 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751767AbXGXMqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:46:02 -0400
Date: Tue, 24 Jul 2007 14:45:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: drivers/ide/pci/cs5535.c: array overrun
Message-ID: <20070724124524.GA6019@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following array overrun in 
drivers/ide/pci/cs5535.c:

<--  snip  -->

...
static unsigned int cs5535_udma_timings[5] =
{ 0x7F7436A1, 0x7F733481, 0x7F723261, 0x7F713161, 0x7F703061 };
...
static void cs5535_set_speed(ide_drive_t *drive, u8 speed)
{
...
                if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_7)
                        reg |= cs5535_udma_timings[speed - XFER_UDMA_0];
...

<--  snip  -->

XFER_UDMA_7 - XFER_UDMA_0 = 7  >  (5 - 1)

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

