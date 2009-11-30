Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbZK3JON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbZK3JON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZK3JON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:14:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55103
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbZK3JOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:14:12 -0500
Date: Mon, 30 Nov 2009 01:14:18 -0800 (PST)
Message-Id: <20091130.011418.100555495.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a long standing memory corruption on bootup issue
effecting several sparc64 machines, due to an improper definition
of VMEMMAP_SIZE.  So if you had physical memory past a certain
point we're overwrite past the end of an array and spam random
data section stuff.

Also, get RSC/LOM serial consoles working properly.

Please pull, thanks a lot!

The following changes since commit a8a8a669ea13d792296737505adc43ccacf3a648:
  Linus Torvalds (1):
        Merge branch 'i2c-pnx-fixes' of git://git.fluff.org/bjdooks/linux

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (7):
      sparc64: Fix definition of VMEMMAP_SIZE.
      sunsab: Do not set sunsab_reg.cons right before registering minors.
      sunsu: Fix detection of SU ports which are RSC console or control.
      serial: suncore: Add 'ignore_line' argument to sunserial_console_match().
      serial: suncore: Fix RSC/LOM handling in sunserial_console_termios().
      sunsu: Pass true 'ignore_line' to console match when RSC or LOM console.
      sunsu: Use sunserial_console_termios() in sunsu_console_setup().

 arch/sparc/mm/init_64.h   |    2 +-
 drivers/serial/suncore.c  |   37 ++++++++++++++++++++-----------------
 drivers/serial/suncore.h  |    5 +++--
 drivers/serial/sunhv.c    |    2 +-
 drivers/serial/sunsab.c   |    9 +++++----
 drivers/serial/sunsu.c    |   36 ++++++++++++++++++++++++++++--------
 drivers/serial/sunzilog.c |    8 +++++---
 7 files changed, 63 insertions(+), 36 deletions(-)
