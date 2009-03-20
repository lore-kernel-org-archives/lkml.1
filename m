Return-Path: <linux-kernel-owner+w=401wt.eu-S1761032AbZCTXPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032AbZCTXPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbZCTXNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:38 -0400
Received: from kroah.org ([198.145.64.141]:53043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756303AbZCTXNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:09 2009
Message-Id: <20090320222709.714598497@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Benny Halevy <bhalevy@panasas.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [patch 05/32] NFSD: provide encode routine for OP_OPENATTR
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=nfsd-provide-encode-routine-for-op_openattr.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benny Halevy <bhalevy@panasas.com>

commit 84f09f46b4ee9e4e9b6381f8af31817516d2091b upstream.

Although this operation is unsupported by our implementation
we still need to provide an encode routine for it to
merely encode its (error) status back in the compound reply.

Thanks for Bill Baker at sun.com for testing with the Sun
OpenSolaris' client, finding, and reporting this bug at
Connectathon 2009.

This bug was introduced in 2.6.27

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2593,6 +2593,7 @@ static nfsd4_enc nfsd4_enc_ops[] = {
 	[OP_LOOKUPP]		= (nfsd4_enc)nfsd4_encode_noop,
 	[OP_NVERIFY]		= (nfsd4_enc)nfsd4_encode_noop,
 	[OP_OPEN]		= (nfsd4_enc)nfsd4_encode_open,
+	[OP_OPENATTR]		= (nfsd4_enc)nfsd4_encode_noop,
 	[OP_OPEN_CONFIRM]	= (nfsd4_enc)nfsd4_encode_open_confirm,
 	[OP_OPEN_DOWNGRADE]	= (nfsd4_enc)nfsd4_encode_open_downgrade,
 	[OP_PUTFH]		= (nfsd4_enc)nfsd4_encode_noop,


