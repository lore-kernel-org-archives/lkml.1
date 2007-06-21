Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbXFUEbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbXFUEbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbXFUEau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:30:50 -0400
Received: from ns.suse.de ([195.135.220.2]:41703 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbXFUEas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:30:48 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:30:39 +1000
Message-Id: <1070621043039.1063@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 002 of 8] knfsd: nfsd4: fix NFSv4 filehandle size units confusion
References: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "J. Bruce Fields" <bfields@fieldses.org>


NFS4_FHSIZE is measured in bytes, not 4-byte words, so much more space
than necessary is being allocated for struct nfs4_cb_recall.

I should have wondered why this structure was so much larger than it
needed to be!

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/nfsd/state.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/include/linux/nfsd/state.h ./include/linux/nfsd/state.h
--- .prev/include/linux/nfsd/state.h	2007-06-21 13:46:39.000000000 +1000
+++ ./include/linux/nfsd/state.h	2007-06-21 14:09:31.000000000 +1000
@@ -67,7 +67,7 @@ struct nfs4_cb_recall {
 	int			cbr_trunc;
 	stateid_t		cbr_stateid;
 	u32			cbr_fhlen;
-	u32			cbr_fhval[NFS4_FHSIZE];
+	char			cbr_fhval[NFS4_FHSIZE];
 	struct nfs4_delegation	*cbr_dp;
 };
 
