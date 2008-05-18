Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYERShV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYERShV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYERShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:37:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbYERShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=cKAauD2VKO3ALH9Eh0tLsVVZIxZSBHFeiFbwqUwWl2WTdwSlzdLZVu99EcT7wOENNwOzF5QIowNgpStjDepZn5j5FzTlaZNnGG4h0pAtjW97ciyEKK06mujm35JvErg4ZDphfVt1r8LrhXSq2SOXt1O7qs8BqbyjszzJtKtOXwg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:54:28 +0200
Message-Id: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/40] ide: generic ATAPI support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patch series unifies ATAPI support present in ide-{floppy,tape,scsi}
device drivers and moves it out to the core IDE code (new ide-atapi.c file).

In the process many bugs were shaken out and ~300 LOC were removed.

diffstat:

 drivers/ide/Kconfig      |    6 
 drivers/ide/Makefile     |    1 
 drivers/ide/ide-atapi.c  |  296 ++++++++++++++++++++++
 drivers/ide/ide-cd.c     |    5 
 drivers/ide/ide-floppy.c |  431 +++++++-------------------------
 drivers/ide/ide-tape.c   |  630 ++++++++++++++---------------------------------
 drivers/scsi/ide-scsi.c  |  455 +++++++++++----------------------
 include/linux/ide.h      |   28 +-
 8 files changed, 777 insertions(+), 1075 deletions(-)

Now, while this is a big step in the right direction there are still some
things left on TODO for generic ATAPI support to be complete:

- convert ide-cd to use generic ATAPI code

- kill pc and rq stacks in ide-{floppy,tape}

- generic handling of REQUEST SENSE command

- generic handling of MODE SENSE command for ide-{floppy,tape}

- convert ide-{cd,floppy,tape} to use scatterlists for PIO transers
  (ala ide-scsi)

I know that Borislav is working on the first two items but other ones
are free at the moment so if you feel brave you may give it a try :-).

PS I'll be travelling during this weekend and be rather busy with day job
   so replies from me may be delayed a bit.

Thanks,
Bart
