Return-Path: <linux-kernel-owner+w=401wt.eu-S1764219AbYBANnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764219AbYBANnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbYBANmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:42:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42782 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbYBANmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:42:43 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       isdn4linux@listserv.isdn4linux.de
Cc: Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <kkeil@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] isdn: fix section mismatch warning for ISACVer
Date: Fri,  1 Feb 2008 14:42:41 +0100
Message-Id: <1201873364-13475-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080201133838.GA13349@uranus.ravnborg.org>
References: <20080201133838.GA13349@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: drivers/isdn/hisax/built-in.o(.text+0x19723): Section mismatch in reference from the function ISACVersion() to the variable .devinit.data:ISACVer
WARNING: drivers/isdn/hisax/built-in.o(.text+0x2005b): Section mismatch in reference from the function setup_avm_a1_pcmcia() to the function .devinit.text:setup_isac()

ISACVer were only used from function annotated __devinit
so add same annotation to ISACVer.
One af the fererencing functions missed __devinit so add it
and kill an additional warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/isdn/hisax/avm_a1p.c |    3 +--
 drivers/isdn/hisax/isac.c    |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hisax/avm_a1p.c b/drivers/isdn/hisax/avm_a1p.c
index c87fa3f..3039c6d 100644
--- a/drivers/isdn/hisax/avm_a1p.c
+++ b/drivers/isdn/hisax/avm_a1p.c
@@ -213,8 +213,7 @@ AVM_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return 0;
 }
 
-int
-setup_avm_a1_pcmcia(struct IsdnCard *card)
+int __devinit setup_avm_a1_pcmcia(struct IsdnCard *card)
 {
 	u_char model, vers;
 	struct IsdnCardState *cs = card->cs;
diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index 4e9f238..6ae9dde 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -27,8 +27,7 @@ static char *ISACVer[] __devinitdata =
 {"2086/2186 V1.1", "2085 B1", "2085 B2",
  "2085 V2.3"};
 
-void
-ISACVersion(struct IsdnCardState *cs, char *s)
+void __devinit ISACVersion(struct IsdnCardState *cs, char *s)
 {
 	int val;
 
-- 
1.5.4.rc3.14.g44397

