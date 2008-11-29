Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYK2Pi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYK2Pi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 10:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYK2PiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 10:38:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:14470 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYK2PiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 10:38:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=s8a5vGNE6PKyUQqJeKrEXuKxzksunhVQf+iSshat7IVsyyY4iDFRM+kM6Rx+QVnNE2
         T9kG/zxccIZ1qznUwX94PhAtgWA4izTv1zvfHeUAJ5esXtnBiyrU/xVCxo4WgOzJKywz
         upl0iEtPklJnzzWtbboErwOCcnsEaVUBm4ARc=
Message-ID: <493161DE.6000703@gmail.com>
Date: Sat, 29 Nov 2008 10:38:06 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] relay: When unsigned ret cannot store a negative value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unsigned ret cannot store a negative value

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
UNTESTED! is this the way to go?

diff --git a/kernel/relay.c b/kernel/relay.c
index 32b0bef..c9d62e5 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1220,7 +1220,8 @@ static int subbuf_splice_actor(struct file *in,
 			       unsigned int flags,
 			       int *nonpad_ret)
 {
-	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
+	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages;
+	ssize_t ret;
 	struct rchan_buf *rbuf = in->private_data;
 	unsigned int subbuf_size = rbuf->chan->subbuf_size;
 	uint64_t pos = (uint64_t) *ppos;
@@ -1289,7 +1290,8 @@ static int subbuf_splice_actor(struct file *in,
 	if (!spd.nr_pages)
 		return 0;
 
-	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
+	ret = splice_to_pipe(pipe, &spd);
+	*nonpad_ret = ret;
 	if (ret < 0 || ret < total_len)
 		return ret;
 


