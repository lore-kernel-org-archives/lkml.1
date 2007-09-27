Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbXI0O2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbXI0O2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXI0O2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:28:23 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43746 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbXI0O2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:28:22 -0400
Date: Thu, 27 Sep 2007 10:28:00 -0400
Message-Id: <200709271428.l8RES0t8002300@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: roel <12o3l@tiscali.nl>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 13/25] Unionfs: add un/likely conditionals on dir ops 
In-reply-to: Your message of "Wed, 26 Sep 2007 23:40:34 +0200."
             <46FAD1D2.8030306@tiscali.nl> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <46FAD1D2.8030306@tiscali.nl>, roel writes:
> Erez Zadok wrote:
> 
> > @@ -194,7 +194,7 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
> >  
> >  	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode));
> >  
> > -	if ((err = unionfs_partial_lookup(dentry)))
> > +	if (unlikely((err = unionfs_partial_lookup(dentry))))
> >  		goto out;
> >  
> >  	bstart = dbstart(dentry);
> 
> Is it bad to leave this assignment within the unlikely()?

I don't know.  Anyone?  Will un/likely "break" in the above form?

Actually, it looks like assignments within conditionals are just prohibited
(even if you use double parentheses to shut gcc up :-).  It's not mentioned
in the CodingStyle, but it is in scripts/checkpatch.pl.  So I'll have to
take out all those assignments out of the conditionals anyway.  Good.  It
makes code more readable (and besides, most modern compilers will optimize
it just the same).

Cheers,
Erez.
