Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbZLOMfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbZLOMfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbZLOMfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:35:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbZLOMfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:35:36 -0500
Date: Tue, 15 Dec 2009 13:35:31 +0100
From: Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <rjevskiy@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jan Kara <jack@suse.cz>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: ext3 tree build warning
Message-ID: <20091215123530.GB5405@quack.suse.cz>
References: <20091215105925.59a66556.sfr@canb.auug.org.au>
 <c18d6aa20912150158m1b77c17ey2dcfacb3aa86d67a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c18d6aa20912150158m1b77c17ey2dcfacb3aa86d67a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-12-09 12:58:36, Dmitry Monakhov wrote:
> 2009/12/15 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi Jan,
> >
> > Today's linux-next build (x86_64 allmodconfig) produced this warning:
> >
> > fs/quota/dquot.c: In function 'dquot_alloc_inode':
> > fs/quota/dquot.c:1521: warning: passing argument 1 of 'mark_all_dquot_dirty' discards qualifiers from pointer target type
> > fs/quota/dquot.c:327: note: expected 'struct dquot **' but argument is of type 'struct dquot * const*'
> > fs/quota/dquot.c: In function 'dquot_free_inode':
> > fs/quota/dquot.c:1649: warning: passing argument 1 of 'mark_all_dquot_dirty' discards qualifiers from pointer target type
> > fs/quota/dquot.c:327: note: expected 'struct dquot **' but argument is of type 'struct dquot * const*'
> What's why my original patch contained type casts.
> In fact i dont understand why {alloc,free}_inode accept pointer to
> const struct inode, it's contradicts to normal logic
  Does it? The 'const' keyword just promises we won't change struct inode.
And that is true. We only change structures that are pointed to from the
inode.  So the code is correct as is. 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
