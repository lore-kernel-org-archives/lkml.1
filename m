Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYADF5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYADF5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYADF5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:57:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63059 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbYADF5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:57:05 -0500
Message-ID: <477DC9AE.3070206@cn.fujitsu.com>
Date: Fri, 04 Jan 2008 13:52:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] CONNECTOR: add a missing break in cn_netlink_send()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Each entry in the list has a unique id, so just break out of the
loop if the matched id is found.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/connector/connector.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 6883fcb..6e70963 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -88,6 +88,7 @@ int cn_netlink_send(struct cn_msg *msg, u32 __group, gfp_t gfp_mask)
 			if (cn_cb_equal(&__cbq->id.id, &msg->id)) {
 				found = 1;
 				group = __cbq->group;
+				break;
 			}
 		}
 		spin_unlock_bh(&dev->cbdev->queue_lock);
-- 
1.5.3.rc7

