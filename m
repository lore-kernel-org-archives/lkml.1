Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZIJXSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZIJXSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZIJXSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:18:38 -0400
Received: from verein.lst.de ([213.95.11.210]:33349 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZIJXSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:18:37 -0400
Date: Fri, 11 Sep 2009 01:18:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, drepper@redhat.com, viro@zeniv.linux.org.uk,
       kyle@mcmartin.ca
Subject: Re: [PATCH 18/16] implement posix O_SYNC and O_DSYNC semantics
Message-ID: <20090910231816.GA27220@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz> <20090910202521.GA20261@lst.de> <20090910230755.GQ9372@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910230755.GQ9372@webber.adilger.int>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 01:07:55AM +0200, Andreas Dilger wrote:
> > + * Note: __O_SYNC must never be used directly.
> 
> Doesn't it make sense that applications that actually know what they are
> doing may want to start using __O_SYNC directly at some point in the
> future?  It makes sense to code the kernel to handle both of these flags
> appropriately (i.e. if __O_SYNC is set, but O_DSYNC is not then treat
> this as the proper "O_SYNC").

What would be the benefit of that?  Setting two bits vs one in a data
structure is not going to make any difference, and the way it's done in
this patch is actually much easier to implement in the kernel.

> > Index: linux-2.6/arch/alpha/include/asm/fcntl.h
> > ===================================================================
> > --- linux-2.6.orig/arch/alpha/include/asm/fcntl.h	2009-09-10 16:31:47.720004025 -0300
> > +++ linux-2.6/arch/alpha/include/asm/fcntl.h	2009-09-10 16:33:55.087294444 -0300
> >  #define O_CLOEXEC	010000000 /* set close_on_exec */
> > +#define __O_SYNC	010000000
> 
> These two flags have the same value...

Thanks, corrected.
