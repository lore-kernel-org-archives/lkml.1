Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbZKFWIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbZKFWIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbZKFWGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:06:01 -0500
Received: from kroah.org ([198.145.64.141]:39803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792AbZKFWGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:06:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:53 2009
Message-Id: <20091106215952.988107330@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [23/30] nfs: Avoid overrun when copying client IP address string
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=nfs-avoid-overrun-when-copying-client-ip-address-string.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ben Hutchings <ben@decadent.org.uk>

commit f4373bf9e67e4a653c8854acd7b02dac9714c98a upstream.

As seen in <http://bugs.debian.org/549002>, nfs4_init_client() can
overrun the source string when copying the client IP address from
nfs_parsed_mount_data::client_address to nfs_client::cl_ipaddr.  Since
these are both treated as null-terminated strings elsewhere, the copy
should be done with strlcpy() not memcpy().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -983,7 +983,7 @@ static int nfs4_init_client(struct nfs_c
 					RPC_CLNT_CREATE_DISCRTRY);
 	if (error < 0)
 		goto error;
-	memcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
+	strlcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
 
 	error = nfs_idmap_new(clp);
 	if (error < 0) {


