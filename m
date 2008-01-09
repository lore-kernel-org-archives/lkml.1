Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYAIFrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYAIFrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 00:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYAIFrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 00:47:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53531 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYAIFrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 00:47:12 -0500
Message-ID: <47845F27.6020305@cn.fujitsu.com>
Date: Wed, 09 Jan 2008 13:44:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] CONNECTOR: don't touch queue dev after decrement of ref count
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cn_queue_free_callback() will touch 'dev'(i.e. cbq->pdev),
so it should be called before atomic_dec(&dev->refcnt).

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/connector/cn_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 23cc87a..5732ca3 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -99,8 +99,8 @@ int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id
 	spin_unlock_bh(&dev->queue_lock);
 
 	if (found) {
-		atomic_dec(&dev->refcnt);
 		cn_queue_free_callback(cbq);
+		atomic_dec(&dev->refcnt);
 		return -EINVAL;
 	}
 
-- 
1.5.3.rc7

