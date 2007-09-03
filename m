Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbXICOJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbXICOJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 10:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXICOJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 10:09:41 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33915 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXICOJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 10:09:39 -0400
Date: Mon, 3 Sep 2007 10:08:25 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 09/32] Unionfs: cache-coherency - dentries
Message-ID: <20070903140825.GB22745@filer.fsl.cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu> <11887860564008-git-send-email-jsipek@cs.sunysb.edu> <Pine.LNX.4.64.0709030849260.4454@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709030849260.4454@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 08:52:17AM +0200, Jan Engelhardt wrote:
> 
> On Sep 2 2007 22:20, Josef 'Jeff' Sipek wrote:
> >@@ -184,10 +183,92 @@ out:
> > }
> > 
> > /*
> >+ * Determine if the lower inode objects have changed from below the unionfs
> >+ * inode.  Return 1 if changed, 0 otherwise.
> >+ */
> >+int is_newer_lower(const struct dentry *dentry)
> 
> Could use bool and true/false as return value.
 
I remember that way back when there was a discussion about the bool type.
What how did that end? Is bool preferred?

> >-int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd)
> >+int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
> >+				 int willwrite)
> 
> also looks like a bool (willwrite)

Right.

> >-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
> >+	if (!__unionfs_d_revalidate_chain(dentry, NULL, 0)) {
> 
> (Are there any callers with ,1?)

Indirectly yes. There are callers that pass a value they get. Very large
majority is 0.

Jeff.

-- 
Bad pun of the week: The formula 1 control computer suffered from a race
condition

