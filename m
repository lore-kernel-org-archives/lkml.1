Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYFYBcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYFYBcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYFYBcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:32:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52998 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752290AbYFYBcJ (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:32:09 -0400
Message-ID: <4861A00E.6040801@sgi.com>
Date: Wed, 25 Jun 2008 11:31:58 +1000
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: linux-next: Tree for June 24 (XFS x2)
References: <20080624175612.cdf29651.sfr@canb.auug.org.au> <20080624171809.42bbdf68.randy.dunlap@oracle.com> <20080625003751.GP29319@disturbed>
In-Reply-To: <20080625003751.GP29319@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Tue, Jun 24, 2008 at 05:18:09PM -0700, Randy Dunlap wrote:
>> XFS shows 2 build problems today.
>>
>> 1. xfs_stats.h problem
>>
>>   CC      fs/xfs/xfs_rtalloc.o
>> In file included from /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_linux.h:91,
>>                  from /local/linsrc/linux-next-20080624/fs/xfs/xfs.h:44,
>>                  from /local/linsrc/linux-next-20080624/fs/xfs/xfs_rtalloc.c:18:
>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_stats.h: In function 'xfs_init_procfs':
>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_stats.h:150: error: expected ';' before '}' token
>> make[3]: *** [fs/xfs/xfs_rtalloc.o] Error 1
> 
> This will be a !CONFIG_PROC_FS change.
> 
> Lachlan/Niv - This is the guilty party:
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=e0fe783155e4f1c7106f3579c258b9f995330c19
> 
> The commit log is:
> 
> [XFS]
>  
>  SGI-PV: 111111
>  SGI-Modid: xfs-linux-melb:xfs-kern:31210a
>  
>  Signed-off-by: Niv Sardi <xaiki@sgi.com>
>  Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> ---
> 
> What the hell happened here? Where's the commit title, description
> so this can be tracked back to a real patch?  That PV# is also bogus....

tcsh> p_modinfo -h xfs-linux-melb:xfs-kern:31210a

mod xfs-linux-melb:xfs-kern:31210a header
==========================================
 - SM_Location:	 longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
 - Workarea:	 itchy.melbourne.sgi.com:/home/xaiki/Wrk/git/pmod2git
 - xfs-linux-melb:xfs-kern:31210a 05/21/08
 - PV Incidents affected:
 - Inspected by:
 - Description:
 - Files affected:  xfs_da_btree.c 1.179, xfs_vfsops.c 1.567,
   xfs_mount.h 1.269, xfs_error.c 1.60, xfs_error.h 1.49,
   support/uuid.h 1.13, support/uuid.c 1.21,
   linux-2.6/xfs_stats.c 1.23, linux-2.6/xfs_stats.h 1.15,
   linux-2.6/xfs_super.c 1.428, linux-2.6/xfs_sysctl.c 1.43,
   linux-2.6/xfs_sysctl.h 1.28, xfs_mru_cache.c 1.6,
   xfs_filestream.c 1.5
 - Author:	 xaiki

Well there wasn't much in the ptools checkin either.
No pv, inspected-by or description. One for Niv...

> 
> I suspect that it is this patch:
> 
> http://oss.sgi.com/archives/xfs/2008-05/msg00322.html
> 
> Which means that the Signed-Off-By list is incorrect as well as the original
> patch came from Christoph. This can't go to mainline like this - the commit log
> needs to be fixed up.
> 
The signed-off, because there was no description or inspected-by, would just fall back
to the author and who checked it in.
The ptools checkin was stuffed.

>> 2. ACL's undefined
>>
>>   CC      fs/xfs/linux-2.6/xfs_xattr.o
>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c: In function 'xfs_decode_acl':
>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: '_ACL_TYPE_ACCESS' undeclared (first use in this function)
>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: (Each undeclared identifier is reported only once
>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:40: error: for each function it appears in.)
>> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_xattr.c:42: error: '_ACL_TYPE_DEFAULT' undeclared (first use in this function)
>> make[3]: *** [fs/xfs/linux-2.6/xfs_xattr.o] Error 1
> 
> And this will be a !CONFIG_XFS_POSIX_ACL build, I think.
> 
Yep. I didn't test the hch patch without CONFIG_XFS_POSIX_ACL. Oops.

xfs_acl.h:

#ifdef CONFIG_XFS_POSIX_ACL
...
#define _ACL_TYPE_ACCESS        1
#define _ACL_TYPE_DEFAULT       2
...
#endif

There is a bunch of ACL code in linux-2.6/xfs_xattr.c.
Possibly we could just modify xfs_acl.h as I think most other calls
have the non CONFIG'ed versions.
I'll have a look.

> Christoph - this is part of your change to use the generic ACL stuff,
> can you have a look?
> 
--Tim
