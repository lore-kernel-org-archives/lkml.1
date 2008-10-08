Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYJHUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYJHUbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbYJHUbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:31:08 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:26067 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYJHUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=NG4gpZjmkEYvpAnN0/hHCIDkgbIlxfTYrYZHFAoFlbet7af2QQN0fCWXcsbr3jtlfD
         u3KoUQyjXfjaKrUCrrFTOvetfkshOIrduGKWrvJ9BqAjYsRFH9Wr5sxY6ZEwDFr4zRDz
         /0VB1YbshwEuVcfWBvOAKXzFfsWbuNemLsP24=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2008 22:29:30 +0200
Message-Id: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/7] ide: locking improvements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Locking improvements in preparation for replacing the global ide_lock
spinlock by per-hwgroup spinlocks [1].

[1] patch (which is partially based on 2005 patch from Scalex86) for this
is also ready but it needs some more audit and testing

diffstat:
 drivers/ide/ide-cd.c     |   38 ++++++-------
 drivers/ide/ide-io.c     |  129 ++++++++++++++++++++---------------------------
 drivers/ide/ide-ioctls.c |    3 -
 drivers/ide/ide-lib.c    |    7 --
 drivers/ide/ide-proc.c   |   25 +--------
 drivers/ide/ide.c        |    7 --
 6 files changed, 80 insertions(+), 129 deletions(-)
