Return-Path: <linux-kernel-owner+w=401wt.eu-S933209AbYBTUMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbYBTUMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765036AbYBTUKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:10:55 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:18294 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764870AbYBTUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CVdv5N3y+uz9TFR6hTG5kmiUmc7gRuUi2quqc34c2cyyNvagzH62QqIG0AZCkPaHbo2L8VpvFCn3s994RFW3jPquHooCXGp2nC3Z8qw5PZleuB2Tv/EYbC6WqXfWA7vlYqjKs/36xTGNOqND6wCBVXCfSn95xI/MrIkVWyR8SoI=
Subject: [PATCH 4/4] nfs: fix sparse warnings in callback_xdr.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:10:47 -0800
Message-Id: <1203538247.25307.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nfs/callback_xdr.c:257:6: warning: Using plain integer as NULL pointer
fs/nfs/callback_xdr.c:270:6: warning: Using plain integer as NULL pointer
fs/nfs/callback_xdr.c:281:6: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/nfs/callback_xdr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index c63eb72..13619d2 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -254,7 +254,7 @@ static __be32 encode_attr_change(struct xdr_stream *xdr, const uint32_t *bitmap,
 	if (!(bitmap[0] & FATTR4_WORD0_CHANGE))
 		return 0;
 	p = xdr_reserve_space(xdr, 8);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, change);
 	return 0;
@@ -267,7 +267,7 @@ static __be32 encode_attr_size(struct xdr_stream *xdr, const uint32_t *bitmap, u
 	if (!(bitmap[0] & FATTR4_WORD0_SIZE))
 		return 0;
 	p = xdr_reserve_space(xdr, 8);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, size);
 	return 0;
@@ -278,7 +278,7 @@ static __be32 encode_attr_time(struct xdr_stream *xdr, const struct timespec *ti
 	__be32 *p;
 
 	p = xdr_reserve_space(xdr, 12);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, time->tv_sec);
 	*p = htonl(time->tv_nsec);
-- 
1.5.4.2.200.g99e75

