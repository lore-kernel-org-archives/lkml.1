Return-Path: <linux-kernel-owner+w=401wt.eu-S1763709AbYBANmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763709AbYBANmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbYBANmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:42:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:36768 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbYBANmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:42:42 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       isdn4linux@listserv.isdn4linux.de
Cc: Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <kkeil@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] isdn: fix section mismatch warning in enpci_card_msg
Date: Fri,  1 Feb 2008 14:42:42 +0100
Message-Id: <1201873364-13475-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080201133838.GA13349@uranus.ravnborg.org>
References: <20080201133838.GA13349@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: drivers/isdn/hisax/built-in.o(.text+0x3cf50): Section mismatch in reference from the function enpci_card_msg() to the function .devinit.text:Amd7930_init()
WARNING: drivers/isdn/hisax/built-in.o(.text+0x3cf85): Section mismatch in reference from the function enpci_card_msg() to the function .devinit.text:Amd7930_init()

enpci_card_msg() can be called outside __devinit context
referenced function should not be annotated __devinit.

Remove annotation of Amd7930_init to fix this.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/isdn/hisax/amd7930_fn.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
index c0d7036..341faf5 100644
--- a/drivers/isdn/hisax/amd7930_fn.c
+++ b/drivers/isdn/hisax/amd7930_fn.c
@@ -744,8 +744,7 @@ dbusy_timer_handler(struct IsdnCardState *cs)
 
 
 
-void __devinit
-Amd7930_init(struct IsdnCardState *cs)
+void Amd7930_init(struct IsdnCardState *cs)
 {
     WORD *ptr;
     BYTE cmd, cnt;
-- 
1.5.4.rc3.14.g44397

