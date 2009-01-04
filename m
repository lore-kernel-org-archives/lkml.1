Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZADJYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZADJYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 04:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZADJXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 04:23:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58205 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZADJXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 04:23:51 -0500
Date: Sun, 4 Jan 2009 04:23:49 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: Christoph Hellwig <hch@infradead.org>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 2015 of file
	fs/xfs/xfs_da_btree.c
Message-ID: <20090104092349.GA26194@infradead.org>
References: <49600DE6.2080108@shikadi.net> <20090104074659.GA16775@infradead.org> <49607B5B.3070707@shikadi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49607B5B.3070707@shikadi.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 07:03:23PM +1000, Adam Nielsen wrote:
> No, I didn't realise I had to do that...in fact I didn't even realise 
> SATA disks *had* write caches, I thought the cache was for reading 
> only...

Which would be the better default (it's what high-end disks generally
do by default).  I've been wondering for a while how we can make default
setups in the presence of lvm/dm more secure, but there hasn't been
any progress yet.

>> Run xfs_repair over it to fix up the directory, and make sure to
>> configure your disks properly so that it doesn't happen again..
>
> Will do, thanks for the advice!  Is there any standard way to disable 
> write caching on a SATA disk?  hdparm -W seems to do the trick, but then 
> I can't run that until the system is up and running, leaving a small 
> window of opportunity for something to go wrong.

On Debian based systems you can add -W0 to /etc/default/hdparm and
it gets executed before the root filesystem is remounted read-write,
I'm not sure how other distributions handle it.

