Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYFYB5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYFYB5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYFYB53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:57:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751473AbYFYB52 (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:57:28 -0400
Message-ID: <4861A6EB.6050806@sgi.com>
Date: Wed, 25 Jun 2008 12:01:15 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: linux-next: Tree for June 24 (XFS x2)
References: <20080624175612.cdf29651.sfr@canb.auug.org.au> <20080624171809.42bbdf68.randy.dunlap@oracle.com> <20080625003751.GP29319@disturbed>
In-Reply-To: <20080625003751.GP29319@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
> 
> I suspect that it is this patch:
> 
> http://oss.sgi.com/archives/xfs/2008-05/msg00322.html
> 
> Which means that the Signed-Off-By list is incorrect as well as the original
> patch came from Christoph. This can't go to mainline like this - the commit log
> needs to be fixed up.

We knew this checkin was stuffed up and I was planning to fix it in the for-linus
branch before pushing to mainline.  The merge tools had kittens when it came across
it too.  I think we need to rip it out of ptools and re-checkin it in with the
correct details.

> 
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
> Christoph - this is part of your change to use the generic ACL stuff,
> can you have a look?
> 
> Cheers,
> 
> Dave.
