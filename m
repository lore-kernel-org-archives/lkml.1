Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYIGWQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYIGWQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYIGWQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:16:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:2394 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYIGWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=fiKcXF5tzwxzyJqAOkB1hv3YDIoOnidmSTIZSln4PCswhvs0pUA+6dxgPIlGUVFgq3
         Bh/9PUqm3VETVHsQ0yXkMc8v7wCL9MVW+k/yHr5juYHKb9WSOCqaGFfKgw1wgVJrz9W8
         wqx14KaR8L5iRggFI7T0ofoAJSYjggxP4nyn0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:14:24 +0200
Message-Id: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/18] ide: add generic ATA/ATAPI disk driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Borislav, this is the 'futuristic' stuff that we were talking about. :) ]

Hi,

This patch series adds a generic ATA/ATAPI disk driver (ide-gd) replacing
ide-disk and ide-floppy drivers.  It is achieved by moving the common code
to ide-gd.c, adding struct ide_disk_ops (which is used to abstract protocol
specific details) and updating ide-{disk,floppy}.c accordingly.

The main goal is to make the code more maintainable / easier to extend later.
As an immediate result we get driver specific debugging support for ATA disks
and ability for driver specific Power Management for ATAPI devices.  Otherwise
it is really an initial merge (which means that in the future the code can be
further unified, struct ide_disk_ops can be made more fine-grained etc.).

patches:
 #01-02 drive-by bugfixes
 #03-04 small improvements (good on their own)
 #05-12 small cleanups (good on their own)
 #13-17 preparatory patches (just to make the review easier)
 #18    the main patch

diffstat:
 drivers/ide/Kconfig            |   64 +--
 drivers/ide/Makefile           |   23 -
 drivers/ide/ide-atapi.c        |    2 
 drivers/ide/ide-cd.c           |   22 -
 drivers/ide/ide-cd_ioctl.c     |    8 
 drivers/ide/ide-disk.c         |  434 ++++------------------
 drivers/ide/ide-disk.h         |   35 -
 drivers/ide/ide-disk_ioctl.c   |    6 
 drivers/ide/ide-disk_proc.c    |    2 
 drivers/ide/ide-floppy.c       |  419 +++------------------
 drivers/ide/ide-floppy.h       |   79 +---
 drivers/ide/ide-floppy_ioctl.c |   15 
 drivers/ide/ide-floppy_proc.c  |    2 
 drivers/ide/ide-gd-floppy.c    |  802 ++++++++++++++++++++---------------------
 drivers/ide/ide-gd.c           |  437 +++++++++++++++++++++-
 drivers/ide/ide-gd.h           |   44 ++
 drivers/ide/ide-probe.c        |    1 
 drivers/ide/ide-proc.c         |    6 
 drivers/ide/ide-tape.c         |   16 
 drivers/leds/Kconfig           |    2 
 drivers/scsi/ide-scsi.c        |   26 -
 include/linux/ide.h            |   34 +
 22 files changed, 1209 insertions(+), 1270 deletions(-)
