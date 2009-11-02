Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZKBQ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZKBQ5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZKBQ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:57:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39986 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755961AbZKBQ5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:57:47 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/6] Clean up the sdio_uart driver and fix the tty code
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, nico@cam.org
Date: Mon, 02 Nov 2009 16:44:18 +0000
Message-ID: <20091102164039.11877.88825.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sorts out the sdio uart handling of the tty layer. The existing code
has lots of races and other fun bugs. Beat it into the current tty format for
hotpluggable devices. The updates are intentionally modelled on Alan Stern's
USB serial approach which is defintiely "best practice" right now. Also clean
it up as we go and sort the circ stuff out.

I don't have hardware to test this so hopefully someone out there does,
otherwise given the nature of the bugs involved the driver will be progressed
to BROKEN and removal.
---

Alan Cox (6):
      sdio_uart: Style fixes
      sdio_uart: Use kfifo instead of the messy circ stuff
      sdio_uart: Fix termios handling
      sdio_uart: Switch to the open/close helpers
      sdio_uart: Move the open lock
      sdio_uart: refcount the tty objects


 drivers/mmc/card/sdio_uart.c |  333 ++++++++++++++++++++++--------------------
 1 files changed, 176 insertions(+), 157 deletions(-)

-- 
"and on the seventh day she exited append mode"

