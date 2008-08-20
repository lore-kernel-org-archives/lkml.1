Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbYHTTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbYHTTwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYHTTwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:52:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbYHTTwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:52:15 -0400
Date: Wed, 20 Aug 2008 12:50:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jayakumar.lkml@gmail.com, npiggin@suse.de,
       a.p.zijlstra@chello.nl, hugh@veritas.com, hannes@saeurebad.de,
       jeremy@goop.org, kel@otaku42.de, armbru@redhat.com
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
Message-Id: <20080820125033.1cfcc2f1.akpm@linux-foundation.org>
In-Reply-To: <1219261254.3996.54.camel@localhost.localdomain>
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	<20080818233824.5d219105.akpm@linux-foundation.org>
	<1219220003.3996.29.camel@localhost.localdomain>
	<20080820013736.ec64baae.akpm@linux-foundation.org>
	<1219258673.3996.46.camel@localhost.localdomain>
	<20080820123056.8f0c9d3f.akpm@linux-foundation.org>
	<1219261254.3996.54.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 20:40:54 +0100
Ian Campbell <ijc@hellion.org.uk> wrote:

> On Wed, 2008-08-20 at 12:30 -0700, Andrew Morton wrote:
> > On Wed, 20 Aug 2008 19:57:53 +0100 Ian Campbell <ijc@hellion.org.uk>
> > wrote:
> >  	}
> > > +#ifdef CONFIG_FB_DEFERRED_IO
> > > +	if (info->fbdefio)
> > > +		fb_deferred_io_open(info, inode, file);
> > > +#endif
> > 
> > eww, hacky, but drivers/video/fbmem.c already got hacky:
> > 
> > #ifdef CONFIG_FB_DEFERRED_IO
> >         .fsync =        fb_deferred_io_fsync,
> > #endif
> > 
> > so it's not an original sin.
> 
> That's what I figured.

A better implementation would be to change the fb_ops.fb_open()
arguments, or to add fb_ops.fb_open2() with the file*.

Also, that .fsync thing should be done properly via a new fb_ops.fb_fsync().

But neither are pressing issues and I guess can be left for when Jaya
is feeling bored?

> > Does it work?
> 
> Yep.

OK, thanks, I guess we're done with this for now.
