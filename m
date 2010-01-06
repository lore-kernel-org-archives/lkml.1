Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973Ab0AFQpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0AFQpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836Ab0AFQpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:45:32 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:49310 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab0AFQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:45:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: video/tuner-core, fix memory leak
Date: Wed,  6 Jan 2010 17:45:28 +0100
Message-Id: <1262796328-17176-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262796328-17176-1-git-send-email-jslaby@suse.cz>
References: <1262796328-17176-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a memory leak in tuner_probe. t is not
freed/assigned on all paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/tuner-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5b3eaa1..c4dab6c 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1078,6 +1078,7 @@ static int tuner_probe(struct i2c_client *client,
 
 				goto register_client;
 			}
+			kfree(t);
 			return -ENODEV;
 		case 0x42:
 		case 0x43:
-- 
1.6.5.7

