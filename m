Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbZEAOe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbZEAOe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZEAOes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:34:48 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:38187 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754392AbZEAOer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:34:47 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] fs: Remove sparse errors in bio.c
Date: Fri,  1 May 2009 16:33:22 +0200
Message-Id: <1241188402-19332-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

fs/bio.c:720:13: warning: incorrect type in assignment (different address spaces)
fs/bio.c:720:13:    expected char *iov_addr
fs/bio.c:720:13:    got void [noderef] <asn:1>*
fs/bio.c:724:36: warning: incorrect type in argument 2 (different address spaces)
fs/bio.c:724:36:    expected void const [noderef] <asn:1>*from
fs/bio.c:724:36:    got char *iov_addr

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 fs/bio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e0c9e54..9e795e2 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -713,7 +713,7 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 
 		while (bv_len && iov_idx < iov_count) {
 			unsigned int bytes;
-			char *iov_addr;
+			char __user *iov_addr;
 
 			bytes = min_t(unsigned int,
 				      iov[iov_idx].iov_len - iov_off, bv_len);
-- 
1.5.5.1

