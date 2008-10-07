Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbYJGScO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbYJGScO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbYJGSbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:31:06 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3147 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbYJGSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:31:04 -0400
Date: Tue, 7 Oct 2008 20:26:15 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: petkovbb@gmail.com, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Gadi Oxman <gadio@netvision.net.il>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch][repost] ide-tape build fix
Message-ID: <20081007182615.GA2400@localhost>
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923074845.GB5656@gollum.tnic> <20080923165914.GA7803@localhost> <9ea470500809231011p5ea37fc4u71eeeddf6ccec45a@mail.gmail.com> <20080923212018.GA3348@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923212018.GA3348@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I never got a reaction on this patch, but please apply it.

In order to compile the kernel with IDETAPE_DEBUG_LOG enabled I had to
apply the following build fix.

Signed-off-by: Mark de Wever <koraq@xs4all.nl>

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3833189..7258eca 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -978,9 +978,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct request *postponed_rq = tape->postponed_rq;
 	u8 stat;
 
-	debug_log(DBG_SENSE, "sector: %ld, nr_sectors: %ld,"
+	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %ld,"
 			" current_nr_sectors: %d\n",
-			rq->sector, rq->nr_sectors, rq->current_nr_sectors);
+			(unsigned long long)rq->sector, rq->nr_sectors, 
+			rq->current_nr_sectors);
 
 	if (!blk_special_request(rq)) {
 		/* We do not support buffer cache originated requests. */

Regards,
Mark de Wever
