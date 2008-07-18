Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYGRSBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYGRSBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYGRSBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:01:20 -0400
Received: from mail.fieldses.org ([66.93.2.214]:36369 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbYGRSBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:01:19 -0400
Date: Fri, 18 Jul 2008 14:01:15 -0400
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] nfs: nfs4xdr use C99 array initializers
Message-ID: <20080718180115.GJ8035@fieldses.org>
References: <1216355583.6029.137.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216355583.6029.137.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 09:33:03PM -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

OK, thanks.  But I'd rather just skip the macro:

> +#define NFSD4_DEC_OP(idx, op)	[(idx)] = (nfsd4_dec)(op)
> -	[OP_ACCESS]		(nfsd4_dec)nfsd4_decode_access,
> -	[OP_CLOSE]		(nfsd4_dec)nfsd4_decode_close,
> -	[OP_COMMIT]		(nfsd4_dec)nfsd4_decode_commit,
> -	[OP_CREATE]		(nfsd4_dec)nfsd4_decode_create,
> -	[OP_DELEGPURGE]		(nfsd4_dec)nfsd4_decode_notsupp,
...
> +	NFSD4_DEC_OP(OP_ACCESS, nfsd4_decode_access),
> +	NFSD4_DEC_OP(OP_CLOSE, nfsd4_decode_close),
> +	NFSD4_DEC_OP(OP_COMMIT, nfsd4_decode_commit),
> +	NFSD4_DEC_OP(OP_CREATE, nfsd4_decode_create),
> +	NFSD4_DEC_OP(OP_DELEGPURGE, nfsd4_decode_notsupp),

and just add equals signs, if there's no substantial objection.

