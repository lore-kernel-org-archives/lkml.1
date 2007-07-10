Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbXGJC3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbXGJC3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762272AbXGJC2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:28:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:38276 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762420AbXGJC2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:28:00 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:27:55 +1000
Message-Id: <1070710022755.13554@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Usha Ketineni <ketineni@us.ibm.com>
Cc: Usha Ketineni <uketinen@us.ibm.com>
Subject: [PATCH 016 of 20] knfsd: rpc: add gss krb5 and spkm3 oid values
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Usha Ketineni <ketineni@us.ibm.com>

Adds oid values to the gss_api mechanism structures.  On the NFSV4
server side, these are required as part of the security triple
(oid,qop,service) information being sent in the response of the SECINFO
operation.

Signed-off-by: Usha Ketineni <uketinen@us.ibm.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/auth_gss/gss_krb5_mech.c  |    1 +
 ./net/sunrpc/auth_gss/gss_spkm3_mech.c |    1 +
 2 files changed, 2 insertions(+)

diff .prev/net/sunrpc/auth_gss/gss_krb5_mech.c ./net/sunrpc/auth_gss/gss_krb5_mech.c
--- .prev/net/sunrpc/auth_gss/gss_krb5_mech.c	2007-07-10 11:19:53.000000000 +1000
+++ ./net/sunrpc/auth_gss/gss_krb5_mech.c	2007-07-10 11:51:00.000000000 +1000
@@ -231,6 +231,7 @@ static struct pf_desc gss_kerberos_pfs[]
 static struct gss_api_mech gss_kerberos_mech = {
 	.gm_name	= "krb5",
 	.gm_owner	= THIS_MODULE,
+	.gm_oid		= {9, (void *)"\x2a\x86\x48\x86\xf7\x12\x01\x02\x02"},
 	.gm_ops		= &gss_kerberos_ops,
 	.gm_pf_num	= ARRAY_SIZE(gss_kerberos_pfs),
 	.gm_pfs		= gss_kerberos_pfs,

diff .prev/net/sunrpc/auth_gss/gss_spkm3_mech.c ./net/sunrpc/auth_gss/gss_spkm3_mech.c
--- .prev/net/sunrpc/auth_gss/gss_spkm3_mech.c	2007-07-10 11:19:53.000000000 +1000
+++ ./net/sunrpc/auth_gss/gss_spkm3_mech.c	2007-07-10 11:51:00.000000000 +1000
@@ -217,6 +217,7 @@ static struct pf_desc gss_spkm3_pfs[] = 
 static struct gss_api_mech gss_spkm3_mech = {
 	.gm_name	= "spkm3",
 	.gm_owner	= THIS_MODULE,
+	.gm_oid		= {7, "\053\006\001\005\005\001\003"},
 	.gm_ops		= &gss_spkm3_ops,
 	.gm_pf_num	= ARRAY_SIZE(gss_spkm3_pfs),
 	.gm_pfs		= gss_spkm3_pfs,
