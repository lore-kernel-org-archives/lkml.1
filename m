Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbXEOMou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbXEOMou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXEOMon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:44:43 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:8342 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXEOMom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:44:42 -0400
Message-ID: <4649AB2B.1040408@sw.ru>
Date: Tue, 15 May 2007 16:44:27 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [patch i2o 3/6] i2o message leak in i2o_msg_post_wait_mem()
References: <4649AA6C.2080808@sw.ru>
In-Reply-To: <4649AA6C.2080808@sw.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need to free i2o msg in case of error.

Signed-off-by:	Vasily Averin <vvs@sw.ru>

--- lk2.6/drivers/message/i2o/exec-osm.c
+++ lk2.6/drivers/message/i2o/exec-osm.c
@@ -131,8 +131,10 @@ int i2o_msg_post_wait_mem(struct i2o_con
 	int rc = 0;

 	wait = i2o_exec_wait_alloc();
-	if (!wait)
+	if (!wait) {
+		i2o_msg_nop(c, msg);
 		return -ENOMEM;
+	}

 	if (tcntxt == 0xffffffff)
 		tcntxt = 0x80000000;
