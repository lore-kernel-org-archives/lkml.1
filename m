Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbYBRX0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbYBRX0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbYBRX0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:26:13 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:41614 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbYBRX0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:26:09 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>
Date: Tue, 19 Feb 2008 00:28:32 +0100
Message-Id: <1203377319975-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.2.5
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: LinuxPPS (RESUBMIT): the PPS Linux implementation.
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

Rodolfo

--

 Documentation/pps/Makefile            |    2 
 b/Documentation/ABI/testing/sysfs-pps |   73 +++++++
 b/Documentation/pps/Makefile          |   27 ++
 b/Documentation/pps/pps.txt           |  170 ++++++++++++++++
 b/Documentation/pps/ppsctl.c          |   63 ++++++
 b/Documentation/pps/ppsfind           |   17 +
 b/Documentation/pps/ppstest.c         |  152 +++++++++++++++
 b/Documentation/pps/timepps.h         |  196 +++++++++++++++++++
 b/MAINTAINERS                         |    7 
 b/drivers/Kconfig                     |    2 
 b/drivers/Makefile                    |    1 
 b/drivers/char/lp.c                   |   61 ++++++
 b/drivers/pps/Kconfig                 |   32 +++
 b/drivers/pps/Makefile                |    8 
 b/drivers/pps/clients/Kconfig         |   18 +
 b/drivers/pps/clients/Makefile        |    9 
 b/drivers/pps/clients/ktimer.c        |  115 +++++++++++
 b/drivers/pps/kapi.c                  |  272 +++++++++++++++++++++++++++
 b/drivers/pps/pps.c                   |  342 ++++++++++++++++++++++++++++++++++
 b/drivers/pps/sysfs.c                 |  130 ++++++++++++
 b/drivers/serial/8250.c               |    2 
 b/drivers/serial/serial_core.c        |   71 ++++++-
 b/include/linux/Kbuild                |    1 
 b/include/linux/parport.h             |   13 +
 b/include/linux/pps.h                 |  205 ++++++++++++++++++++
 b/include/linux/serial_core.h         |   31 ++-
 drivers/pps/Kconfig                   |    2 
 drivers/pps/Makefile                  |    1 
 drivers/pps/clients/Kconfig           |   20 +
 29 files changed, 2028 insertions(+), 15 deletions(-)



