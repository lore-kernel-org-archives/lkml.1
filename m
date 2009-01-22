Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZAVORp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZAVORp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZAVORd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:17:33 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:58120 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZAVORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=KIFYb4QqzZnbMY/79ZFd4KblYFGC8Sr4jsNZMq5NDHTKcsI4v/ocBuBoVWM6ZgjpbP
         G4j7Qjf2l5H70cA0MvrYolNAtyk9rrYjnU5mV1eP97JSOVdNnAshktzmMp1TNd3WVry4
         no7O4dkqV6SPO1Fh0yKInnux6McCirsdzOHRc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2009 15:18:01 +0100
Message-Id: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/8] ide: unify code for reading device identify data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Transform try_to_identify() into globally usable ide_dev_read_id() and update
ide_driveid_update() to use it instead of duplicating the functionality.  Also
remove broken/dead EXABYTENEST handling while at it.

Based on top of pata-2.6 tree.

diffstat:
 drivers/ide/ide-iops.c  |  118 +++++++++++++++++++-----------------------------
 drivers/ide/ide-probe.c |   87 ++++++++++-------------------------
 include/linux/ata.h     |    2 
 include/linux/ide.h     |    2 
 4 files changed, 75 insertions(+), 134 deletions(-)
