Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZHPOeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZHPOeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZHPOeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:34:00 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:16451 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZHPOeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:34:00 -0400
Message-ID: <4A8818BA.2030309@oracle.com>
Date: Sun, 16 Aug 2009 07:33:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, dm-devel@redhat.com
Subject: [PATCH] dm-log-userspace: fix  printk format warning
References: <alpine.LFD.2.01.0908131601100.3162@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908131601100.3162@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A88189D.00E9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/md/dm-log-userspace-transfer.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'

Previously posted and acked, but apparently lost.
http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/02074.html

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2631-rc6.orig/drivers/md/dm-log-userspace-transfer.c
+++ lnx-2631-rc6/drivers/md/dm-log-userspace-transfer.c
@@ -108,7 +108,7 @@ static int fill_pkg(struct cn_msg *msg,
 				*(pkg->data_size) = 0;
 		} else if (tfr->data_size > *(pkg->data_size)) {
 			DMERR("Insufficient space to receive package [%u] "
-			      "(%u vs %lu)", tfr->request_type,
+			      "(%u vs %zu)", tfr->request_type,
 			      tfr->data_size, *(pkg->data_size));
 
 			*(pkg->data_size) = 0;
