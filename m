Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYHDRKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYHDRKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYHDRKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:10:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55587 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753646AbYHDRKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:10:10 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/6] Subset of watchdog fixes
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 04 Aug 2008 17:52:59 +0100
Message-ID: <20080804164941.15222.24613.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have been pending since May with Wim occasionally surfacing to promise
something will happen then vanishing again with nothing moved on.

The patch set is a tiny subset of the complete set of patches to clean up the
locking bugs, switch to unlocked_ioctl and the like for watchdog drivers

These specific ones are the ones that
- Remove use of inb_p() on PCI bus which is unsafe with some newer boxes
- Switch from using a sempahore held across the return to user space for
  watchdog locking - and thus help remove more users of down_trylock.


 drivers/watchdog/ar7_wdt.c     |   29 ++--
 drivers/watchdog/it8712f_wdt.c |   77 ++++------
 drivers/watchdog/s3c2410_wdt.c |  148 +++++++++++---------
 drivers/watchdog/sc1200wdt.c   |  205 +++++++++++++++------------
 drivers/watchdog/wdt.c         |  176 ++++++++++++-----------
 drivers/watchdog/wdt_pci.c     |  301 +++++++++++++++++++++++-----------------
 6 files changed, 503 insertions(+), 433 deletions(-)

-- 
"The IETF already has more than enough RFCs that codify the obvious, make
stupidity illegal, support truth, justice, and the IETF way, and generally
demonstrate the author is a brilliant and valuable Contributor to The
Standards Process." -- Vernon Schryver
