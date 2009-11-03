Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZKCLeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZKCLeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZKCLeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:34:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43112 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbZKCLeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:34:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fixes for 2.6.32
Date: Tue, 3 Nov 2009 12:36:12 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       "Stephen J. Gowdy" <gowdy@cern.ch>, Jose Marino <braket@hotmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Romit Dasgupta <romit@ti.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911031236.12094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

This includes the following changes:

* The fix for http://bugzilla.kernel.org/show_bug.cgi?id=14334 (yenta resume
  regression from 2.6.31).

* Hibernation fixes from Jiri Slaby.  Two of these patches fix long standing
  bugs, but in my opinion they are simple enough to go into 2.6.32.  The third
  one is a two-liner complementing one of the fixes.

* PM core error code path fix from Romit Dasgupta.

* Removal of some run-time PM debug messages creating too much noise from
  Pavel (the run-time PM framework is a new feature in 2.6.32 and this is
  just a refinement of it).


 drivers/base/power/main.c     |    1 +
 drivers/base/power/runtime.c  |    4 --
 drivers/pcmcia/cs.c           |   69 +++++++++++++++++++++++++---------------
 drivers/pcmcia/yenta_socket.c |   12 ++++++-
 include/pcmcia/ss.h           |    4 ++
 kernel/power/hibernate.c      |   11 +++++--
 kernel/power/swap.c           |   43 +++++++++++++------------
 7 files changed, 89 insertions(+), 55 deletions(-)

---------------

Jiri Slaby (3):
      PM / Hibernate: Fix blkdev refleaks
      PM / Hibernate: Fix error handling in save_image()
      PM / Hibernate: Add newline to load_image() fail path

Pavel Machek (1):
      PM: Remove some debug messages producing too much noise

Rafael J. Wysocki (1):
      PM / yenta: Split resume into early and late parts (rev. 4)

Romit Dasgupta (1):
      PM: Fix warning on suspend errors

