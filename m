Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbZIJUnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbZIJUnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZIJUnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:43:40 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:57810 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbZIJUni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:43:38 -0400
Subject: Re: [PATCH 18/16] implement posix O_SYNC and O_DSYNC semantics
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       drepper@redhat.com, viro@zeniv.linux.org.uk, kyle@mcmartin.ca
In-Reply-To: <20090910204026.GA20797@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
	 <20090910202521.GA20261@lst.de>
	 <1252615120.8722.148.camel@heimdal.trondhjem.org>
	 <20090910204026.GA20797@lst.de>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 16:43:35 -0400
Message-Id: <1252615415.8722.150.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 17 msgs/h 3 sum rcpts/h 20 sum msgs/h 4 total rcpts 1399 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: B1159F8F19CC23832D34B853CFB6AC6D7D8F1C7C
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 3 total 242 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 22:40 +0200, Christoph Hellwig wrote:
> On Thu, Sep 10, 2009 at 04:38:40PM -0400, Trond Myklebust wrote:
> > >  	return vfs_fsync_range(file, file->f_path.dentry, pos,
> > > -			       pos + count - 1, 1);
> > > +			       pos + count - 1,
> > > +			       (file->f_flags & O_SYNC) ? 1 : 0);
> > >  }
> > >  EXPORT_SYMBOL(generic_write_sync);
> > >  
> > Shouldn't this be testing for
> > 
> >    file->f_flags & __O_SYNC
> > 
> > ?
> 
> Doesn't matter, we check early in the open path that __O_SYNC is only
> set together with O_SYNC.

Right, but (file->f_flags & O_SYNC) will be non-zero even if only the
O_DSYNC flag is set.


