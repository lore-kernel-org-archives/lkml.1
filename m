Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYFYBxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYFYBxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYFYBwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:52:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57197 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751473AbYFYBwv (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:52:51 -0400
Message-ID: <4861A4E8.1060101@sgi.com>
Date: Wed, 25 Jun 2008 11:52:40 +1000
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: linux-next: Tree for June 24 (XFS x2)
References: <20080624175612.cdf29651.sfr@canb.auug.org.au> <20080624171809.42bbdf68.randy.dunlap@oracle.com> <20080625003751.GP29319@disturbed> <4861A00E.6040801@sgi.com>
In-Reply-To: <4861A00E.6040801@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timothy Shimmin wrote:
>>> 2. ACL's undefined
>>>
>>>   CC      fs/xfs/linux-2.6/xfs_xattr.o
>>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c: In function 'xfs_decode_acl':
>>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: '_ACL_TYPE_ACCESS' undeclared (first use in this function)
>>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: (Each undeclared identifier is reported only once
>>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: for each function it appears in.)
>>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:42: error: '_ACL_TYPE_DEFAULT' undeclared (first use in this function)
>>> make[3]: *** [fs/xfs/linux-2.6/xfs_xattr.o] Error 1
>> And this will be a !CONFIG_XFS_POSIX_ACL build, I think.
>>
> Yep. I didn't test the hch patch without CONFIG_XFS_POSIX_ACL. Oops.
> 
> xfs_acl.h:
> 
> #ifdef CONFIG_XFS_POSIX_ACL
> ...
> #define _ACL_TYPE_ACCESS        1
> #define _ACL_TYPE_DEFAULT       2
> ...
> #endif
> 
> There is a bunch of ACL code in linux-2.6/xfs_xattr.c.
> Possibly we could just modify xfs_acl.h as I think most other calls
> have the non CONFIG'ed versions.
> I'll have a look.
> 

So we could move up the acl defines in xfs_acl.h.
Unless Christoph wants some other rearrangement...

Index: 2.6.x-xfs-quilt/fs/xfs/xfs_acl.h
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_acl.h	2008-06-25 10:46:42.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_acl.h	2008-06-25 11:45:25.221045485 +1000
@@ -46,6 +46,8 @@ typedef struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+#define _ACL_TYPE_ACCESS	1
+#define _ACL_TYPE_DEFAULT	2
 
 #ifdef CONFIG_XFS_POSIX_ACL
 
@@ -66,8 +68,6 @@ extern int xfs_acl_vset(bhv_vnode_t *, v
 extern int xfs_acl_vget(bhv_vnode_t *, void *, size_t, int);
 extern int xfs_acl_vremove(bhv_vnode_t *, int);
 
-#define _ACL_TYPE_ACCESS	1
-#define _ACL_TYPE_DEFAULT	2
 #define _ACL_PERM_INVALID(perm)	((perm) & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
 
 #define _ACL_INHERIT(c,m,d)	(xfs_acl_inherit(c,m,d))
