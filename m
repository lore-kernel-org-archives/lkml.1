Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbZCRQW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbZCRQW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbZCRQVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:21:42 -0400
Received: from mail.fieldses.org ([141.211.133.115]:49035 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZCRQVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:21:39 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Igor Zhbanov <izh1979@gmail.com>, Serge Hallyn <serue@us.ibm.com>,
       Benny Halevy <bhalevy@panasas.com>, stable@kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH] NFSD: provide encode routine for OP_OPENATTR
Date: Wed, 18 Mar 2009 12:21:31 -0400
Message-Id: <1237393292-14934-2-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237393292-14934-1-git-send-email-bfields@fieldses.org>
References: <1237393292-14934-1-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benny Halevy <bhalevy@panasas.com>

Although this operation is unsupported by our implementation
we still need to provide an encode routine for it to
merely encode its (error) status back in the compound reply.

Thanks for Bill Baker at sun.com for testing with the Sun
OpenSolaris' client, finding, and reporting this bug at
Connectathon 2009.

This bug was introduced in 2.6.27

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Cc: stable@kernel.org
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/nfsd/nfs4xdr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index f65953b..9250067 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2596,6 +2596,7 @@ static nfsd4_enc nfsd4_enc_ops[] = {
 	[OP_LOOKUPP]		= (nfsd4_enc)nfsd4_encode_noop,
 	[OP_NVERIFY]		= (nfsd4_enc)nfsd4_encode_noop,
 	[OP_OPEN]		= (nfsd4_enc)nfsd4_encode_open,
+	[OP_OPENATTR]		= (nfsd4_enc)nfsd4_encode_noop,
 	[OP_OPEN_CONFIRM]	= (nfsd4_enc)nfsd4_encode_open_confirm,
 	[OP_OPEN_DOWNGRADE]	= (nfsd4_enc)nfsd4_encode_open_downgrade,
 	[OP_PUTFH]		= (nfsd4_enc)nfsd4_encode_noop,
-- 
1.6.0.4

