Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYGREdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYGREdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 00:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYGREdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 00:33:09 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:23377 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYGREdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 00:33:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IDrIVA/e/seiK58QVpkfE3NlIZPNNblCCto3v3mA67zxoGSpjUq3S2uQABYY4zrSx4
         zC4gR9eh/SrkdOTOsI5y6xAJCfZsh8ud2jR4lcAkxVROQ4TYYs1yelQXUqdjuD1Yegrm
         GmozgpMlavuoYnB1SRrUZWJ+5x8fbhqniLnCc=
Subject: [PATCH 1/2] nfs: nfs4xdr use C99 array initializers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 21:33:03 -0700
Message-Id: <1216355583.6029.137.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/nfsd/nfs4xdr.c |  154 +++++++++++++++++++++++++++--------------------------
 1 files changed, 79 insertions(+), 75 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9b6a9ba..9612d66 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -999,45 +999,47 @@ nfsd4_decode_notsupp(struct nfsd4_compoundargs *argp, void *p)
 
 typedef __be32(*nfsd4_dec)(struct nfsd4_compoundargs *argp, void *);
 
+#define NFSD4_DEC_OP(idx, op)	[(idx)] = (nfsd4_dec)(op)
 static nfsd4_dec nfsd4_dec_ops[] = {
-	[OP_ACCESS]		(nfsd4_dec)nfsd4_decode_access,
-	[OP_CLOSE]		(nfsd4_dec)nfsd4_decode_close,
-	[OP_COMMIT]		(nfsd4_dec)nfsd4_decode_commit,
-	[OP_CREATE]		(nfsd4_dec)nfsd4_decode_create,
-	[OP_DELEGPURGE]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_DELEGRETURN]	(nfsd4_dec)nfsd4_decode_delegreturn,
-	[OP_GETATTR]		(nfsd4_dec)nfsd4_decode_getattr,
-	[OP_GETFH]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_LINK]		(nfsd4_dec)nfsd4_decode_link,
-	[OP_LOCK]		(nfsd4_dec)nfsd4_decode_lock,
-	[OP_LOCKT]		(nfsd4_dec)nfsd4_decode_lockt,
-	[OP_LOCKU]		(nfsd4_dec)nfsd4_decode_locku,
-	[OP_LOOKUP]		(nfsd4_dec)nfsd4_decode_lookup,
-	[OP_LOOKUPP]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_NVERIFY]		(nfsd4_dec)nfsd4_decode_verify,
-	[OP_OPEN]		(nfsd4_dec)nfsd4_decode_open,
-	[OP_OPENATTR]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_OPEN_CONFIRM]	(nfsd4_dec)nfsd4_decode_open_confirm,
-	[OP_OPEN_DOWNGRADE]	(nfsd4_dec)nfsd4_decode_open_downgrade,
-	[OP_PUTFH]		(nfsd4_dec)nfsd4_decode_putfh,
-	[OP_PUTPUBFH]		(nfsd4_dec)nfsd4_decode_notsupp,
-	[OP_PUTROOTFH]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_READ]		(nfsd4_dec)nfsd4_decode_read,
-	[OP_READDIR]		(nfsd4_dec)nfsd4_decode_readdir,
-	[OP_READLINK]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_REMOVE]		(nfsd4_dec)nfsd4_decode_remove,
-	[OP_RENAME]		(nfsd4_dec)nfsd4_decode_rename,
-	[OP_RENEW]		(nfsd4_dec)nfsd4_decode_renew,
-	[OP_RESTOREFH]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_SAVEFH]		(nfsd4_dec)nfsd4_decode_noop,
-	[OP_SECINFO]		(nfsd4_dec)nfsd4_decode_secinfo,
-	[OP_SETATTR]		(nfsd4_dec)nfsd4_decode_setattr,
-	[OP_SETCLIENTID]	(nfsd4_dec)nfsd4_decode_setclientid,
-	[OP_SETCLIENTID_CONFIRM](nfsd4_dec)nfsd4_decode_setclientid_confirm,
-	[OP_VERIFY]		(nfsd4_dec)nfsd4_decode_verify,
-	[OP_WRITE]		(nfsd4_dec)nfsd4_decode_write,
-	[OP_RELEASE_LOCKOWNER]	(nfsd4_dec)nfsd4_decode_release_lockowner,
+	NFSD4_DEC_OP(OP_ACCESS, nfsd4_decode_access),
+	NFSD4_DEC_OP(OP_CLOSE, nfsd4_decode_close),
+	NFSD4_DEC_OP(OP_COMMIT, nfsd4_decode_commit),
+	NFSD4_DEC_OP(OP_CREATE, nfsd4_decode_create),
+	NFSD4_DEC_OP(OP_DELEGPURGE, nfsd4_decode_notsupp),
+	NFSD4_DEC_OP(OP_DELEGRETURN, nfsd4_decode_delegreturn),
+	NFSD4_DEC_OP(OP_GETATTR, nfsd4_decode_getattr),
+	NFSD4_DEC_OP(OP_GETFH, nfsd4_decode_noop),
+	NFSD4_DEC_OP(OP_LINK, nfsd4_decode_link),
+	NFSD4_DEC_OP(OP_LOCK, nfsd4_decode_lock),
+	NFSD4_DEC_OP(OP_LOCKT, nfsd4_decode_lockt),
+	NFSD4_DEC_OP(OP_LOCKU, nfsd4_decode_locku),
+	NFSD4_DEC_OP(OP_LOOKUP, nfsd4_decode_lookup),
+	NFSD4_DEC_OP(OP_LOOKUPP, nfsd4_decode_noop),
+	NFSD4_DEC_OP(OP_NVERIFY, nfsd4_decode_verify),
+	NFSD4_DEC_OP(OP_OPEN, nfsd4_decode_open),
+	NFSD4_DEC_OP(OP_OPENATTR, nfsd4_decode_notsupp),
+	NFSD4_DEC_OP(OP_OPEN_CONFIRM, nfsd4_decode_open_confirm),
+	NFSD4_DEC_OP(OP_OPEN_DOWNGRADE, nfsd4_decode_open_downgrade),
+	NFSD4_DEC_OP(OP_PUTFH, nfsd4_decode_putfh),
+	NFSD4_DEC_OP(OP_PUTPUBFH, nfsd4_decode_notsupp),
+	NFSD4_DEC_OP(OP_PUTROOTFH, nfsd4_decode_noop),
+	NFSD4_DEC_OP(OP_READ, nfsd4_decode_read),
+	NFSD4_DEC_OP(OP_READDIR, nfsd4_decode_readdir),
+	NFSD4_DEC_OP(OP_READLINK, nfsd4_decode_noop),
+	NFSD4_DEC_OP(OP_REMOVE, nfsd4_decode_remove),
+	NFSD4_DEC_OP(OP_RENAME, nfsd4_decode_rename),
+	NFSD4_DEC_OP(OP_RENEW, nfsd4_decode_renew),
+	NFSD4_DEC_OP(OP_RESTOREFH, nfsd4_decode_noop),
+	NFSD4_DEC_OP(OP_SAVEFH, nfsd4_decode_noop),
+	NFSD4_DEC_OP(OP_SECINFO, nfsd4_decode_secinfo),
+	NFSD4_DEC_OP(OP_SETATTR, nfsd4_decode_setattr),
+	NFSD4_DEC_OP(OP_SETCLIENTID, nfsd4_decode_setclientid),
+	NFSD4_DEC_OP(OP_SETCLIENTID_CONFIRM, nfsd4_decode_setclientid_confirm),
+	NFSD4_DEC_OP(OP_VERIFY, nfsd4_decode_verify),
+	NFSD4_DEC_OP(OP_WRITE, nfsd4_decode_write),
+	NFSD4_DEC_OP(OP_RELEASE_LOCKOWNER, nfsd4_decode_release_lockowner),
 };
