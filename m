Return-Path: <linux-kernel-owner+w=401wt.eu-S1764802AbXJRRsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764802AbXJRRsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbXJRRsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:48:31 -0400
Received: from ns.suse.de ([195.135.220.2]:37898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbXJRRsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:48:30 -0400
Date: Thu, 18 Oct 2007 19:48:28 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] [ISDN]Fix random hard freeze with AVM c4 card part 2
Message-ID: <20071018174828.GA12773@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One call was missing in the previous patch.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/avm/c4.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/avm/c4.c b/drivers/isdn/hardware/avm/c4.c
index 4c6ef91..d69c05e 100644
--- a/drivers/isdn/hardware/avm/c4.c
+++ b/drivers/isdn/hardware/avm/c4.c
@@ -678,7 +678,9 @@ static irqreturn_t c4_handle_interrupt(avmcard *card)
                 for (i=0; i < card->nr_controllers; i++) {
 			avmctrl_info *cinfo = &card->ctrlinfo[i];
 			memset(cinfo->version, 0, sizeof(cinfo->version));
+			spin_lock_irqsave(&card->lock, flags);
 			capilib_release(&cinfo->ncci_head);
+			spin_unlock_irqrestore(&card->lock, flags);
 			capi_ctr_reseted(&cinfo->capi_ctrl);
 		}
 		card->nlogcontr = 0;

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
