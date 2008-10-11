Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYJKESs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYJKESs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 00:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYJKESi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 00:18:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:55998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYJKESh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 00:18:37 -0400
Date: Fri, 10 Oct 2008 21:18:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mchehab@infradead.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, security@vger.kernel.org
Subject: [PATCH] security: avoid calling a NULL function pointer in
 drivers/video/tvaudio.c
Message-ID: <20081010211836.0e7a56cf@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 10 Oct 2008 21:16:12 -0700
Subject: [PATCH] security: avoid calling a NULL function pointer in drivers/video/tvaudio.c

NULL function pointers are very bad security wise. This one got caught by
kerneloops.org quite a few times, so it's happening in the field....

Fix is simple, check the function pointer for NULL, like 6 other places
in the same function are already doing.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/media/video/tvaudio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 463680b..b59e472 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1792,7 +1792,7 @@ static int chip_command(struct i2c_client *client,
 		break;
 	case VIDIOC_S_FREQUENCY:
 		chip->mode = 0; /* automatic */
-		if (desc->checkmode) {
+		if (desc->checkmode && desc->setmode) {
 			desc->setmode(chip,V4L2_TUNER_MODE_MONO);
 			if (chip->prevmode != V4L2_TUNER_MODE_MONO)
 				chip->prevmode = -1; /* reset previous mode */
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
