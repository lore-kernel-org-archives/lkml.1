Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZIAIAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZIAIAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZIAIAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:00:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58319 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbZIAIAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:00:35 -0400
Message-ID: <4A9CD4C3.9000800@cn.fujitsu.com>
Date: Tue, 01 Sep 2009 16:01:07 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH]cfq: fix the log message after dispatched a request
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blktrace tools can show process id when cfq dispatched a request,
using cfq_log_cfqq() instead of cfq_log().


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd7080e..150c9dd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1362,7 +1362,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 		cfq_slice_expired(cfqd, 0);
 	}
 
-	cfq_log(cfqd, "dispatched a request");
+	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
 	return 1;
 }
 
-- 
1.6.0.4
 
