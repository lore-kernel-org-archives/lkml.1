Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbYIIEOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbYIIEOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYIIEI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:08:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42589 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbYIIEIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:08:16 -0400
From: Jarod Wilson <jwilson@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Eric Sandeen <esandeen@redhat.com>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: [PATCH 0/18] linux infrared remote control drivers
Date: Tue,  9 Sep 2008 00:05:45 -0400
Message-Id: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series adds 17 new drivers for assorted infrared and/or RF
remote control receivers and/or transmitters. These drivers have long lived
out-of-tree at http://www.lirc.org/, packaged as 3rd-party modules by many
distributions, and more recently, patched into the kernels of at least Fedora
and Ubuntu. The primary maintainer of lirc, Christoph Bartelmus simply hasn't
had the time to send these bits upstream, and a few months back, gave me the
go-ahead to take on the task.

Most drivers are fairly widely tested, certainly within the MythTV community,
which relies upon this code quite a bit. However, note that in preparation
for this submission, a fair number of code changes have been made only
recently that may or may not have yet made it back into lirc cvs, and thus
might not be as widely tested. Any bugs found were probably introduced by
either myself or Janne Grunau, the primary folks working on the latest round
of whacking checkpatch.pl complaints to prepare for this submission.

Speaking of checkpatch... When I first added the lirc driver patch to the
Fedora kernels (oy, way back in August of 2007), there were tens of thousands
of lines of checkpatch warnings and errors. Through the efforts of myself,
Janne, Eric Sandeen, and misc contributions from others, I'm now quite
tickled to see the following:

--
$ scripts/checkpatch.pl /data/patches/lirc-for-upstream-combined.patch
total: 0 errors, 0 warnings, 17877 lines checked

/data/patches/lirc-for-upstream-combined.patch has no obvious style problems
and is ready for submission.
--

Earlier rounds of checkpatch cleanups have already been fed back into lirc
cvs, and Christoph has given me commit access there, so as to filter the
latest changes back in as well. For the time being, lirc cvs will
continue to be the canonical upstream for the lirc drivers, and all the
earlier kernel compat bits get stripped out via an export script[1],
though the script is still under a bit of development... I'll be taking
point on maintaining the git tree[2] and synchronizing changes back and
forth with cvs, at least until such time as everything is in the kernel,
and nobody has need for out-of-tree drivers anymore, at which time the
drivers will be dropped from the main lirc tarball.

Not all drivers have been tested with this codebase and certainly not all
devices they support, but its a solid place to start with these in-kernel.
Patches are against 2.6.27-rc5-git9 or so, and have been tested running
the same, at least in the cases where hardware was available. These patches
are also in the latest nightly Fedora rawhide kernel, for those who want
instant gratification[3]. Note that you also need the lirc userspace to
really do any meaningful testing...

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Janne Grunau <j@jannau.net>
CC: Christoph Bartelmus <lirc@bartelmus.de>
CC: Eric Sandeen <esandeen@redhat.com>
CC: Mario Limonciello <superm1@ubuntu.com>

[1] http://people.redhat.com/jwilson/lirc/, in a tarball atm
[2] http://git.wilsonet.com/linux-2.6-lirc.git/ (s/http/git/ to clone)
[3] http://kojipkgs.fedoraproject.org/packages/kernel/2.6.27/0.314.rc5.git9.fc10/
    is the latest build, at least as of this submission

Combined diffstat:

 MAINTAINERS                           |    9 +
 drivers/input/Kconfig                 |    2 +
 drivers/input/Makefile                |    2 +
 drivers/input/lirc/Kconfig            |  142 ++++
 drivers/input/lirc/Makefile           |   25 +
 drivers/input/lirc/commandir.c        |  982 +++++++++++++++++++++++
 drivers/input/lirc/commandir.h        |   68 ++
 drivers/input/lirc/lirc.h             |  103 +++
 drivers/input/lirc/lirc_atiusb.c      | 1321 +++++++++++++++++++++++++++++++
 drivers/input/lirc/lirc_bt829.c       |  388 +++++++++
 drivers/input/lirc/lirc_cmdir.c       |  596 ++++++++++++++
 drivers/input/lirc/lirc_cmdir.h       |   25 +
 drivers/input/lirc/lirc_dev.c         |  809 +++++++++++++++++++
 drivers/input/lirc/lirc_dev.h         |  262 ++++++
 drivers/input/lirc/lirc_i2c.c         |  639 +++++++++++++++
 drivers/input/lirc/lirc_igorplugusb.c |  619 +++++++++++++++
 drivers/input/lirc/lirc_imon.c        | 1280 ++++++++++++++++++++++++++++++
 drivers/input/lirc/lirc_it87.c        |  999 +++++++++++++++++++++++
 drivers/input/lirc/lirc_it87.h        |  116 +++
 drivers/input/lirc/lirc_ite8709.c     |  545 +++++++++++++
 drivers/input/lirc/lirc_mceusb.c      |  890 +++++++++++++++++++++
 drivers/input/lirc/lirc_mceusb2.c     | 1119 ++++++++++++++++++++++++++
 drivers/input/lirc/lirc_parallel.c    |  728 +++++++++++++++++
 drivers/input/lirc/lirc_parallel.h    |   26 +
 drivers/input/lirc/lirc_sasem.c       |  969 +++++++++++++++++++++++
 drivers/input/lirc/lirc_serial.c      | 1312 +++++++++++++++++++++++++++++++
 drivers/input/lirc/lirc_sir.c         | 1302 ++++++++++++++++++++++++++++++
 drivers/input/lirc/lirc_streamzap.c   |  795 +++++++++++++++++++
 drivers/input/lirc/lirc_ttusbir.c     |  400 ++++++++++
 drivers/input/lirc/lirc_zilog.c       | 1395 +++++++++++++++++++++++++++++++++
 30 files changed, 17868 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/lirc/Kconfig
 create mode 100644 drivers/input/lirc/Makefile
 create mode 100644 drivers/input/lirc/commandir.c
 create mode 100644 drivers/input/lirc/commandir.h
 create mode 100644 drivers/input/lirc/lirc.h
 create mode 100644 drivers/input/lirc/lirc_atiusb.c
 create mode 100644 drivers/input/lirc/lirc_bt829.c
 create mode 100644 drivers/input/lirc/lirc_cmdir.c
 create mode 100644 drivers/input/lirc/lirc_cmdir.h
 create mode 100644 drivers/input/lirc/lirc_dev.c
 create mode 100644 drivers/input/lirc/lirc_dev.h
 create mode 100644 drivers/input/lirc/lirc_i2c.c
 create mode 100644 drivers/input/lirc/lirc_igorplugusb.c
 create mode 100644 drivers/input/lirc/lirc_imon.c
 create mode 100644 drivers/input/lirc/lirc_it87.c
 create mode 100644 drivers/input/lirc/lirc_it87.h
 create mode 100644 drivers/input/lirc/lirc_ite8709.c
 create mode 100644 drivers/input/lirc/lirc_mceusb.c
 create mode 100644 drivers/input/lirc/lirc_mceusb2.c
 create mode 100644 drivers/input/lirc/lirc_parallel.c
 create mode 100644 drivers/input/lirc/lirc_parallel.h
 create mode 100644 drivers/input/lirc/lirc_sasem.c
 create mode 100644 drivers/input/lirc/lirc_serial.c
 create mode 100644 drivers/input/lirc/lirc_sir.c
 create mode 100644 drivers/input/lirc/lirc_streamzap.c
 create mode 100644 drivers/input/lirc/lirc_ttusbir.c
 create mode 100644 drivers/input/lirc/lirc_zilog.c
