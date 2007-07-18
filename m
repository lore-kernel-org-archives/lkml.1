Return-Path: <linux-kernel-owner+w=401wt.eu-S936915AbXGSAG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936915AbXGSAG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763387AbXGSAGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:06:07 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46477 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762157AbXGSAGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:06:06 -0400
Date: Wed, 18 Jul 2007 19:55:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: [git patch] ISDN code movement fix
Message-ID: <20070718235549.GA9638@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'isdn-fix' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git isdn-fix

to receive the following updates:

 drivers/isdn/hisax/config.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

Florin Malita (1):
      ISDN HiSax: uninitialized return in hisax_cs_setup

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 5f7907e..97097ef 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1146,14 +1146,12 @@ static int hisax_cs_setup(int cardnr, struct IsdnCard *card,
 	}
 	if (ret) {
 		closecard(cardnr);
-		ret = 0;
 		goto outf_cs;
 	}
 	init_tei(cs, cs->protocol);
 	ret = CallcNewChan(cs);
 	if (ret) {
 		closecard(cardnr);
-		ret = 0;
 		goto outf_cs;
 	}
 	/* ISAR needs firmware download first */
@@ -1165,7 +1163,7 @@ static int hisax_cs_setup(int cardnr, struct IsdnCard *card,
 outf_cs:
 	kfree(cs);
 	card->cs = NULL;
-	return ret;
+	return 0;
 }
 
 static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
