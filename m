Return-Path: <linux-kernel-owner+w=401wt.eu-S965660AbXCGV0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965660AbXCGV0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992611AbXCGV0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:26:39 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52811 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965659AbXCGV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:26:38 -0500
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070307124658.515d8fb5.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 7 Mar 2007 12:46:58 -0800)
Subject: Re: [patch 8/8] consolidate generic_writepages and mpage_writepages
 fix
References: <20070306180443.669036741@szeredi.hu>
	<20070306180557.611121214@szeredi.hu> <20070307124658.515d8fb5.akpm@linux-foundation.org>
Message-Id: <E1HP3eB-0001nV-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Mar 2007 22:26:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Fix NULL pointer dereference in __mpage_writepage.  This probably
> > doesn't matter in practice, but this is the original behavior.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > ---
> > 
> > Index: linux/fs/mpage.c
> > ===================================================================
> > --- linux.orig/fs/mpage.c	2007-03-06 17:30:09.000000000 +0100
> > +++ linux/fs/mpage.c	2007-03-06 17:30:33.000000000 +0100
> > @@ -662,7 +662,7 @@ confused:
> >  	if (bio)
> >  		bio = mpage_bio_submit(WRITE, bio);
> >  
> > -	if (mpd->use_writepage) {
> > +	if (mpd->use_writepage && mapping->a_ops->writepage) {
> >  		ret = mapping->a_ops->writepage(page, wbc);
> >  	} else {
> >  		ret = -EAGAIN;
> > 
> > --
> 
> I'm inclined to leave the code as-is, as an optimisation.  If it
> blows up then it'd be cleaner to change the caller (mpage_writepages)
> to do
> 
> 	.use_writepage = (writepage != NULL),
> 
> ?

It seems all in-tree uses of mpage_writepages define ->writepage() so
it should be safe to drop this patch.

Thanks,
Miklos
