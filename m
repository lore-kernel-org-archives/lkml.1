Return-Path: <linux-kernel-owner+w=401wt.eu-S1761260AbYBANnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260AbYBANnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbYBANmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:42:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42788 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbYBANmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:42:43 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       isdn4linux@listserv.isdn4linux.de
Cc: Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <kkeil@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] isdn: fix section mismatch warning in hfc_sx.c
Date: Fri,  1 Feb 2008 14:42:44 +0100
Message-Id: <1201873364-13475-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080201133838.GA13349@uranus.ravnborg.org>
References: <20080201133838.GA13349@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:
WARNING: drivers/isdn/hisax/built-in.o(.text+0x35818): Section mismatch in reference from the function hfcsx_card_msg() to the function .devinit.text:inithfcsx()

hfcsx_card_msg() may be called outside __devinit context.
Following the program logic is looks like the CARD_INIT branch
will only be taken under __devinit context but to be consistent
remove the __devinit annotation of inithfcsx() so we
do not mix non-__devinit and __devinit code.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/isdn/hisax/hfc_sx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/hfc_sx.c b/drivers/isdn/hisax/hfc_sx.c
index 4fd09d2..05482d2 100644
--- a/drivers/isdn/hisax/hfc_sx.c
+++ b/drivers/isdn/hisax/hfc_sx.c
@@ -1330,8 +1330,7 @@ hfcsx_bh(struct work_struct *work)
 /********************************/
 /* called for card init message */
 /********************************/
-static void __devinit
-inithfcsx(struct IsdnCardState *cs)
+static void inithfcsx(struct IsdnCardState *cs)
 {
 	cs->setstack_d = setstack_hfcsx;
 	cs->BC_Send_Data = &hfcsx_send_data;
-- 
1.5.4.rc3.14.g44397

