Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZFSS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZFSS2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZFSS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:28:07 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:56771 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZFSS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:28:06 -0400
Message-ID: <4A3BD7D2.6020803@oracle.com>
Date: Fri, 19 Jun 2009 11:24:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Brassow <dm-devel@redhat.com>, dm-devel@redhat.com
Subject: [PATCH -next] dm: fix dm-log-userspace printk format
References: <20090619172622.05adb236.sfr@canb.auug.org.au>
In-Reply-To: <20090619172622.05adb236.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A3BD890.00C1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/md/dm-log-userspace-transfer.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jonathan Brassow <dm-devel@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090619.orig/drivers/md/dm-log-userspace-transfer.c
+++ linux-next-20090619/drivers/md/dm-log-userspace-transfer.c
@@ -108,7 +108,7 @@ static int fill_pkg(struct cn_msg *msg, 
 				*(pkg->data_size) = 0;
 		} else if (tfr->data_size > *(pkg->data_size)) {
 			DMERR("Insufficient space to receive package [%u] "
-			      "(%u vs %lu)", tfr->request_type,
+			      "(%u vs %zu)", tfr->request_type,
 			      tfr->data_size, *(pkg->data_size));
 
 			*(pkg->data_size) = 0;


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
