Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752595AbYLRHlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbYLRHlm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYLRHlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:41:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57692 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYLRHlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=aCuPthOPcVQI3i2qMidKyGXuy/kDpDaQxL/XaBaItz71HcfnQrmjYOuPcr1dwR3sny
         riWYMgKL3Qoa5T9787yzmFkudWf46CxL+vTdvtWRtSM3hYp7KHEA8B2VyG3IaxJN4ITL
         llvC2kxZFttbQVH0liY02r1qvq+1UY7S/Li08=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/8] ide-cd: first conversion batch
Date: Thu, 18 Dec 2008 08:40:44 +0100
Message-Id: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's the first batch of conversion patches. Now ide_issue_pc/ide_transfer_pc
are almost completely aligned to their ide-cd counterparts
cdrom_start_packet_command/cdrom_transfer_packet_command. The only thing
missing is the setting of the irq handler through ide_set_handler but this
is not that trivial since if i'd moved ide-cd's irq handler to ide-atapi
that would suck in a bunch of other ide-cd functions which is not what we
want, (yes/no)? and I'm going to have to ponder a little bit more on that.

Those have been lightly tested with ide-cd and ide-floppy.


 drivers/ide/ide-atapi.c  |  115 ++++++++++++++++----------------------------
 drivers/ide/ide-cd.c     |  121 ++++++++++++++++++++++++++++------------------
 drivers/ide/ide-floppy.c |    2 +-
 drivers/ide/ide-tape.c   |    2 +-
 include/linux/ide.h      |    2 +-
 5 files changed, 117 insertions(+), 125 deletions(-)
