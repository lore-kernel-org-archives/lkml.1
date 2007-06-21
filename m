Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbXFUEcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbXFUEcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXFUEbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:31:04 -0400
Received: from ns1.suse.de ([195.135.220.2]:41718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXFUEbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:31:02 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:30:52 +1000
Message-Id: <1070621043052.1096@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Benny Halevy <bhalevy@panasas.com>
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 004 of 8] knfsd: nfsd4: fix enc_stateid_sz for nfsd callbacks
References: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "J. Bruce Fields" <bfields@fieldses.org>


enc_stateid_sz should be given in u32 words units, not bytes, so we were
overestimating the buffer space needed here.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4callback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/fs/nfsd/nfs4callback.c ./fs/nfsd/nfs4callback.c
--- .prev/fs/nfsd/nfs4callback.c	2007-06-21 13:46:38.000000000 +1000
+++ ./fs/nfsd/nfs4callback.c	2007-06-21 14:10:31.000000000 +1000
@@ -75,7 +75,7 @@ enum nfs_cb_opnum4 {
 #define op_enc_sz			1
 #define op_dec_sz			2
 #define enc_nfs4_fh_sz			(1 + (NFS4_FHSIZE >> 2))
-#define enc_stateid_sz			16
+#define enc_stateid_sz			(NFS4_STATEID_SIZE >> 2)
 #define NFS4_enc_cb_recall_sz		(cb_compound_enc_hdr_sz +       \
 					1 + enc_stateid_sz +            \
 					enc_nfs4_fh_sz)
