Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbYBANn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbYBANn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbYBANmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:42:45 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:36785 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbYBANmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:42:43 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       isdn4linux@listserv.isdn4linux.de
Cc: Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <kkeil@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] isdn: fix section mismatch warnings in isac.c and isar.c
Date: Fri,  1 Feb 2008 14:42:43 +0100
Message-Id: <1201873364-13475-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080201133838.GA13349@uranus.ravnborg.org>
References: <20080201133838.GA13349@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings:
WARNING: drivers/isdn/hisax/built-in.o(.text+0x1b276): Section mismatch in reference from the function inithscxisac() to the function .devinit.text:clear_pending_isac_ints()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x1b286): Section mismatch in reference from the function inithscxisac() to the function .devinit.text:initisac()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x1fec7): Section mismatch in reference from the function AVM_card_msg() to the function .devinit.text:clear_pending_isac_ints()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x21669): Section mismatch in reference from the function AVM_card_msg() to the function .devinit.text:clear_pending_isac_ints()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x21671): Section mismatch in reference from the function AVM_card_msg() to the function .devinit.text:initisac()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x2991e): Section mismatch in reference from the function Sedl_card_msg() to the function .devinit.text:clear_pending_isac_ints()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x29936): Section mismatch in reference from the function Sedl_card_msg() to the function .devinit.text:initisac()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x2993e): Section mismatch in reference from the function Sedl_card_msg() to the function .devinit.text:initisar()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x2e026): Section mismatch in reference from the function NETjet_S_card_msg() to the function .devinit.text:clear_pending_isac_ints()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x2e02e): Section mismatch in reference from the function NETjet_S_card_msg() to the function .devinit.text:initisac()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x37813): Section mismatch in reference from the function BKM_card_msg() to the function .devinit.text:clear_pending_isac_ints()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x37823): Section mismatch in reference from the function BKM_card_msg() to the function .devinit.text:initisac()

initisar(), initisac() and clear_pending_isac_ints()
were all used via a cardmsg fnction - which may be called
ouside __devinit context.
So remove the bogus __devinit annotation of the
above three functions to fix the warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/isdn/hisax/isac.c |    6 ++----
 drivers/isdn/hisax/isar.c |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index 6ae9dde..07b1673 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -615,8 +615,7 @@ dbusy_timer_handler(struct IsdnCardState *cs)
 	}
 }
 
-void __devinit
-initisac(struct IsdnCardState *cs)
+void initisac(struct IsdnCardState *cs)
 {
 	cs->setstack_d = setstack_isac;
 	cs->DC_Close = DC_Close_isac;
@@ -647,8 +646,7 @@ initisac(struct IsdnCardState *cs)
 	cs->writeisac(cs, ISAC_MASK, 0x0);
 }
 
-void __devinit
-clear_pending_isac_ints(struct IsdnCardState *cs)
+void clear_pending_isac_ints(struct IsdnCardState *cs)
 {
 	int val, eval;
 
diff --git a/drivers/isdn/hisax/isar.c b/drivers/isdn/hisax/isar.c
index c547a66..bfeb9b6 100644
--- a/drivers/isdn/hisax/isar.c
+++ b/drivers/isdn/hisax/isar.c
@@ -1894,8 +1894,7 @@ isar_auxcmd(struct IsdnCardState *cs, isdn_ctrl *ic) {
 	return(0);
 }
 
-void __devinit
-initisar(struct IsdnCardState *cs)
+void initisar(struct IsdnCardState *cs)
 {
 	cs->bcs[0].BC_SetStack = setstack_isar;
 	cs->bcs[1].BC_SetStack = setstack_isar;
-- 
1.5.4.rc3.14.g44397

