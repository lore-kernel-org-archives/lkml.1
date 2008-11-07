Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYKGXzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYKGXzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYKGXzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:55:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:54837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYKGXzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:55:38 -0500
Date: Fri, 7 Nov 2008 15:55:20 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org
Subject: Re: Linux 2.6.27.5
Message-ID: <20081107235520.GA6155@suse.de>
References: <20081107233437.GA5036@kroah.com> <20081107233456.GB5036@kroah.com> <alpine.LFD.2.00.0811071543370.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811071543370.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 03:44:49PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 7 Nov 2008, Greg KH wrote:
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 3d9120c..6bfb849 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1286,7 +1286,9 @@ struct task_struct {
> >  	atomic_t fs_excl;	/* holding fs exclusive resources */
> >  	struct rcu_head rcu;
> >  
> > -	/*
> > +	struct list_head	*scm_work_list;
> > +
> > +/*
> >  	 * cache last used pipe for splice
> >  	 */
> >  	struct pipe_inode_info *splice_pipe;
> 
> You did somethign wrong here when merging that scm_destroy() fix. See the 
> badly indented comment start.

Ugh, you are right, it should be indented.  Cut and paste caused that :(

I'll fix it up in the next version, there shouldn't be any problem as
it's just a formatting issue.  I had to do it by hand compared to the
upstream version as the field structures were different between the
kernel versions.  I moved it higher up in the structure so there
wouldn't be merge issues on .25 and .26 as well.

I'll go fix up the patch in those 2 review series too, as it's also
formatted wrong there.

thanks,

greg k-h
