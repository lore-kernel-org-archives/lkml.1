Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYEWEXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYEWEXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYEWEWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:22:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50029 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016AbYEWEWy (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:22:54 -0400
Date: Fri, 23 May 2008 14:22:31 +1000
From: David Chinner <dgc@sgi.com>
To: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, dgc@sgi.com, viro@ZenIV.linux.org.uk,
       harvey.harrison@gmail.com
Subject: Re: [PATCH][RFC]fix soft lock up at NFS mount by per-SB LRU-list of unused dentries
Message-ID: <20080523042231.GJ173056135@sgi.com>
References: <4834D8DA.30907@np.css.fujitsu.com> <20080522225608.GZ173056135@sgi.com> <483628B7.1080704@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483628B7.1080704@np.css.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 11:15:19AM +0900, Kentaro Makita wrote:
> Hi, David
> 
> Thank you for reviewing the patch.
> I'd fix coding style issues at next post. And,...
> 
> David Chinner wrote:
> > On Thu, May 22, 2008 at 11:22:18AM +0900, Kentaro Makita wrote:
> >> +			}
> >> +		}
> >> +	}
> > 
> > I'm wondering if this loop is an excessively long time to be holding the
> > dcache_lock. I guess the hol dtime is limited by the size of *count being
> > passed in. I think we could also do a:
> > 
> > 		cond_resched_lock(&dcache_lock);
> > 	
> > in the loop here to prevent this from occurring....
> Did you mean:
>  - scan sb->s_dentry_lru and move dentries to temporary list
>    with lock held
>  - cond_resched_lock(&dcache_lock);
>  - prune dentries on temporary list
> Is that right?

No, I meant while scanning sb->s_dentry_lru.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
