Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbXG1QSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbXG1QSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXG1QSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:18:16 -0400
Received: from mxout4.netvision.net.il ([194.90.9.27]:36374 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbXG1QSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:18:15 -0400
Date: Sat, 28 Jul 2007 10:47:25 +0300
From: Alon Ziv <lkml@nolaviz.org>
Subject: [PATCH] Try harder to probe some finicky mice
To: linux-kernel@vger.kernel.org
Cc: Alon Ziv <alonz@nolaviz.org>, Alon Ziv <lkml@nolaviz.org>
Message-id: <11856088452370-git-send-email-lkml@nolaviz.org>
X-Mailer: git-send-email 1.5.2.146.gb75c6
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alon Ziv <alonz@nolaviz.org>

Some rodents appear to be extra-finicky, and require both a PSMOUSE_RESET_DIS
and a PSMOUSE_RESET_BAT before they are unconfused enough to be probed.

Signed-off-by: Alon Ziv <lkml@nolaviz.org>
---
 drivers/input/mouse/psmouse-base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index b9f0fb2..ca039a5 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -651,6 +651,7 @@ static int psmouse_extensions(struct psmouse *psmouse,
  * protocol probes. Note that we do full reset becuase some mice
  * put themselves to sleep when see PSMOUSE_RESET_DIS.
  */
+	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
 	psmouse_reset(psmouse);
 
 	if (max_proto >= PSMOUSE_IMEX && im_explorer_detect(psmouse, set_properties) == 0)
-- 
1.5.2.146.gb75c6

