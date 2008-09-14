Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbYINLga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbYINLga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYINLgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:4760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYINLgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=CUWYEv6rc5LyBpq7Si2n1lus4vWS4wzeQo1XxjQUrOHi8TTUHaQCfmIEXFa5oofWGt
         c6Bu7F3tlcgGLacGeFV9pzspy/vDV+/U+cShXHcqW3NhjYYb5KQGLHcST6Sd7fFLKZvq
         +cjVi2AiAHrocel3YQh4GWaboXlsYvYGu8YL8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 00/10] ide-cd: use generic ide_issue_pc
Date: Sun, 14 Sep 2008 13:35:48 +0200
Message-Id: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are some patches converting ide-cd to using ide_issue_pc. Next is
replacing cdrom_transfer_packet_command with ide_transfer_pc.

 drivers/ide/ide-atapi.c  |   71 ++++++++++++++++++++++---------
 drivers/ide/ide-cd.c     |  104 ++++++---------------------------------------
 drivers/ide/ide-cd.h     |   30 +++++++++++++-
 drivers/ide/ide-floppy.c |    2 +-
 drivers/ide/ide-tape.c   |    2 +-
 drivers/scsi/ide-scsi.c  |    3 +-
 include/linux/ide.h      |    5 ++-
 7 files changed, 102 insertions(+), 115 deletions(-)
