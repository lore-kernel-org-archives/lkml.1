Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXICGw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXICGw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 02:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbXICGwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 02:52:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33845 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbXICGwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 02:52:17 -0400
Date: Mon, 3 Sep 2007 08:52:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 09/32] Unionfs: cache-coherency - dentries
In-Reply-To: <11887860564008-git-send-email-jsipek@cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0709030849260.4454@fbirervta.pbzchgretzou.qr>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
 <11887860564008-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 2 2007 22:20, Josef 'Jeff' Sipek wrote:
>@@ -184,10 +183,92 @@ out:
> }
> 
> /*
>+ * Determine if the lower inode objects have changed from below the unionfs
>+ * inode.  Return 1 if changed, 0 otherwise.
>+ */
>+int is_newer_lower(const struct dentry *dentry)

Could use bool and true/false as return value.

>-int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd)
>+int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
>+				 int willwrite)

also looks like a bool (willwrite)

>-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
>+	if (!__unionfs_d_revalidate_chain(dentry, NULL, 0)) {

(Are there any callers with ,1?)



	Jan
-- 
