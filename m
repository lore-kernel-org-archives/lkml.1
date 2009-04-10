Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbZDJQsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbZDJQsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758276AbZDJQrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:47:51 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:42624 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZDJQrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:47:51 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #5 28/29] export lookup functions 
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20090410162849.GA28377@infradead.org>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp> <1239346963-30953-29-git-send-email-hooanon05@yahoo.co.jp> <20090410162849.GA28377@infradead.org>
Date: Sat, 11 Apr 2009 01:47:15 +0900
Message-ID: <7612.1239382035@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig:
> Strong NACK to all these exports, no one has any buesiness looking at
> these.

Will you tell me why?
If you have ever discussed exporting lookup_hash(), then please tell me
its URL or something.

lookup_hash is necessary for aufs since,

(from the mail "Subject: [RFC Aufs2 #5 01/29] aufs documents")
+Lookup in a Branch
+----------------------------------------------------------------------
+Since aufs has a character of sub-VFS (see Introduction), it operates
+lookup for branches as VFS does. It may be a heavy work. Generally
+speaking struct nameidata is a bigger structure and includes many
+information. But almost all lookup operation in aufs is the simplest
+case, ie. lookup only an entry directly connected to its parent. Digging
+down the directory hierarchy is unnecessary.
+
+VFS has a function lookup_one_len() for that use, but it is not usable
+for a branch filesystem which requires struct nameidata. So aufs
+implements a simple lookup wrapper function. When a branch filesystem
+allows NULL as nameidata, it calls lookup_one_len(). Otherwise it builds
+a simplest nameidata and calls lookup_hash().
+Here aufs applies "a principle in NFSD", ie. if the filesystem supports
+NFS-export, then it has to support NULL as a nameidata parameter for
+->create(), ->lookup() and ->d_revalidate(). So the lookup wrapper in
+aufs tests if ->s_export_op in the branch is NULL or not.


J. R. Okajima
