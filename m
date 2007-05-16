Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbXEPLjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbXEPLjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbXEPLjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:39:43 -0400
Received: from lazybastard.de ([212.112.238.170]:48278 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328AbXEPLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:39:42 -0400
Date: Wed, 16 May 2007 13:35:20 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516113519.GC5472@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <adar6pho5n3.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adar6pho5n3.fsf@cisco.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 19:37:36 -0700, Roland Dreier wrote:
> 
> There are rather a lot of of FIXME comments, including scary stuff like
> 
>  > +	/*
>  > +	 * FIXME: this cannot be right but it does "fix" a bug of i_count
>  > +	 * dropping too low.  Needs more thought.
>  > +	 */
>  > +	atomic_inc(&old_dentry->d_inode->i_count);

Any thoughts on this would be appreciated.

> and
> 
>  > +int __logfs_write_inode(struct inode *inode)
>  > +{
>  > +	/*
>  > +	 * FIXME: Those two inodes are 512 bytes in total.  Not good to
>  > +	 * have on the stack.  Possibly the best solution would be to bite
>  > +	 * the bullet and do another format change before release and
>  > +	 * shrink the inodes.
>  > +	 */
>  > +	struct logfs_disk_inode old, new;
> 
> are you going to change the format?  or fix this some other way?

I would love to put my inodes on a diet.  It is just a matter of time
and priorities.  To me the 512 bytes on the stack are unfortunate, but
not a show stopper.  Crash behaviour is, so that has priority.

> I think a sweep through the code searching for FIXME and at least
> rewriting all such comments to look like stuff that can be deferred
> would be warranted ;)

Are you asking me to hide known problems under a rug? ;)

Will see if I can easily fix some of these.  In particular the
eat-your-data FIXME that can cause LogFS to not survive a crash.

Jörn

-- 
Correctness comes second.
Features come third.
Performance comes last.
Maintainability is easily forgotten.
