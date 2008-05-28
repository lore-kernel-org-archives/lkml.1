Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYE1Vmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYE1Vmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYE1VmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:42:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:49842 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYE1VmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=B7Z7m2SsYIuPBxBDoTMuXZbMX9J3Fm29ZFcM5GkjxUIJD7y4ZWyB613U3GT+n/oksyCGh3QHYS30FlV9zx4H6Om1/Rsl1XYSdKKd0T47Wf+WPwhC2nTS4WvcTo4jL4k8WGJx2MbqSphfPQcLH0J/JlPAsPq8bv6EipfD24Ok8SU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:39:44 +0200
Message-Id: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/21] ide: convert ide-timing.h to ide-timings.c library
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This (fairly obvious/trivial) patchset converts drivers/ide/ide-timing.h
into ide-timings.c library (enabled by host drivers that want to use it by
selecting CONFIG_IDE_TIMINGS config option) and updates host drivers still
using ide_pio_timings[] to use ide_timing_find_mode() instead.

Also as a bonus it moves PIO blacklist from ide-lib.c to ide-pio-blacklist.c.

diffstat:

 drivers/ide/Kconfig             |   16 +
 drivers/ide/Makefile            |    4 
 drivers/ide/arm/palm_bk3710.c   |    2 
 drivers/ide/ide-lib.c           |  151 -----------------
 drivers/ide/ide-pio-blacklist.c |   94 +++++++++++
 drivers/ide/ide-timing.h        |  341 +++++++---------------------------------
 drivers/ide/ide-timings.c       |  201 +++++++++++++++++++++++
 drivers/ide/legacy/ali14xx.c    |    3 
 drivers/ide/legacy/ht6560b.c    |    7 
 drivers/ide/legacy/qd65xx.c     |    3 
 drivers/ide/pci/alim15x3.c      |    6 
 drivers/ide/pci/amd74xx.c       |    2 
 drivers/ide/pci/cmd640.c        |    8 
 drivers/ide/pci/cmd64x.c        |    6 
 drivers/ide/pci/cs5535.c        |    6 
 drivers/ide/pci/cy82c693.c      |    9 -
 drivers/ide/pci/opti621.c       |   10 -
 drivers/ide/pci/sis5513.c       |    3 
 drivers/ide/pci/sl82c105.c      |    3 
 drivers/ide/pci/via82cxxx.c     |    2 
 drivers/ide/ppc/mpc8xx.c        |   33 +--
 drivers/ide/ppc/pmac.c          |   15 -
 include/linux/ide.h             |   45 ++++-
 23 files changed, 461 insertions(+), 509 deletions(-)
