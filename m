Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZKPLv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZKPLv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZKPLvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:51:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbZKPLvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:51:25 -0500
Date: Mon, 16 Nov 2009 12:51:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: fix wrong synaptics detection in
 psmouse_extensions()
Message-ID: <alpine.LSU.2.00.0911161245570.15039@wotan.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b7802c5c1ea ("Input: psmouse - use boolean type") caused the 
synaptics_hardware variable to be completely useless, as it is constantly 
set to 'true' throughout the whole psmouse_extensions(). This was caused 
by the following hunk in the commit in question

	-       int synaptics_hardware = 0;
	+       bool synaptics_hardware = true;

which is wrong. Fix that up.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 
 drivers/input/mouse/psmouse-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 690aed9..b7eccc2 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -581,7 +581,7 @@ static int cortron_detect(struct psmouse *psmouse, bool set_properties)
 static int psmouse_extensions(struct psmouse *psmouse,
 			      unsigned int max_proto, bool set_properties)
 {
-	bool synaptics_hardware = true;
+	bool synaptics_hardware = false;
 
 /*
  * We always check for lifebook because it does not disturb mouse
