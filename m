Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZFPIpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZFPIpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZFPIo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:44:57 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:52100 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZFPIo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:44:56 -0400
Date: Tue, 16 Jun 2009 10:44:55 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] power management support for s390
Message-ID: <20090616104455.5f4a852a@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the power management support for s390:

Christian Borntraeger (1):
      [S390] pm: vmwatchdog power management callbacks.

Cornelia Huck (2):
      [S390] pm: io subchannel driver power management callbacks
      [S390] pm: chsc subchannel driver power management callbacks

Frank Blaschka (3):
      [S390] pm: qeth driver power management callbacks
      [S390] pm: ctcm driver power management callbacks
      [S390] pm: claw driver power management callbacks

Frank Munzert (2):
      [S390] pm: vmur driver power management callbacks
      [S390] pm: tape power management callbacks

Gerald Schaefer (5):
      [S390] pm: appldata power management callbacks
      [S390] pm: memory hotplug power management callbacks
      [S390] pm: monwriter power management callbacks.
      [S390] pm: monreader power management callbacks.
      [S390] pm: dcssblk power management callbacks.

Hans-Joachim Picht (2):
      [S390] pm: add kernel_page_present
      [S390] s390: hibernation support for s390

Hendrik Brueckner (1):
      [S390] pm: hvc_iucv power management callbacks

Klaus-Dieter Wacket (1):
      [S390] pm: lcs driver power management callbacks

Martin Petermann (1):
      [S390] pm: zfcp driver power management callbacks

Martin Schwidefsky (4):
      [S390] cio: force console function
      [S390] pm: con3215 power management callbacks
      [S390] pm: smsgiucv power management callbacks.
      [S390] pm: con3270 power management callbacks.

Michael Holzheu (2):
      [S390] pm: xpram driver power management callbacks
      [S390] pm: power management support for SCLP drivers.

Sebastian Ott (3):
      [S390] pm: ccw bus power management callbacks
      [S390] pm: ccwgroup bus power management callbacks
      [S390] pm: css bus power management callbacks

Stefan Haberland (1):
      [S390] pm: dasd power management callbacks.

Stefan Weinhuber (1):
      [S390] pm: vmlogrdr power management callbacks

Ursula Braun (4):
      [S390] iucv: establish reboot notifier
      [S390] pm: iucv power management callbacks.
      [S390] pm: netiucv power management callbacks.
      [S390] PM: af_iucv power management callbacks.

 arch/s390/Kconfig                  |    9 ++
 arch/s390/Makefile                 |    4 +-
 arch/s390/appldata/appldata_base.c |  119 +++++++++++++++-
 arch/s390/include/asm/ccwdev.h     |   19 ++-
 arch/s390/include/asm/ccwgroup.h   |   10 ++
 arch/s390/include/asm/suspend.h    |   10 ++
 arch/s390/include/asm/system.h     |   22 ++-
 arch/s390/kernel/early.c           |    6 +-
 arch/s390/kernel/mem_detect.c      |   19 +--
 arch/s390/kernel/smp.c             |   38 +++++-
 arch/s390/mm/pgtable.c             |   19 +++
 arch/s390/power/Makefile           |    8 +
 arch/s390/power/suspend.c          |   40 ++++++
 arch/s390/power/swsusp.c           |   30 ++++
 arch/s390/power/swsusp_64.c        |   17 +++
 arch/s390/power/swsusp_asm64.S     |  199 ++++++++++++++++++++++++++
 drivers/char/hvc_iucv.c            |  204 +++++++++++++++++++++------
 drivers/s390/block/dasd.c          |  109 ++++++++++++++-
 drivers/s390/block/dasd_devmap.c   |    1 +
 drivers/s390/block/dasd_eckd.c     |  108 +++++++++++++--
 drivers/s390/block/dasd_fba.c      |    6 +-
 drivers/s390/block/dasd_int.h      |   13 ++-
 drivers/s390/block/dcssblk.c       |  132 +++++++++++++++---
 drivers/s390/block/xpram.c         |  129 +++++++++++++++++-
 drivers/s390/char/con3215.c        |  205 ++++++++++++++++------------
 drivers/s390/char/con3270.c        |   12 +-
 drivers/s390/char/fs3270.c         |   16 ++-
 drivers/s390/char/monreader.c      |  140 +++++++++++++++++--
 drivers/s390/char/monwriter.c      |   98 ++++++++++++-
 drivers/s390/char/raw3270.c        |   84 ++++++++++--
 drivers/s390/char/raw3270.h        |   12 +-
 drivers/s390/char/sclp.c           |  248 +++++++++++++++++++++++++++++----
 drivers/s390/char/sclp.h           |   23 +++-
 drivers/s390/char/sclp_cmd.c       |   42 +++++-
 drivers/s390/char/sclp_con.c       |  139 +++++++++++++------
 drivers/s390/char/sclp_rw.c        |   20 ++-
 drivers/s390/char/sclp_rw.h        |   12 +-
 drivers/s390/char/sclp_vt220.c     |  118 +++++++++++-----
 drivers/s390/char/tape.h           |    3 +-
 drivers/s390/char/tape_34xx.c      |    3 +-
 drivers/s390/char/tape_3590.c      |    3 +-
 drivers/s390/char/tape_core.c      |   52 +++++++-
 drivers/s390/char/vmlogrdr.c       |   27 ++++-
 drivers/s390/char/vmur.c           |   26 ++++-
 drivers/s390/char/vmwatchdog.c     |   81 ++++++++++-
 drivers/s390/cio/ccwgroup.c        |   78 ++++++++++-
 drivers/s390/cio/chsc.c            |    3 +-
 drivers/s390/cio/chsc.h            |    1 +
 drivers/s390/cio/chsc_sch.c        |   32 ++++-
 drivers/s390/cio/cmf.c             |    5 +
 drivers/s390/cio/css.c             |  157 ++++++++++++++++++++-
 drivers/s390/cio/css.h             |   10 ++
 drivers/s390/cio/device.c          |  260 ++++++++++++++++++++++++++++++++++
 drivers/s390/cio/device.h          |    3 +
 drivers/s390/cio/device_fsm.c      |   96 ++++++-------
 drivers/s390/cio/device_ops.c      |   26 +++-
 drivers/s390/cio/io_sch.h          |    1 +
 drivers/s390/net/claw.c            |   14 ++-
 drivers/s390/net/ctcm_main.c       |   37 +++++-
 drivers/s390/net/lcs.c             |   74 +++++++++--
 drivers/s390/net/netiucv.c         |  115 +++++++++++++++-
 drivers/s390/net/qeth_core_main.c  |   51 +++++++-
 drivers/s390/net/qeth_l2_main.c    |   52 +++++++-
 drivers/s390/net/qeth_l3_main.c    |   52 +++++++-
 drivers/s390/net/smsgiucv.c        |   63 ++++++++-
 drivers/s390/scsi/zfcp_ccw.c       |   33 +++++
 mm/Kconfig                         |    4 +-
 net/iucv/af_iucv.c                 |  147 +++++++++++++++++++-
 net/iucv/iucv.c                    |  268 +++++++++++++++++++++++++++++++++++-
 69 files changed, 3718 insertions(+), 499 deletions(-)
 create mode 100644 arch/s390/include/asm/suspend.h
 create mode 100644 arch/s390/power/Makefile
 create mode 100644 arch/s390/power/suspend.c
 create mode 100644 arch/s390/power/swsusp.c
 create mode 100644 arch/s390/power/swsusp_64.c
 create mode 100644 arch/s390/power/swsusp_asm64.S

