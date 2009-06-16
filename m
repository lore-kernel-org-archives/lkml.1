Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbZFPPB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbZFPPB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZFPPBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:01:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44015 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbZFPPBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:01:48 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/9] Series short description
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 16:59:55 +0100
Message-ID: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small fixes to the tty changes to sort out problems people hit, in particular
to fix a couple of SMP races Ingo found and properly fix the now rather more
visible (but long standing) pty race that James Bottomley encountered.
---

Alan Cox (5):
      tty: fix sanity check
      pty: Narrow the race on ldisc locking
      ldisc: debug aids
      ldisc: Make sure the ldisc isn't active when we close it
      tty: Fix leaks introduced by the shift to separate ldisc objects

Haavard Skinnemoen (1):
      atmel_serial: fix hang in set_termios when crtscts is enabled

Joe Perches (1):
      MAINTAINERS: update 8250 section, give Alan Cox a name

Mike Frysinger (1):
      tty: fix unused warning when TCGETX is not defined

Sascha Hauer (1):
      imx: Check for NULL pointer deref before calling  tty_encode_baud_rate


 MAINTAINERS                   |    3 ++
 drivers/char/pty.c            |   53 +++++++++++++++++++++++++++++++----------
 drivers/char/tty_io.c         |    2 ++
 drivers/char/tty_ioctl.c      |    5 ++--
 drivers/char/tty_ldisc.c      |    9 +++++--
 drivers/serial/atmel_serial.c |    8 ++++--
 drivers/serial/imx.c          |   12 +++++----
 7 files changed, 66 insertions(+), 26 deletions(-)

-- 
	"Standards committees don't like hashing.  It looks complicated and
         insufficiently deterministic on an overhead projector."
			-Vern Schryver