+#undef NFSD4_DEC_OP
 
 struct nfsd4_minorversion_ops {
 	nfsd4_dec *decoders;
@@ -1045,7 +1047,7 @@ struct nfsd4_minorversion_ops {
 };
 
 static struct nfsd4_minorversion_ops nfsd4_minorversion[] = {
-	[0] { nfsd4_dec_ops, ARRAY_SIZE(nfsd4_dec_ops) },
+	[0] = { nfsd4_dec_ops, ARRAY_SIZE(nfsd4_dec_ops) },
 };
 
 static __be32
@@ -2576,44 +2578,46 @@ nfsd4_encode_noop(struct nfsd4_compoundres *resp, __be32 nfserr, void *p)
 
 typedef __be32(* nfsd4_enc)(struct nfsd4_compoundres *, __be32, void *);
 
+#define NFSD4_ENC_OP(idx, op)	[(idx)] = (nfsd4_enc)(op)
 static nfsd4_enc nfsd4_enc_ops[] = {
-	[OP_ACCESS]		(nfsd4_enc)nfsd4_encode_access,
-	[OP_CLOSE]		(nfsd4_enc)nfsd4_encode_close,
-	[OP_COMMIT]		(nfsd4_enc)nfsd4_encode_commit,
-	[OP_CREATE]		(nfsd4_enc)nfsd4_encode_create,
-	[OP_DELEGPURGE]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_DELEGRETURN]	(nfsd4_enc)nfsd4_encode_noop,
-	[OP_GETATTR]		(nfsd4_enc)nfsd4_encode_getattr,
-	[OP_GETFH]		(nfsd4_enc)nfsd4_encode_getfh,
-	[OP_LINK]		(nfsd4_enc)nfsd4_encode_link,
-	[OP_LOCK]		(nfsd4_enc)nfsd4_encode_lock,
-	[OP_LOCKT]		(nfsd4_enc)nfsd4_encode_lockt,
-	[OP_LOCKU]		(nfsd4_enc)nfsd4_encode_locku,
-	[OP_LOOKUP]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_LOOKUPP]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_NVERIFY]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_OPEN]		(nfsd4_enc)nfsd4_encode_open,
-	[OP_OPEN_CONFIRM]	(nfsd4_enc)nfsd4_encode_open_confirm,
-	[OP_OPEN_DOWNGRADE]	(nfsd4_enc)nfsd4_encode_open_downgrade,
-	[OP_PUTFH]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_PUTPUBFH]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_PUTROOTFH]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_READ]		(nfsd4_enc)nfsd4_encode_read,
-	[OP_READDIR]		(nfsd4_enc)nfsd4_encode_readdir,
-	[OP_READLINK]		(nfsd4_enc)nfsd4_encode_readlink,
-	[OP_REMOVE]		(nfsd4_enc)nfsd4_encode_remove,
-	[OP_RENAME]		(nfsd4_enc)nfsd4_encode_rename,
-	[OP_RENEW]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_RESTOREFH]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_SAVEFH]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_SECINFO]		(nfsd4_enc)nfsd4_encode_secinfo,
-	[OP_SETATTR]		(nfsd4_enc)nfsd4_encode_setattr,
-	[OP_SETCLIENTID]	(nfsd4_enc)nfsd4_encode_setclientid,
-	[OP_SETCLIENTID_CONFIRM](nfsd4_enc)nfsd4_encode_noop,
-	[OP_VERIFY]		(nfsd4_enc)nfsd4_encode_noop,
-	[OP_WRITE]		(nfsd4_enc)nfsd4_encode_write,
-	[OP_RELEASE_LOCKOWNER]	(nfsd4_enc)nfsd4_encode_noop,
-};
+	NFSD4_ENC_OP(OP_ACCESS, nfsd4_encode_access),
+ 	NFSD4_ENC_OP(OP_CLOSE, nfsd4_encode_close),
+ 	NFSD4_ENC_OP(OP_COMMIT, nfsd4_encode_commit),
+ 	NFSD4_ENC_OP(OP_CREATE, nfsd4_encode_create),
+ 	NFSD4_ENC_OP(OP_DELEGPURGE, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_DELEGRETURN, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_GETATTR, nfsd4_encode_getattr),
+ 	NFSD4_ENC_OP(OP_GETFH, nfsd4_encode_getfh),
+ 	NFSD4_ENC_OP(OP_LINK, nfsd4_encode_link),
+ 	NFSD4_ENC_OP(OP_LOCK, nfsd4_encode_lock),
+ 	NFSD4_ENC_OP(OP_LOCKT, nfsd4_encode_lockt),
+ 	NFSD4_ENC_OP(OP_LOCKU, nfsd4_encode_locku),
+ 	NFSD4_ENC_OP(OP_LOOKUP, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_LOOKUPP, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_NVERIFY, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_OPEN, nfsd4_encode_open),
+ 	NFSD4_ENC_OP(OP_OPEN_CONFIRM, nfsd4_encode_open_confirm),
+ 	NFSD4_ENC_OP(OP_OPEN_DOWNGRADE, nfsd4_encode_open_downgrade),
+ 	NFSD4_ENC_OP(OP_PUTFH, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_PUTPUBFH, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_PUTROOTFH, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_READ, nfsd4_encode_read),
+ 	NFSD4_ENC_OP(OP_READDIR, nfsd4_encode_readdir),
+ 	NFSD4_ENC_OP(OP_READLINK, nfsd4_encode_readlink),
+ 	NFSD4_ENC_OP(OP_REMOVE, nfsd4_encode_remove),
+ 	NFSD4_ENC_OP(OP_RENAME, nfsd4_encode_rename),
+ 	NFSD4_ENC_OP(OP_RENEW, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_RESTOREFH, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_SAVEFH, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_SECINFO, nfsd4_encode_secinfo),
+ 	NFSD4_ENC_OP(OP_SETATTR, nfsd4_encode_setattr),
+ 	NFSD4_ENC_OP(OP_SETCLIENTID, nfsd4_encode_setclientid),
+ 	NFSD4_ENC_OP(OP_SETCLIENTID_CONFIRM, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_VERIFY, nfsd4_encode_noop),
+ 	NFSD4_ENC_OP(OP_WRITE, nfsd4_encode_write),
+ 	NFSD4_ENC_OP(OP_RELEASE_LOCKOWNER, nfsd4_encode_noop),
+ };
+#undef NFSD4_ENC_OP
 
 void
 nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
-- 
1.5.6.3.569.ga9185


