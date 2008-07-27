Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYG0S6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYG0S6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYG0S6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:58:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:45802 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYG0S6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=cTW+ubRbqPA3vg8qIU5LaG/4qUB3fFu88JEMBR1lSA1O7Sbt8pWwSanqPQFluTFJPB
         r/IlpecymCkqmFWaR2fbkqxyU8Kp1FaHnhAwes52XzmjktSh+KvpK4GwWcuxVSzoMkPT
         pgN9FN6OJSlDZ6KMow+lrJD9jGd/o2XNk0rVo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Elias Oltmanns <eo@nebensachen.de>
Date: Sun, 27 Jul 2008 20:56:02 +0200
Message-Id: <20080727185602.4660.66530.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/3] ide: /proc/ide/hd*/settings rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I finally dusted off /proc/ide/hd*/settings rework (this has been laying
on my hdd and waiting for the better days for at least 1.5 year, draft
version even longer like ~3 years... sigh).

The main motivation for doing it is that with infrastructure for private
IDE subsystem requests from Elias Oltmanns (which was merged recently)
and this patchset it should be possible (by using private requests for
device settings) to make IDE locking code a lot saner and get rid of
of ide_spin_wait_hwgroup()-ugliness completely.

Elias if you would like to take care of it please go ahead [ from a quick
look it seems this would mostly require adding new request type, pointing
rq->special to setting's ->get or ->set method and putting setting's type
(read/write -> 1 bit) + argument (int) somewhere inside request but you
probably know better ].

Patches #1-2 are a preparatory cleanups, the main rework is in patch #3.

diffstat:
 drivers/ide/ide-cd.c     |   20 +--
 drivers/ide/ide-disk.c   |   94 ++++++++-------
 drivers/ide/ide-floppy.c |   39 ++++--
 drivers/ide/ide-probe.c  |    2
 drivers/ide/ide-proc.c   |  285 ++++++++++++++---------------------------------
 drivers/ide/ide-tape.c   |   77 ++++++++----
 drivers/ide/ide.c        |   25 ++--
 drivers/scsi/ide-scsi.c  |   54 ++++++--
 include/linux/ide.h      |  112 ++++++++++++------
 9 files changed, 356 insertions(+), 352 deletions(-)
