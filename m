Return-Path: <linux-kernel-owner+w=401wt.eu-S1761132AbZEOFMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132AbZEOFMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZEOFLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:11:43 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:58540 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZEOFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RKbo4uM272hQfhADV7WgB+KmXBlTwedDWj8xTnci2fl4R+5DoBJ9zePEQpP23x29Ru
         65jHcEkzPGqkepzRrpaAe+oxSj82MoSJQckDasIg/hQ9izAusoCISv+KK1dXjt3ifPlG
         N/5sp9OuNr1Bz+l9Jp4jka+cGcr5MgLTk7TG8=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/15 v2] ide-atapi: remove pc->buf and misc cleanups
Date: Fri, 15 May 2009 07:11:18 +0200
Message-Id: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the newest respin of the current patchset with all issues from
the previous review round fixed:

- 0003: fixed checkpatch issues

- 0005: documented additional change in the commit message

- 0009: converted to using bio_data() helper; pushed pc->buf removal to #12;
	moved unrelated changes to 0010

- 0014: updated/fixed checkpatch issues

It also got rebased ontop of block/for-2.6.31 after Tejun's stuff got merged.


Changelog:
- v1:

Among the changes is a first attempt to remove the 64 byte buffer
embedded in each packet command sent to an ide drive. Also, some ireason
handling unification is there along with other minor stuff.

This is based ontop of

git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git for-2.6.31

and is at

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git remove-pc-buf

 drivers/ide/ide-atapi.c        |  138 ++++++++++++++++++++------------
 drivers/ide/ide-cd.c           |   68 +++-------------
 drivers/ide/ide-floppy.c       |   50 +++++-------
 drivers/ide/ide-floppy_ioctl.c |   43 ++++++-----
 drivers/ide/ide-tape.c         |  172 +++++++++++++++++++---------------------
 include/linux/ide.h            |   18 +---
 6 files changed, 229 insertions(+), 260 deletions(-)

--
Thanks,
Boris.



