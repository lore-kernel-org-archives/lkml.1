Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYIWVU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYIWVU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYIWVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:20:46 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1500 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYIWVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:20:45 -0400
Date: Tue, 23 Sep 2008 23:20:18 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: petkovbb@gmail.com
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: IDE-TAPE regressions [was: [PATCH] IDE-TAPE NULL terminate
	strings.]
Message-ID: <20080923212018.GA3348@localhost>
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923074845.GB5656@gollum.tnic> <20080923165914.GA7803@localhost> <9ea470500809231011p5ea37fc4u71eeeddf6ccec45a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500809231011p5ea37fc4u71eeeddf6ccec45a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 07:11:04PM +0200, Boris Petkov wrote:
> No worries and thanks. By the way, you mentioned something about other problems
> with ide-tape. FWIW, it seems you're its only user and we were about to kill it
> but decided not to yet and did the whole cleanup kinda only by compile-testing
> since almost no one (well, except you :)) has the hardware. So, feel free to
> send me any dmesg/debug/error messages you get and I'll look into them. Also,
> set IDETAPE_DEBUG_LOG to 1 before compiling for full debug info.

Thanks for not killing the driver :-) Feel free to add me to your list
of testers in case you need more testing in the future.

I already posted the problem [1] but didn't CC you since your name
wasn't listed in MAINTAINERS. I recompiled the kernel and tested again,
but the output doesn't seem to contain extra output.

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


[1] http://marc.info/?l=linux-kernel&m=122203193728465&w=2

Regards,
Mark de Wever
