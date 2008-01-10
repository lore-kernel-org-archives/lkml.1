Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYAJIoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYAJIoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYAJIoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:44:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40331 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYAJIop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:44:45 -0500
Date: Thu, 10 Jan 2008 08:44:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Dushistov <dushistov@mail.ru>, Steven <stevenaaus@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: ufs: fix symlink creation on ufs2
Message-ID: <20080110084425.GB27894@ZenIV.linux.org.uk>
References: <20080102204649.GA16373@rain> <20080109235148.d5896897.akpm@linux-foundation.org> <20080110084040.GD10745@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110084040.GD10745@infradead.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 08:40:41AM +0000, Christoph Hellwig wrote:
> On Wed, Jan 09, 2008 at 11:51:48PM -0800, Andrew Morton wrote:
> > > +++ b/fs/ufs/super.c
> > > @@ -131,6 +131,8 @@ static void ufs_print_super_stuff(struct super_block *sb,
> > >  		printk(KERN_INFO"  cs_nffree(Num of free frags): %llu\n",
> > >  		       (unsigned long long)
> > >  		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
> > > +		printk(KERN_INFO"  fs_maxsymlinklen: %u\n",
> > > +		       usb3->fs_un2.fs_44.fs_maxsymlinklen);
> > 
> > I assume this needs conversion via fs32_to_cpu() before we print it.
> 
> Yes, it does.  I wish people would run sparse before submitting patches :P

sparse wouldn't have helped it in the current state.  The thing is, it
doesn't understand printf-style formats.  We probably ought to implement
that - would have a benefit of being able to get rid of gcc stupidity
in that area and actually define conversion specifiers of our own for
things like u64, dma_addr_t, etc. without having gcc scream at us...
