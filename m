Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZBIXSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZBIXSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZBIXSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:18:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:23002 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZBIXSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:18:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=v5L0JRDw2dxj9A/J2RSdx3g39hM6yL1wBwUBhw8HQKWOH6bONWmJlt5BoxT7khqfv4
         We9GryjOIKQbLP8Kg79phNF9lMUPmJsNiVv56q2Flqe+LecBH6salaQ8bWhTYUzXelDc
         6llIumfbfsgkB+kxJoLsqhW+bJNOoIua3RPp4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 00:19:45 +0100
Message-Id: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/6] ide: more unifications of ATA and ATAPI support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After this patchset we have a valid struct ide_cmd available also for
ATA_CMD_PACKET commands and comparing struct ide_atapi_pc with ide_cmd it
seems that there are many similarities between them and that we may just
merge both structs (this should also allow us to unify ide-cd code with
non-ide-cd one in ide-atapi.c later).  From the quick look the only gotcha
is REQUEST SENSE handling, ->request_sense_pc needs to be converted to
->request_sense_cmd and we have to be careful with choosing right 'cmd'
in *_issue_pc()...

Borislav, please take a look and tell me what do you think about it
(also feel free to go ahead with patches :-)...

On top of "[PATCH 0/9] ide: unify request completion methods" patchset
[ http://lkml.org/lkml/2009/2/9/398 ].

diffstat:
 drivers/ide/alim15x3.c     |    9 ++---
 drivers/ide/au1xxx-ide.c   |   23 +++----------
 drivers/ide/cmd64x.c       |    6 +--
 drivers/ide/cs5536.c       |    2 -
 drivers/ide/hpt366.c       |    6 +--
 drivers/ide/icside.c       |   14 +-------
 drivers/ide/ide-atapi.c    |   77 +++++++++++++++++++++------------------------
 drivers/ide/ide-cd.c       |   14 +++++++-
 drivers/ide/ide-disk.c     |   14 ++++----
 drivers/ide/ide-dma-sff.c  |   33 +++++++------------
 drivers/ide/ide-dma.c      |   16 ++++-----
 drivers/ide/ide-eh.c       |    9 ++---
 drivers/ide/ide-floppy.c   |   32 +++++++++++-------
 drivers/ide/ide-io.c       |   14 ++++----
 drivers/ide/ide-iops.c     |   42 ++++++++----------------
 drivers/ide/ide-tape.c     |   19 ++++++++---
 drivers/ide/ide-taskfile.c |   57 ++++++++++++++++-----------------
 drivers/ide/it821x.c       |    2 -
 drivers/ide/ns87415.c      |    6 +--
 drivers/ide/pdc202xx_old.c |    4 +-
 drivers/ide/pmac.c         |   27 ++++-----------
 drivers/ide/sc1200.c       |    2 -
 drivers/ide/scc_pata.c     |   21 ++++--------
 drivers/ide/sgiioc4.c      |   21 ++++--------
 drivers/ide/siimage.c      |    2 -
 drivers/ide/sl82c105.c     |    2 -
 drivers/ide/tc86c001.c     |    2 -
 drivers/ide/trm290.c       |   16 ++-------
 drivers/ide/tx4939ide.c    |   28 ++++++----------
 include/linux/ide.h        |   36 +++++++++------------
 30 files changed, 251 insertions(+), 305 deletions(-)
