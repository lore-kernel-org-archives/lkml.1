Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZBIT7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZBIT7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZBIT7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:59:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43279 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004AbZBIT7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=uaSy0Mj0l2DFtcl4cTL83vJeDr8KLPDoAWp2vVfIry/0EZFHPVrCHedPbUy+fU5q7N
         RdJPPjJRGpSeHHqBBycaB8LIWKZoXGT+95D6sum6gW/ifdGAnqvbpN6h2mIwezc47Fcm
         Us5KI5WD2CqmTQflM+ydNV6sl4wuYFXFicPvY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:00:42 +0100
Message-Id: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/9] ide: unify request completion methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Unify request completion methods so we (almost) always complete requests
using ide_complete_rq().  As a nice side-effect it de-convolutes a lot of
tricky code allowing further improvements later...

On top of pata-2.6 tree.

diffstat:
 drivers/ide/ide-atapi.c    |   20 +++-
 drivers/ide/ide-cd.c       |   18 ++--
 drivers/ide/ide-devsets.c  |    4 
 drivers/ide/ide-disk.c     |    4 
 drivers/ide/ide-dma.c      |    3 
 drivers/ide/ide-eh.c       |   14 ++-
 drivers/ide/ide-floppy.c   |   10 +-
 drivers/ide/ide-io.c       |  188 ++++++++++++++++-----------------------------
 drivers/ide/ide-tape.c     |    8 +
 drivers/ide/ide-taskfile.c |   10 +-
 include/linux/ide.h        |   10 +-
 11 files changed, 130 insertions(+), 159 deletions(-)
