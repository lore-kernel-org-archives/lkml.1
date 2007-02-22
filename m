Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXBVQnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXBVQnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXBVQnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:43:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:34480 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbXBVQm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=E0mYmm7bSFMdulsVWlR98DR+kmQok4fZP5IExGfhxBUh6GKsRJZ2z1woPTMoL5dFiRtlbjtP1n1bRBbvl/xfzQHeatb7ECzZulOBVL8lkVadueL+3LzFCSynTz6zXYPAbfkmOS01ij30nsvUC7yj+Vw2p7MnE4j9cPNzPesBmdk=
Message-ID: <45DDC7F7.6080205@googlemail.com>
Date: Thu, 22 Feb 2007 17:42:31 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH -mm] mmc build fix (was: Re: mm snapshot broken-out-2007-02-21-22-18.tar.gz
 uploaded)
References: <200702220619.l1M6JsG7006504@shell0.pdx.osdl.net>
In-Reply-To: <200702220619.l1M6JsG7006504@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-02-21-22-18.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-21-22-18.tar.gz
> 
> It contains the following patches against 2.6.21-rc1:
> 

Possible build fix for

drivers/built-in.o: In function `mmc_queue_thread':
/mnt/md0/devel/linux-work5/drivers/mmc/card/queue.c:76: undefined reference to `blk_queue_plugged'
make: *** [.tmp_vmlinux1] Error 1

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work5-clean/drivers/mmc/card/queue.c	2007-02-22 16:04:38.000000000 +0100
+++ linux-work5/drivers/mmc/card/queue.c	2007-02-22 16:00:52.000000000 +0100
@@ -73,8 +73,7 @@ static int mmc_queue_thread(void *d)

 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (!blk_queue_plugged(q))
-			req = elv_next_request(q);
+		req = elv_next_request(q);
 		mq->req = req;
 		spin_unlock_irq(q->queue_lock);
