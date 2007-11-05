Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbXKECcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbXKECcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbXKECce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:32:34 -0500
Received: from [222.73.24.84] ([222.73.24.84]:55187 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbXKECce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:32:34 -0500
Message-ID: <472E8054.6000006@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 10:30:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, johnpol@2ka.mipt.ru
Subject: [PATCH 6/6] W1: fix memset size error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The size arguments passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/w1/masters/ds2490.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 299e274..b63b5e0 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -233,7 +233,7 @@ static int ds_recv_status_nodump(struct ds_device *dev, struct ds_status *st,
 {
 	int count, err;
 
-	memset(st, 0, sizeof(st));
+	memset(st, 0, sizeof(*st));
 
 	count = 0;
 	err = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_STATUS]), buf, size, &count, 100);
-- 
1.5.3.rc7

