Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYFLGoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYFLGoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYFLGl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:8605 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYFLGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=xoRduglAo4b2z+uMH2fWjIivpKN3O7BGp1oOyEuc8vqmhtycHxZnT8xLjNxSCtPP4M
         T6B/VaIqEcLkdehb7hxKqEChVfeaykgl4k9sIo9PlGnwHxtVP1KXexlb19VHysiUYI0G
         yyt9H2fJCQlnr4NrkAzlXVmFw0O2QrFOOcyo8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 15/18] ide-floppy: zero out the whole struct ide_atapi_pc on init
Date: Thu, 12 Jun 2008 08:41:07 +0200
Message-Id: <1213252870-20474-16-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a precaution just to make sure a new pc is clean when allocd. There
should be functional change introduced by this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 615d3a3..8ce7513 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -355,9 +355,8 @@ static void idefloppy_init_pc(struct ide_atapi_pc *pc, unsigned char *cmd)
 	if (cmd)
 		memset(cmd, 0, 12);
 
-	pc->retries = 0;
-	pc->flags = 0;
-	pc->req_xfer = 0;
+	memset(pc, 0, sizeof(*pc));
+
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
 	pc->callback = ide_floppy_callback;
-- 
1.5.5.1

