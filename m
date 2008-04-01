Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYDADn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYDADn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 23:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYDADnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 23:43:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62008 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYDADnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 23:43:16 -0400
Message-ID: <47F1AEDB.1080300@cn.fujitsu.com>
Date: Tue, 01 Apr 2008 11:41:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: vladislav.yasevich@hp.com, lksctp-developers@lists.sourceforge.net,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] SCTP: fix wrong debug counting of datamsg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should not count it if the allocation of this object
failed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/sctp/chunk.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 4d3128f..099b0af 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -66,9 +66,10 @@ SCTP_STATIC struct sctp_datamsg *sctp_datamsg_new(gfp_t gfp)
 {
 	struct sctp_datamsg *msg;
 	msg = kmalloc(sizeof(struct sctp_datamsg), gfp);
-	if (msg)
+	if (msg) {
 		sctp_datamsg_init(msg);
-	SCTP_DBG_OBJCNT_INC(datamsg);
+		SCTP_DBG_OBJCNT_INC(datamsg);
+	}
 	return msg;
 }
 
-- 
1.5.4.rc3

