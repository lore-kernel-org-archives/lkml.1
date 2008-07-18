Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYGREdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYGREdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 00:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYGREdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 00:33:12 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:23377 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYGREdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 00:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=d3SOFXxFkl9eLwzCRVwCha71u97XEYT/svoRk9RVGE2sqtuRHr2sT2PMxWMvJvRa3M
         GCzMBlrgthPCcMtJmhfQJOr+JfVeq4v9dtcQL3D7gF8VgfGIy2Zdq/ErsVAhyjvcL0Qg
         /Fq29YtwYudqHCVKMUbB1XXvOD6/4baKJQPFQ=
Subject: [PATCH 2/2] nfs: nfs4xdr.c do-while is not a compound statement
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 21:33:04 -0700
Message-Id: <1216355584.6029.139.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WRITEMEM macro produces sparse warnings of the form:
fs/nfsd/nfs4xdr.c:2668:2: warning: do-while statement is not a compound statement

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/nfsd/nfs4xdr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9612d66..0957ec1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1162,11 +1162,11 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 	*p++ = htonl((u32)((n) >> 32));				\
 	*p++ = htonl((u32)(n));					\
 } while (0)
-#define WRITEMEM(ptr,nbytes)     do if (nbytes > 0) {		\
+#define WRITEMEM(ptr,nbytes)     do { if (nbytes > 0) {		\
 	*(p + XDR_QUADLEN(nbytes) -1) = 0;                      \
 	memcpy(p, ptr, nbytes);					\
 	p += XDR_QUADLEN(nbytes);				\
-} while (0)
+}} while (0)
 #define WRITECINFO(c)		do {				\
 	*p++ = htonl(c.atomic);					\
 	*p++ = htonl(c.before_ctime_sec);				\
-- 
1.5.6.3.569.ga9185

