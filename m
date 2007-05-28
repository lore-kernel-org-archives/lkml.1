Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbXE1XLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbXE1XLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 19:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763638AbXE1XLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 19:11:30 -0400
Received: from fed1rmmtao103.cox.net ([68.230.241.43]:36986 "EHLO
	fed1rmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763548AbXE1XL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 19:11:27 -0400
From: Junio C Hamano <junkio@cox.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 3/3] ide_in_drive_list(): "ALL" is not a wildcard anymore.
References: <20070521145042.GA6957@redhat.com>
	<7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
	<7vps4ta1iy.fsf_-_@assigned-by-dhcp.cox.net>
	<200705282141.42507.bzolnier@gmail.com>
Date: Mon, 28 May 2007 16:11:15 -0700
Message-ID: <7vsl9g7dd8.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the support to treat "ALL" as a wildcard for
firmware revision.  This is made a separate patch, as it will
break out-of-tree ide drivers that feed its own table that uses
"ALL" as the wildcard to ide_in_drive_list().

Signed-off-by: Junio C Hamano <junkio@cox.net>
---

 * This is a respin of earlier "3/3 Make ide dma blacklist handling a bit saner."

 drivers/ide/ide-dma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 230ea12..3107b5e 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -148,7 +148,6 @@ int ide_in_drive_list(struct hd_driveid *id, const struct drive_list_entry *driv
 	for ( ; drive_table->id_model ; drive_table++)
 		if ((!strcmp(drive_table->id_model, id->model)) &&
 		    (!drive_table->id_firmware ||
-		     !strcmp(drive_table->id_firmware, "ALL") || /* to be removed later */
 		     strstr(id->fw_rev, drive_table->id_firmware)))
 			return 1;
 	return 0;
-- 
1.5.2.86.g99b5-dirty


