Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbXKWUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbXKWUQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 15:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbXKWUQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 15:16:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53040 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbXKWUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 15:16:06 -0500
Date: Fri, 23 Nov 2007 21:16:05 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] Clean up open coded inode dirty checks
In-Reply-To: <1195847251.4930.21.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711232110400.12552@fbirervta.pbzchgretzou.qr>
References: <20071122004422.GO114266761@sgi.com>  <20071123180239.GA13229@infradead.org>
  <Pine.LNX.4.64.0711231914300.12552@fbirervta.pbzchgretzou.qr>
 <1195847251.4930.21.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 23 2007 11:47, Joe Perches wrote:
>On Fri, 2007-11-23 at 19:16 +0100, Jan Engelhardt wrote:
>> static inline bool xfs_inode_clean(const struct xfs_inode *ip)
>> {
>> 	if (ip->i_itemp == NULL)
>> 		return true;
>> 	if (!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL) &&
>> 	    ip->i_update_core == NULL)
>> 		return true;
>> 	return false;
>> }
>
>Your code changed the test.

See - the previous cryptic constructs could not even be decoded ;-)

>xfs_inode.i_update_core is an unsigned char.
>
>I believe reordering the tests to avoid a possibly
>unnecessary dereference is better.
>
>	if (ip->i_update_core)
>		return false;
>	if (!ip->i_itemp)
>		return true;
>	return ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL;

Yeah, something like that.

Note: the function SHOULD return bool for this, to quash the
ilf_fields & XFS_ILOG_ALL into 0/1.
