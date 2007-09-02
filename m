Return-Path: <linux-kernel-owner+w=401wt.eu-S965276AbXIBLfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276AbXIBLfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964891AbXIBLfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:35:09 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:41975 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895AbXIBLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:35:08 -0400
From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.22.5] Machine freeze when smartd launches long scans
X-Mailer: MH [version 6.8]
Organization: Home, Grenoble, France
Date: Sun, 02 Sep 2007 13:32:58 +0200
Message-ID: <13160.1188732778@nice>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The last messages I have on the netconsole are:

	hda: lost interrupt
	hda: dma_timer_expiry: dma status == 0x61
	hda: DMA timeout error

After that, the machine no longer responds to pings, the keyboard
is non-responsive (so I could not see what the local console said,
as my X session had blanked the screen, and ctrl-F1 has no effect).

There was no OOPS logged despite the NMI watchdog running.

The funny thing is that when I launch:

	smartctl -t long /dev/hda

myself, everything goes fine and the test completes.  It's only
when the tests are launched every Sunday morning by smartd that
the machine freezes.

This has been happening with 2.6.22.1 and 2.6.22.5 for the last
4 weeks.  Before that, I was running 2.4.31 and everything was just
fine, never got a hang.

I don't think the hardware is at fault (I tried changing the disk,
same thing), and the fact that the machine freezes after a single
DMA timeout error is not normal.

I'm running an SMP version on a P4 with hyper-threading.

Any idea of what could be wrong in the IDE timeout error recovery?

Raphael
