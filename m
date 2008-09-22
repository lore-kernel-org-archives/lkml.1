Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYIVUnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYIVUnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYIVUnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:43:43 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1622 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYIVUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:43:42 -0400
Date: Mon, 22 Sep 2008 22:41:29 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: petkovbb@gmail.com
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Message-ID: <20080922204129.GA3495@localhost>
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 03:56:49PM +0200, Boris Petkov wrote:
> On Mon, Sep 22, 2008 at 3:16 PM, Sergei Shtylyov
> <sshtylyov@ru.mvista.com> wrote:
> > Hello.
> >
> .. and I know why :). Those ide_tape_obj members (char fw_rev[6], vendor_id[10],
> product_id[18]) were used only once in idetape_get_inquiry_results() so I moved
> them there as local stack variables. Originally, they were kzalloc'ed as part of
> struct ide_tape_obj and now they contain stack garbage therefore the funny
> values. The simple solution would be to zero them out or:
> 
> 
> Does the following patch help?

Yes feel free to add my tested-by.

Only not sure whether the static is the best solution, the following
patch also works, by zeroing the memory as you suggested.

Signed-off-by: Mark de Wever <koraq@xs4all.nl>

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1bce84b..c41f5b1 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	char fw_rev[6], vendor_id[10], product_id[18];
+	char fw_rev[6] = {'\0'}, vendor_id[10] = {'\0'}, product_id[18] = {'\0'};
 
 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {

-- 
Regards,
Mark de Wever
