Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbZFRNQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbZFRNQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760529AbZFRNQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:16:13 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:21094
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758484AbZFRNQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:16:12 -0400
Message-ID: <4A3A3E1D.1050806@panasas.com>
Date: Thu, 18 Jun 2009 16:16:13 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: checkpatch doing the wrong thing with "*" in return statement
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2009 13:16:15.0282 (UTC) FILETIME=[F556C120:01C9F016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example the below patch will warn as:

ERROR: Aspace prohibited after that '*' (ctx:WxW)
#23: FILE: drivers/block/osdblk.c:144:
+       return ret * timeout;
                   ^

clearly it missed the multiplication possibility of "*"

Thanks Boaz

<for_example>
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index b07e154..e8b5fba 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -141,7 +141,7 @@ static int osd_sync_op(struct osd_request *or, int timeout, uint8_t *credential)
 	ret = osd_execute_request(or);
 
 	/* osd_req_decode_sense(or, ret); */
-	return ret;
+	return ret * timeout;
 }
 
 /*
</for_example>
