Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbXKWSQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbXKWSQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 13:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXKWSQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 13:16:12 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41108 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXKWSQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 13:16:11 -0500
Date: Fri, 23 Nov 2007 19:16:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Christoph Hellwig <hch@infradead.org>
cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] Clean up open coded inode dirty checks
In-Reply-To: <20071123180239.GA13229@infradead.org>
Message-ID: <Pine.LNX.4.64.0711231914300.12552@fbirervta.pbzchgretzou.qr>
References: <20071122004422.GO114266761@sgi.com> <20071123180239.GA13229@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 23 2007 18:02, Christoph Hellwig wrote:
>
>> +STATIC_INLINE int xfs_inode_clean(xfs_inode_t *ip)
>> +{
>> +	return (((ip->i_itemp == NULL) ||
>> +		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
>> +		(ip->i_update_core == 0));
>> +}
>
>Can we please get rid of this useless STATIC_INLINE junk?  It's really
>hurting my eyes.
>
>As does to a lesser extent the verbose style of this
>function.

I have to disagree, but whatever.

>static inline int xfs_inode_clean(struct xfs_inode *ip)
               ^                   ^
could be bool - and const
>{
>	return (!ip->i_itemp ||
>	        !(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
>	       !ip->i_update_core;
>}

Perhaps for greater readability:

static inline bool xfs_inode_clean(const struct xfs_inode *ip)
{
	if (ip->i_itemp == NULL)
		return true;
	if (!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL) &&
	    ip->i_update_core == NULL)
		return true;
	return false;
}
