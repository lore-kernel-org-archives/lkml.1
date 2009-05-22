Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZEVG52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZEVG52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZEVG5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:57:21 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:45142 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZEVG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:57:20 -0400
X-Greylist: delayed 2624 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 02:57:19 EDT
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Date: Fri, 22 May 2009 08:12:32 +0200
Message-Id: <1242972753-22992-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: LinuxPPS core (Version 3): the PPS Linux implementation.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PPS core support into Linux.

Currently I just propose the "core" so after inclusion we can add all
other related stuff as suggested by several people in this list. :)

PPS means "pulse per second" and its API is specified by RFC 2783
(Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).

The code has been tested with the NTPD program
(http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
antennae.


Changelog
=========

Version 2 -> 3
--------------

* include file splitted up.

Version 1 -> 2
--------------

* fix race during PPS source registration.

* PPS_CHECK removed.

* not needed check in pps_exit() removed.

* Printing stuff on exit removed.

Version [full patchset] -> 1
----------------------------

* stupid filenames removed.

* kernel-doc documentation of exported symbols.

* old BKL-locked ioctl removed.

* !uarg checks in the ioctls removed.

* pps.h revisited but not splitted, since several stuff are shared between
  kernel and user land (I hope this will not stop inclusion...)

Rodolfo

--

 Documentation/ABI/testing/sysfs-pps  |   73 +++++++
 Documentation/ioctl/ioctl-number.txt |    2 
 Documentation/pps/pps.txt            |  172 ++++++++++++++++++
 MAINTAINERS                          |    7 
 drivers/Kconfig                      |    2 
 drivers/Makefile                     |    1 
 drivers/pps/Kconfig                  |   33 +++
 drivers/pps/Makefile                 |    8 
 drivers/pps/kapi.c                   |  329 +++++++++++++++++++++++++++++++++++
 drivers/pps/pps.c                    |  312 +++++++++++++++++++++++++++++++++
 drivers/pps/sysfs.c                  |   98 ++++++++++
 include/linux/Kbuild                 |    1 
 include/linux/pps.h                  |  122 ++++++++++++
 include/linux/pps_kernel.h           |   89 +++++++++
 14 files changed, 1249 insertions(+)