--b.

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9b6a9ba..d4b9d09 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1000,43 +1000,43 @@ nfsd4_decode_notsupp(struct nfsd4_compoundargs *argp, void *p)
 typedef __be32(*nfsd4_dec)(struct nfsd4_compoundargs *argp, void *);
 
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
+	[OP_ACCESS]		= (nfsd4_dec)nfsd4_decode_access,
+	[OP_CLOSE]		= (nfsd4_dec)nfsd4_decode_close,
+	[OP_COMMIT]		= (nfsd4_dec)nfsd4_decode_commit,
+	[OP_CREATE]		= (nfsd4_dec)nfsd4_decode_create,
+	[OP_DELEGPURGE]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_DELEGRETURN]	= (nfsd4_dec)nfsd4_decode_delegreturn,
+	[OP_GETATTR]		= (nfsd4_dec)nfsd4_decode_getattr,
+	[OP_GETFH]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_LINK]		= (nfsd4_dec)nfsd4_decode_link,
+	[OP_LOCK]		= (nfsd4_dec)nfsd4_decode_lock,
+	[OP_LOCKT]		= (nfsd4_dec)nfsd4_decode_lockt,
+	[OP_LOCKU]		= (nfsd4_dec)nfsd4_decode_locku,
+	[OP_LOOKUP]		= (nfsd4_dec)nfsd4_decode_lookup,
+	[OP_LOOKUPP]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_NVERIFY]		= (nfsd4_dec)nfsd4_decode_verify,
+	[OP_OPEN]		= (nfsd4_dec)nfsd4_decode_open,
+	[OP_OPENATTR]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_OPEN_CONFIRM]	= (nfsd4_dec)nfsd4_decode_open_confirm,
+	[OP_OPEN_DOWNGRADE]	= (nfsd4_dec)nfsd4_decode_open_downgrade,
+	[OP_PUTFH]		= (nfsd4_dec)nfsd4_decode_putfh,
+	[OP_PUTPUBFH]		= (nfsd4_dec)nfsd4_decode_notsupp,
+	[OP_PUTROOTFH]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_READ]		= (nfsd4_dec)nfsd4_decode_read,
+	[OP_READDIR]		= (nfsd4_dec)nfsd4_decode_readdir,
+	[OP_READLINK]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_REMOVE]		= (nfsd4_dec)nfsd4_decode_remove,
+	[OP_RENAME]		= (nfsd4_dec)nfsd4_decode_rename,
+	[OP_RENEW]		= (nfsd4_dec)nfsd4_decode_renew,
+	[OP_RESTOREFH]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_SAVEFH]		= (nfsd4_dec)nfsd4_decode_noop,
+	[OP_SECINFO]		= (nfsd4_dec)nfsd4_decode_secinfo,
+	[OP_SETATTR]		= (nfsd4_dec)nfsd4_decode_setattr,
+	[OP_SETCLIENTID]	= (nfsd4_dec)nfsd4_decode_setclientid,
+	[OP_SETCLIENTID_CONFIRM] = (nfsd4_dec)nfsd4_decode_setclientid_confirm,
+	[OP_VERIFY]		= (nfsd4_dec)nfsd4_decode_verify,
+	[OP_WRITE]		= (nfsd4_dec)nfsd4_decode_write,
+	[OP_RELEASE_LOCKOWNER]	= (nfsd4_dec)nfsd4_decode_release_lockowner,
 };
 
 struct nfsd4_minorversion_ops {
@@ -1045,7 +1045,7 @@ struct nfsd4_minorversion_ops {
 };
 
 static struct nfsd4_minorversion_ops nfsd4_minorversion[] = {
-	[0] { nfsd4_dec_ops, ARRAY_SIZE(nfsd4_dec_ops) },
+	[0] = { nfsd4_dec_ops, ARRAY_SIZE(nfsd4_dec_ops) },
 };
 
 static __be32
@@ -2577,42 +2577,42 @@ nfsd4_encode_noop(struct nfsd4_compoundres *resp, __be32 nfserr, void *p)
 typedef __be32(* nfsd4_enc)(struct nfsd4_compoundres *, __be32, void *);
 
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
+	[OP_ACCESS]		= (nfsd4_enc)nfsd4_encode_access,
+	[OP_CLOSE]		= (nfsd4_enc)nfsd4_encode_close,
+	[OP_COMMIT]		= (nfsd4_enc)nfsd4_encode_commit,
+	[OP_CREATE]		= (nfsd4_enc)nfsd4_encode_create,
+	[OP_DELEGPURGE]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_DELEGRETURN]	= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_GETATTR]		= (nfsd4_enc)nfsd4_encode_getattr,
+	[OP_GETFH]		= (nfsd4_enc)nfsd4_encode_getfh,
+	[OP_LINK]		= (nfsd4_enc)nfsd4_encode_link,
+	[OP_LOCK]		= (nfsd4_enc)nfsd4_encode_lock,
+	[OP_LOCKT]		= (nfsd4_enc)nfsd4_encode_lockt,
+	[OP_LOCKU]		= (nfsd4_enc)nfsd4_encode_locku,
+	[OP_LOOKUP]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_LOOKUPP]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_NVERIFY]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_OPEN]		= (nfsd4_enc)nfsd4_encode_open,
+	[OP_OPEN_CONFIRM]	= (nfsd4_enc)nfsd4_encode_open_confirm,
+	[OP_OPEN_DOWNGRADE]	= (nfsd4_enc)nfsd4_encode_open_downgrade,
+	[OP_PUTFH]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_PUTPUBFH]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_PUTROOTFH]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_READ]		= (nfsd4_enc)nfsd4_encode_read,
+	[OP_READDIR]		= (nfsd4_enc)nfsd4_encode_readdir,
+	[OP_READLINK]		= (nfsd4_enc)nfsd4_encode_readlink,
+	[OP_REMOVE]		= (nfsd4_enc)nfsd4_encode_remove,
+	[OP_RENAME]		= (nfsd4_enc)nfsd4_encode_rename,
+	[OP_RENEW]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_RESTOREFH]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_SAVEFH]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_SECINFO]		= (nfsd4_enc)nfsd4_encode_secinfo,
+	[OP_SETATTR]		= (nfsd4_enc)nfsd4_encode_setattr,
+	[OP_SETCLIENTID]	= (nfsd4_enc)nfsd4_encode_setclientid,
+	[OP_SETCLIENTID_CONFIRM] = (nfsd4_enc)nfsd4_encode_noop,
+	[OP_VERIFY]		= (nfsd4_enc)nfsd4_encode_noop,
+	[OP_WRITE]		= (nfsd4_enc)nfsd4_encode_write,
+	[OP_RELEASE_LOCKOWNER]	= (nfsd4_enc)nfsd4_encode_noop,
 };
 
 void
