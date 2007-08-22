Return-Path: <linux-kernel-owner+w=401wt.eu-S1761218AbXHVI6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218AbXHVI6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbXHVIwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:55 -0400
Received: from 1wt.eu ([62.212.114.60]:1956 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077AbXHVIww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:52 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083957.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:01 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 17/58] V4L: wm8775/wm8739: Fix memory leak when unloading module
Content-Disposition: inline; filename=0017-V4L-wm8775-wm8739-Fix-memory-leak-when-unloading-m.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

State struct was never freed.

(cherry picked from commit 1b2232ab879993fcf5b9391c3febf6ab5d78201e)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/media/video/wm8739.c |    2 ++
 drivers/media/video/wm8775.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/wm8739.c b/drivers/media/video/wm8739.c
index a9b59c3..009941b 100644
--- a/drivers/media/video/wm8739.c
+++ b/drivers/media/video/wm8739.c
@@ -317,12 +317,14 @@ static int wm8739_probe(struct i2c_adapter *adapter)
 
 static int wm8739_detach(struct i2c_client *client)
 {
+	struct wm8739_state *state = i2c_get_clientdata(client);
 	int err;
 
 	err = i2c_detach_client(client);
 	if (err)
 		return err;
 
+	kfree(state);
 	kfree(client);
 	return 0;
 }
diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
index d81a88b..e555b3a 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -218,12 +218,14 @@ static int wm8775_probe(struct i2c_adapter *adapter)
 
 static int wm8775_detach(struct i2c_client *client)
 {
+	struct wm8775_state *state = i2c_get_clientdata(client);
 	int err;
 
 	err = i2c_detach_client(client);
 	if (err) {
 		return err;
 	}
+	kfree(state);
 	kfree(client);
 
 	return 0;
-- 
1.5.2.5

-- 
