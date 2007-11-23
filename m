Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbXKWTr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbXKWTr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 14:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbXKWTru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 14:47:50 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1314 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184AbXKWTru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 14:47:50 -0500
Subject: Re: [PATCH 9/9] Clean up open coded inode dirty checks
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711231914300.12552@fbirervta.pbzchgretzou.qr>
References: <20071122004422.GO114266761@sgi.com>
	 <20071123180239.GA13229@infradead.org>
	 <Pine.LNX.4.64.0711231914300.12552@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Fri, 23 Nov 2007 11:47:31 -0800
Message-Id: <1195847251.4930.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-23 at 19:16 +0100, Jan Engelhardt wrote:
> static inline bool xfs_inode_clean(const struct xfs_inode *ip)
> {
> 	if (ip->i_itemp == NULL)
> 		return true;
> 	if (!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL) &&
> 	    ip->i_update_core == NULL)
> 		return true;
> 	return false;
> }

Your code changed the test.
xfs_inode.i_update_core is an unsigned char.

I believe reordering the tests to avoid a possibly
unnecessary dereference is better.

	if (ip->i_update_core)
		return false;
	if (!ip->i_itemp)
		return true;
	return ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL;


