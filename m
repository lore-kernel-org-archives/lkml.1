Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYIMIVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYIMIVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 04:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYIMIUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 04:20:03 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:58655 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbYIMITx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 04:19:53 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 10 Sep 2008 09:52:19 +0200
Message-Id: <1221033149-15405-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: LinuxPPS (RESUBMIT 7): the PPS Linux implementation.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds the PPS support into Linux.

PPS means "pulse per second" and its API is specified by RFC 2783
(Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).

The code has been tested with the NTPD program
(http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
antennae.

Changelog

RESUBMIT 6 -> 7:

* A new line discipline has been added in order to leave untouched
  the serial ports code (as suggested by Alan).

* n_tty.c exports only GPL symbols.

* ioctl numbers fixed in order to avoid any conflicts.

* Last patch (0010-PPS-low-level-IRQ-timestamps-recording.patch) implements
  low level IRQs timestamps recording which mproves PPS precision but can
  be dropped for kernel inclusion! As suggested by Alan: "After that is
  sorted/merged we can come back to working out the best way to improve
  the IRQ and HARDPPS hacks."

Rodolfo

--

 b/Documentation/ABI/testing/sysfs-pps |   73 +++++++
 b/Documentation/ioctl-number.txt      |    2
 b/Documentation/pps/Makefile          |   28 ++
 b/Documentation/pps/pps.txt           |  172 +++++++++++++++++
 b/Documentation/pps/ppsfind           |   17 +
 b/Documentation/pps/ppsldisc.c        |   46 ++++
 b/Documentation/pps/ppstest.c         |  151 +++++++++++++++
 b/Documentation/pps/timepps.h         |  195 +++++++++++++++++++
 b/Documentation/tty.txt               |    4
 b/MAINTAINERS                         |    7
 b/arch/x86/kernel/irq_32.c            |   17 +
 b/arch/x86/kernel/irq_64.c            |   21 +-
 b/drivers/Kconfig                     |    2
 b/drivers/Makefile                    |    1
 b/drivers/char/lp.c                   |   61 ++++++
 b/drivers/char/n_tty.c                |   54 +++--
 b/drivers/pps/Kconfig                 |   33 +++
 b/drivers/pps/Makefile                |    8
 b/drivers/pps/clients/Kconfig         |   18 +
 b/drivers/pps/clients/Makefile        |    9
 b/drivers/pps/clients/ktimer.c        |  124 ++++++++++++
 b/drivers/pps/clients/pps-ldisc.c     |  154 +++++++++++++++
 b/drivers/pps/kapi.c                  |  322 ++++++++++++++++++++++++++++++++
 b/drivers/pps/pps.c                   |  335 ++++++++++++++++++++++++++++++++++
 b/drivers/pps/sysfs.c                 |  104 ++++++++++
 b/drivers/serial/8250.c               |   13 +
 b/include/linux/Kbuild                |    1
 b/include/linux/parport.h             |   22 ++
 b/include/linux/pps.h                 |  202 ++++++++++++++++++++
 b/include/linux/serial_core.h         |   10 -
 b/include/linux/tty.h                 |   16 +
 b/include/linux/tty_ldisc.h           |    8
 drivers/pps/Kconfig                   |   14 +
 drivers/pps/Makefile                  |    1
 drivers/pps/clients/Kconfig           |   17 +
 drivers/pps/clients/Makefile          |    1
 include/linux/pps.h                   |    1
 include/linux/serial_core.h           |    7
 include/linux/tty.h                   |    3
 39 files changed, 2247 insertions(+), 27 deletions(-)


