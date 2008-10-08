Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbYJHPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbYJHPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYJHPrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 11:47:04 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1974 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYJHPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:47:01 -0400
Date: Wed, 8 Oct 2008 17:45:52 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Gadi Oxman <gadio@netvision.net.il>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch][repost] ide-tape build fix
Message-ID: <20081008154552.GA3907@localhost>
References: <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923074845.GB5656@gollum.tnic> <20080923165914.GA7803@localhost> <9ea470500809231011p5ea37fc4u71eeeddf6ccec45a@mail.gmail.com> <20080923212018.GA3348@localhost> <20081007182615.GA2400@localhost> <20081008063352.GA13530@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008063352.GA13530@gollum.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 08:33:52AM +0200, Borislav Petkov wrote:
Hi,
> Bugger, I should be getting at least warnings when compiling this but I don't.
> This is because I don't have CONFIG_LBD enabled. However, the %ld and %d
> format specifiers are also not entirely correct but gcc doesn't warn about them
> - I guess it checks only size but not signedness...

I guess so too.

> Would you like to redo your patch and add a proper comment ontop?

Here you go.

@Boris do you want to add your Signed-off-by too?

@Bart please apply this patch.

--
Subject: ide-tape: Buildfix when IDETAPE_DEBUG_LOG is set to 1.

The format specifier for rq->sector didn't specify the proper size and
signedness. Borislav Petkov discovered that the signedness for
rq->nr_sectors and rq->current_nr_sectors also were incorrect.

Signed-off-by: Mark de Wever <koraq@xs4all.nl>
---
 drivers/ide/ide-tape.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3833189..3d5f782 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -978,9 +978,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct request *postponed_rq = tape->postponed_rq;
 	u8 stat;
 
-	debug_log(DBG_SENSE, "sector: %ld, nr_sectors: %ld,"
-			" current_nr_sectors: %d\n",
-			rq->sector, rq->nr_sectors, rq->current_nr_sectors);
+	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu,"
+			" current_nr_sectors: %u\n",
+			(unsigned long long)rq->sector, rq->nr_sectors, 
+			rq->current_nr_sectors);
 
 	if (!blk_special_request(rq)) {
 		/* We do not support buffer cache originated requests. */
-- 
1.5.6.5

Regards,
Mark de Wever
