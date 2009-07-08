Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbZGHUIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbZGHUIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbZGHUI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:08:27 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46649 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbZGHUI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Xnkk1gJOrnnzLjDv+TVUy4MtWIGbVKftODZ9CEm/Fb0VhnT/vEtLOvccj4fA84xcwW
         JLebfHCgKzuGPp9Oh+oBd0fK0/0pmZHwsq34wWId+JBLEBn5s72K/hKt0Wx/UuO0wrlL
         PvqCI9y6xlOqGNH+QkLOCn9EJ7Qd3DLMvH0Fs=
Message-ID: <4A54FC78.2010101@gmail.com>
Date: Wed, 08 Jul 2009 22:07:20 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] staging/rt*: fix wait_queue_head_t declaration on stack
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 2/3] staging/rt*: fix wait_queue_head_t declaration on stack

othwerwise lockdep complains:
"INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator."

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/rt_main_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index f298b9b..b6a0372 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -190,7 +190,7 @@ int rt28xx_close(IN PNET_DEV dev)
 	BOOLEAN 		Cancelled = FALSE;
 	UINT32			i = 0;
 #ifdef RT2870
-	DECLARE_WAIT_QUEUE_HEAD(unlink_wakeup);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
 	DECLARE_WAITQUEUE(wait, current);
 
 	//RTMP_SET_FLAG(pAd, fRTMP_ADAPTER_REMOVE_IN_PROGRESS);
-- 
1.6.3.3

