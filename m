Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbYADF60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbYADF60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYADF5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:57:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59442 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757236AbYADF5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:57:20 -0500
Message-ID: <477DC9C1.2000209@cn.fujitsu.com>
Date: Fri, 04 Jan 2008 13:53:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] CONNECTOR: return proper error code in cn_call_callback()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Error code should be set to EINVAL instead of ENODEV if !queue_work().
There's another call of queue_work() which may set err to EINVAL.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/connector/connector.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 865303b..37976dc 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -146,6 +146,8 @@ static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), v
 				if (queue_work(dev->cbdev->cn_queue,
 							&__cbq->work))
 					err = 0;
+				else
+					err = -EINVAL;
 			} else {
 				struct cn_callback_data *d;
 				
-- 
1.5.3.rc7

