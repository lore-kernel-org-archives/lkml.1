Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbYEEKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbYEEKBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759860AbYEEKBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:01:31 -0400
Received: from styx.suse.cz ([82.119.242.94]:43551 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759855AbYEEKBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:01:30 -0400
Date: Mon, 5 May 2008 12:01:28 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] quota: Add a convenience macro for filesystems
Message-ID: <20080505100128.GA25722@duck.suse.cz>
References: <12095679813226-git-send-email-jack@suse.cz> <12095679812375-git-send-email-jack@suse.cz> <12095679812452-git-send-email-jack@suse.cz> <1209567981639-git-send-email-jack@suse.cz> <1209567981323-git-send-email-jack@suse.cz> <12095679812717-git-send-email-jack@suse.cz> <12095679824183-git-send-email-jack@suse.cz> <20080430122911.61945aa9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430122911.61945aa9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-08 12:29:11, Andrew Morton wrote:
> On Wed, 30 Apr 2008 17:06:18 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > Note that it cannot be an inline function because we don't have struct
> > super_block prototype...
> > 
> 
> lame excuse ;)
  Well, yes but since fs.h includes quota.h to be able to define struct
super_block (needs at least MAXQUOTAS constant) this is kind of chicken and
egg problem. Splitting quota.h into two files is probably the way to go...
I'll include it to my quotaops.h and quota.h cleanups I'm slowly working
on.

> > ---
> >  include/linux/quota.h |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/quota.h b/include/linux/quota.h
> > index 52e49dc..dcddfb2 100644
> > --- a/include/linux/quota.h
> > +++ b/include/linux/quota.h
> > @@ -347,6 +347,9 @@ struct quota_info {
> >  	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
> >  			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
> >  
> > +#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
> > +				  sb_has_quota_suspended(sb, GRPQUOTA))
> > +
> >  int register_quota_format(struct quota_format_type *fmt);
> >  void unregister_quota_format(struct quota_format_type *fmt);
> 
> 
> Here's a fun exercise:
> 
> 	sb = sb_orig;
> 	sb_any_quota_suspended(sb++);
> 	printk("%d\n", sb - sb_orig);
> 
> afaict this will print 44 or thereabouts.
> 
> ho hum.
  ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
