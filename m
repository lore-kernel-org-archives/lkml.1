Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZBTRKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZBTRKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZBTRJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:09:48 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:36537 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbZBTRJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=eEEMH6oolGCqU292M4oyG85u/KvK0GNPDDYzk1ZCFgVWKANlpW/acW7++A0DkEVHDO
         8701vIFkaBpYiwDCZ9BWNYgHIVIezYOEJ0oqe7U9vzmZBSf93S+LRDJxRdVQ+6i0HNEv
         DaUQO0e/csUipMayEykS1xGDCr29GLuFu+vgc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:11:39 +0100
Message-Id: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/10] ide: DMA methods cleanups/sanitizations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sanitizations of DMA methods and related cleanups (~100 LOC gone)...

[ on top of pata-2.6 tree + http://lkml.org/lkml/2009/2/18/257 ]

diffstat:
 drivers/ide/alim15x3.c     |   10 ++--
 drivers/ide/au1xxx-ide.c   |   17 ------
 drivers/ide/cmd64x.c       |    6 --
 drivers/ide/cs5536.c       |    1 
 drivers/ide/hpt366.c       |   10 ----
 drivers/ide/icside.c       |    8 ---
 drivers/ide/ide-atapi.c    |   31 +++++-------
 drivers/ide/ide-cd.c       |    4 +
 drivers/ide/ide-dma-sff.c  |   10 ----
 drivers/ide/ide-dma.c      |  112 +++++++++++++++++++++++++--------------------
 drivers/ide/ide-taskfile.c |    4 -
 drivers/ide/it821x.c       |    3 -
 drivers/ide/ns87415.c      |   28 ++++-------
 drivers/ide/pdc202xx_old.c |   10 ----
 drivers/ide/pmac.c         |   12 ----
 drivers/ide/sc1200.c       |    4 -
 drivers/ide/scc_pata.c     |   10 ----
 drivers/ide/sgiioc4.c      |   19 ++-----
 drivers/ide/siimage.c      |    1 
 drivers/ide/sl82c105.c     |    7 +-
 drivers/ide/tc86c001.c     |    1 
 drivers/ide/trm290.c       |   41 +++++++---------
 drivers/ide/tx4939ide.c    |   15 ------
 include/linux/ide.h        |   15 +++---
 24 files changed, 144 insertions(+), 235 deletions(-)
