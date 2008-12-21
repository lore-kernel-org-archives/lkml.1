Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYLUVA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYLUVA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYLUVAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:00:19 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34166 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYLUVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=d9rsBB3HBRV+2lD2SWGz16LoayGuLKyNsWmJ/HOBH4ECXbdyJ4TDfVi/4vmV22JJI/
         7zoRU2vUWdFswHzlmHEfcjd6iBAf7r+e+CjdV+kUU4ABw2rb0q2H/rcAmYSoOmiZj7bM
         lyMBbnoblc1Jip3aMsg/6+feAt1F0UbfjHHus=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2008 22:00:15 +0100
Message-Id: <20081221210015.23795.25127.sendpatchset@localhost.localdomain>
In-Reply-To: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
References: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/7] cmd640: use ide_get_pair_dev() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cmd640: use ide_get_pair_dev() helper

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cmd640.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -467,11 +467,10 @@ static void program_drive_counts(ide_dri
 	 * so we merge the timings, using the slowest value for each timing.
 	 */
 	if (index > 1) {
-		ide_hwif_t *hwif = drive->hwif;
-		ide_drive_t *peer = &hwif->drives[!(drive->dn & 1)];
+		ide_drive_t *peer = ide_get_pair_dev(drive);
 		unsigned int mate = index ^ 1;
 
-		if (peer->dev_flags & IDE_DFLAG_PRESENT) {
+		if (peer) {
 			if (setup_count < setup_counts[mate])
 				setup_count = setup_counts[mate];
 			if (active_count < active_counts[mate])
