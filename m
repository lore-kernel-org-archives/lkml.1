Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZBBVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZBBVjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759301AbZBBViu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:38:50 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:47443 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287AbZBBVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:38:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=DFgqS74fmFWEERSc2gaZAjHajZR6UhuHHn3zrSMh9rqsR+gcgTxcXtXVhJBvLcepkY
         Nn7kR88pKLxV/jLFdOMyCvzJkbXfVL6kwJsdYHNtqM1AZLv8dctitWcK9kxzewx7L6rm
         HBcBk2aU641NYOKIVVOirKhTJJ7usADZj+O20=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:37:07 +0100
Message-Id: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/14] ide: ide_task_t -> struct ide_cmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sanitize structure representing ATA command and few related changes.

on top of "[PATCH 0/8] ide: remove ->end_request method" patchset
[ http://lkml.org/lkml/2009/2/1/117 ]

diffstat:
 drivers/ide/au1xxx-ide.c    |   13 -
 drivers/ide/falconide.c     |    8 
 drivers/ide/icside.c        |    8 
 drivers/ide/ide-acpi.c      |   10 
 drivers/ide/ide-atapi.c     |   61 ++--
 drivers/ide/ide-disk.c      |  169 ++++++-------
 drivers/ide/ide-disk_proc.c |   28 +-
 drivers/ide/ide-dma-sff.c   |    6 
 drivers/ide/ide-dma.c       |   30 +-
 drivers/ide/ide-eh.c        |    6 
 drivers/ide/ide-floppy.c    |    5 
 drivers/ide/ide-h8300.c     |   66 ++---
 drivers/ide/ide-io-std.c    |   66 ++---
 drivers/ide/ide-io.c        |   82 +++---
 drivers/ide/ide-ioctls.c    |   46 +--
 drivers/ide/ide-iops.c      |   30 +-
 drivers/ide/ide-lib.c       |   20 -
 drivers/ide/ide-park.c      |   25 +
 drivers/ide/ide-pm.c        |   39 +--
 drivers/ide/ide-probe.c     |   18 -
 drivers/ide/ide-proc.c      |   16 -
 drivers/ide/ide-taskfile.c  |  571 ++++++++++++++++++++------------------------
 drivers/ide/ns87415.c       |   30 +-
 drivers/ide/pmac.c          |    9 
 drivers/ide/q40ide.c        |    8 
 drivers/ide/scc_pata.c      |   66 ++---
 drivers/ide/sgiioc4.c       |   12 
 drivers/ide/tx4938ide.c     |   66 ++---
 drivers/ide/tx4939ide.c     |   81 +++---
 include/linux/ide.h         |   64 ++--
 30 files changed, 803 insertions(+), 856 deletions(-)
