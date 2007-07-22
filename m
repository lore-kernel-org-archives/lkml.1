Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbXGVQxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbXGVQxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbXGVQwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:52:53 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:40205 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbXGVQww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:52:52 -0400
Date: Sun, 22 Jul 2007 18:52:44 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nicolas Pitre <nico@cam.org>
Subject: [ANNOUNCE] SDIO soon in mainline
Message-ID: <20070722185244.587d5bdc@poseidon.drzeus.cx>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am happy to announce that SDIO support will soon be a standard
feature in Linux. No more proprietary stacks with all the troubles
(legal and technical) that go with them.

The new code is written from scratch by yours truly and Nicolas Pitre.
There were several stacks out there that were recently made available
under the GPL, but none of them were in any shape to be merged into the
kernel.

Current status is that basic functionality is in place. There is a
driver model (with device matching and module auto-loading) and
functions for easy register access. It is also possible to receive
interrupts from the card.

There is only one driver in the tree right now (for the standard GPS
interface), but it should be complete enough for everyone to see how
the API works.

The pieces still missing are mostly performance related:

- No clock speed change.

- No wide bus support

- Interrupts are polled

- No support for combo (mem+IO) cards

The last point is unlikely to change as neither Nicolas nor I currently
possess such a card. As usual, patches/hardware is welcome.

So what we'd like to see now is extensive testing. Try the stack out on
every MMC controller you can find and review as much of the code as
possible. With some luck, we'll be able to get this ready in time for
the next merge window.

You can find the code in -mm and as just the SDIO stuff on top of
Linus' tree:

git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git#sdio

(PS. I've posted this both to LKML and LAKML. Interested readers should
probably check both lists for replies)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
