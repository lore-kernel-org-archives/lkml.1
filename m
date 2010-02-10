Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0BKAyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:54:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab0BKAyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:54:51 -0500
Date: Wed, 10 Feb 2010 15:05:44 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and
 non-links
Message-ID: <20100210230544.GA678@suse.de>
References: <19314.1869.847327.15190@notabene.brown>
 <2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
 <4B7217CF.2080702@kernel.org>
 <m1vde57c11.fsf@fess.ebiederm.org>
 <4B728CFE.40208@kernel.org>
 <m1sk992bji.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1sk992bji.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 10:25:21AM -0800, Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
> > On 02/10/2010 05:03 PM, Eric W. Biederman wrote:
> >> Tejun Heo <tj@kernel.org> writes:
> >> 
> >>> Hello,
> >>>
> >>> On 02/10/2010 11:08 AM, Américo Wang wrote:
> >>>> This bug report is new for me. Recently we received lots of sysfs lockdep
> >>>> warnings, I am working on a patch to fix all the bogus ones.
> >>>>
> >>>> However, this one is _not_ similar to the other cases, as you decribed.
> >>>> This patch could fix the problem, but not a good fix, IMO. We need more
> >>>> work in sysfs layer to fix this kind of things. I will take care of this.
> >>>
> >>> Can't we just give each s_active lock a separate class?  Would that be
> >>> too costly?
> >> 
> >> When I asked the question earlier I was told that that locking classes
> >> require static storage.  Where would that static storage come from?
> >
> > Maybe I'm glossly misunderstanding it but wouldn't embedding struct
> > lockdep_map into sysfs_node as in work_struct do the trick?
> 
> In lockdep_init_map there is the following check:
> 
> 	/*
> 	 * Sanity check, the lock-class key must be persistent:
> 	 */
> 	if (!static_obj(key)) {
> 		printk("BUG: key %p not in .data!\n", key);
> 		DEBUG_LOCKS_WARN_ON(1);
> 		return;
> 	}
> 
> It needs playing with but I think we can embed something in struct
> attribute, and simply disallow dynamically allocated instances of
> struct attribute.

I think some code dynamically creates attributes today, as this has
never been a restriction.

So I don't know if this is going to work :(

thanks,

greg k-h
