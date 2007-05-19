Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbXESLkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbXESLkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 07:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbXESLkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 07:40:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33937 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXESLkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 07:40:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 19 May 2007 13:39:23 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 fixes post 2.6.22-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.1171a59b9de88f9c@s5r6.in-berlin.de>
Message-ID: <tkrat.5299b7dd67007e8c@s5r6.in-berlin.de>
References: <tkrat.1171a59b9de88f9c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394 subsystem updates:

  - fix regression in 2.6.22-rc1:
    raw1394 asynchronous transmit was broken

  - fix old bug in raw1394:
    32bit compat code for 64bit kernels was broken and incomplete

  - fix old eth1394 bug:
    packets were frequently dropped in transmit path
    (This fixes only the most common type of failure, tlabel exhaustion.)

  - trivial sbp2 fix

The 32bit compat code has been posted to LKML twice.  The rest was only
seen on linux1394-devel, hence I'll follow up with the combined diff.


 drivers/ieee1394/eth1394.c |   84 +++++++++++++-----
 drivers/ieee1394/eth1394.h |    4 +
 drivers/ieee1394/raw1394.c |  172 ++++++++++++++++++++++++++++--------
 drivers/ieee1394/sbp2.c    |    1 +
 4 files changed, 204 insertions(+), 57 deletions(-)

Petr Vandrovec (4):
      ieee1394: raw1394: Fix async send
      ieee1394: raw1394: Fix read() for 32bit userland on 64bit kernel
      ieee1394: raw1394: Fix write() for 32bit userland on 64bit kernel
      ieee1394: raw1394: Add ioctl() for 32bit userland on 64bit kernel

Stefan Richter (3):
      ieee1394: sbp2: include workqueue.h
      ieee1394: eth1394: remove bogus netif_wake_queue
      ieee1394: eth1394: handle tlabel exhaustion
-- 
Stefan Richter
-=====-=-=== -=-= =--==
http://arcgraph.de/sr/

