Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYBTTeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYBTTeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbYBTTd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:33:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:53039 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbYBTTdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:33:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] kgdb: fixes and ARCH=arm support
Date: Wed, 20 Feb 2008 13:33:37 -0600
Message-Id: <1203536020-20102-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 20 Feb 2008 19:33:40.0906 (UTC) FILETIME=[7F3FC0A0:01C873F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 more patches against the kgdb-light.  Porting kgdb-light to
another arch has found 2 regressions, which are fixed in the first patch.

The second patch adds hooks for an additional kgdboc uart driver which
was required to complete the testing with real hardware.

The third patch adds the ARCH=arm support for kgdb-light.

For initial merge of kgdb-light targeted at 2.6.26, the first patch in
this series is required.  The other patches are there for further
community review and to show the effort of integrating kgdb into
another arch with the API provided in the kgdb-light patch series.

Jason.

The following changes since commit 4ce04a959ef2ba9338217966013b832ff0ff9003:
  Jason Wessel (1):
        kgdb-light-v10: x86 HW breakpoints

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_ingo

Jason Wessel (3):
      kgdb: fix optional arch functions and probe_kernel_*
      kgdb: kgdboc pl011 I/O module
      kgdb: support for ARCH=arm

 arch/arm/Kconfig            |    1 +
 arch/arm/kernel/Makefile    |    1 +
 arch/arm/kernel/kgdb.c      |  219 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c     |    5 +
 arch/arm/kernel/traps.c     |   11 ++
 drivers/serial/amba-pl011.c |   30 ++++++
 include/asm-arm/kgdb.h      |  101 ++++++++++++++++++++
 include/asm-arm/traps.h     |    2 +
 kernel/kgdb.c               |   11 ++
 mm/maccess.c                |    6 +
 10 files changed, 387 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/kernel/kgdb.c
 create mode 100644 include/asm-arm/kgdb.h
