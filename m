Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYCQNNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYCQNNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYCQNNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 09:13:47 -0400
Received: from styx.suse.cz ([82.119.242.94]:49671 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751746AbYCQNNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 09:13:46 -0400
Date: Mon, 17 Mar 2008 14:13:45 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add possibly missing iput() when quotaon and
	quotaoff races
Message-ID: <20080317131345.GB17307@duck.suse.cz>
References: <20080313120344.GB12523@duck.suse.cz> <20080313120552.GC12523@duck.suse.cz> <20080313144211.d32c58f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313144211.d32c58f2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-03-08 14:42:11, Andrew Morton wrote:
> On Thu, 13 Mar 2008 13:05:52 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > We should always put inode we have reference to, even if quota was reenabled
> > in the mean time.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > ---
> >  dquot.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/dquot.c b/fs/dquot.c
> > index f816d06..24eef58 100644
> > --- a/fs/dquot.c
> > +++ b/fs/dquot.c
> > @@ -1522,8 +1522,8 @@ int vfs_quota_off(struct super_block *sb, int type)
> >  				truncate_inode_pages(&toputinode[cnt]->i_data, 0);
> >  				mutex_unlock(&toputinode[cnt]->i_mutex);
> >  				mark_inode_dirty(toputinode[cnt]);
> > -				iput(toputinode[cnt]);
> >  			}
> > +			iput(toputinode[cnt]);
> >  			mutex_unlock(&dqopt->dqonoff_mutex);
> >  		}
> >  	if (sb->s_bdev)
> This one looks like 2.6.25 material?
  Yes, this can be nasty when triggered (Busy inodes after umount) and the
patch is safe.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
