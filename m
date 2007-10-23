Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbXJWKou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbXJWKou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXJWKon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:44:43 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:43534 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXJWKom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:44:42 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 06/10] [SG] Update net/ to use sg helpers
Date: Tue, 23 Oct 2007 12:44:22 +0200
User-Agent: KMail/1.9.7
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       vladislav.yasevich@hp.com, sri@us.ibm.com
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-7-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1193076664-13652-7-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710231244.22189.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sctp compile

sctp fails to compile with 
net/sctp/sm_make_chunk.c: In function 'sctp_pack_cookie':
net/sctp/sm_make_chunk.c:1516: error: implicit declaration of function 'sg_init_table'
net/sctp/sm_make_chunk.c:1517: error: implicit declaration of function 'sg_set_page'

use the proper include file.

SCTP maintainers Vlad Yasevich and Sridhar Samudrala  are CCed.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 net/sctp/sm_make_chunk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/net/sctp/sm_make_chunk.c
===================================================================
--- linux-2.6.orig/net/sctp/sm_make_chunk.c
+++ linux-2.6/net/sctp/sm_make_chunk.c
@@ -56,7 +56,7 @@
 #include <linux/ipv6.h>
 #include <linux/net.h>
 #include <linux/inet.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <net/sock.h>
 
