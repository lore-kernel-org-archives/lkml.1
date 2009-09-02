Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZIBByL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZIBByL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 21:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZIBByK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 21:54:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49565 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752724AbZIBByK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 21:54:10 -0400
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Elder <aelder@sgi.com>
Message-Id: <F0C21C0B-E90E-44DF-B094-CC5F1DA7EDCE@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20090902012844.GA15549@lst.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: linux-next: xfs tree build failure
Date: Tue, 1 Sep 2009 20:54:07 -0500
References: <20090902112509.739ce995.sfr@canb.auug.org.au> <20090902012844.GA15549@lst.de>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 1, 2009, at 8:28 PM, Christoph Hellwig wrote:

> On Wed, Sep 02, 2009 at 11:25:09AM +1000, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>>
>> fs/xfs/xfs_ialloc.c:63: error: static declaration of  
>> 'xfs_inobt_lookup' follows non-static declaration
>> fs/xfs/xfs_ialloc.h:155: note: previous declaration of  
>> 'xfs_inobt_lookup' was here
>>
>> Caused by commit 2187550525d7bcb8c87689e4eca41b1955bf9ac3 ("xfs:
>> rationalize xfs_inobt_lookup*").
>
> I've sent a fix to the list about an hour ago:

I've reviewed it and picked it up right away.
Thanks, Christoph.


> Subject: [PATCH] xfs: un-static xfs_inobt_lookup
> From: Christoph Hellwig <hch@lst.de>
>
> xfs_inobt_lookup is also used in xfs_itable.c, remove the STATIC  
> modifier
> from it's declaration to fix non-debug builds.
>
> This was already fixed in my git tree vs the version last posted to  
> the
> list.

>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfs/fs/xfs/xfs_ialloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_ialloc.c	2009-09-01 20:47:28.515468366 -0300
> +++ xfs/fs/xfs/xfs_ialloc.c	2009-09-01 20:47:33.867913011 -0300
> @@ -59,7 +59,7 @@ xfs_ialloc_cluster_alignment(
> /*
>  * Lookup a record by ino in the btree given by cur.
>  */
> -STATIC int				/* error */
> +int					/* error */
> xfs_inobt_lookup(
> 	struct xfs_btree_cur	*cur,	/* btree cursor */
> 	xfs_agino_t		ino,	/* starting inode of chunk */
>>
>> I have used the version of the xfs tree from next-20090901 for today.

Argh! It was broken just for couple of hours.
The fix is now in official xfs tree as well.

Thanks,
Felix

>>
>> -- 
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>> http://www.canb.auug.org.au/~sfr/
>
>
> ---end quoted text---

