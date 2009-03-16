Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbZCPLYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbZCPLYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZCPLYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:24:37 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:52727 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZCPLYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:24:36 -0400
Subject: [Patch] relay: fix signedness in subbuf_splice_actor()
From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Date: Mon, 16 Mar 2009 12:24:36 +0100
Message-Id: <1237202676.4210.5.camel@kitka.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

The variable ret is used as a signed value.
Found by a statical code analysis tool.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>

---
 kernel/relay.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1227,7 +1227,8 @@ static int subbuf_splice_actor(struct fi
 			       unsigned int flags,
 			       int *nonpad_ret)
 {
-	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
+	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages;
+	int ret;
 	struct rchan_buf *rbuf = in->private_data;
 	unsigned int subbuf_size = rbuf->chan->subbuf_size;
 	uint64_t pos = (uint64_t) *ppos;


