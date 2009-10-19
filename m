Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZJSJtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZJSJtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZJSJtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:49:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:34574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZJSJtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:49:06 -0400
Date: Mon, 19 Oct 2009 11:49:09 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] brlock: introduce special brlocks
Message-ID: <20091019094909.GC27856@wotan.suse.de>
References: <20091015044026.319860788@suse.de> <20091015050048.777261867@suse.de> <20091018222512.683973f7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018222512.683973f7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 10:25:12PM -0700, Andrew Morton wrote:
> On Thu, 15 Oct 2009 15:40:30 +1100 npiggin@suse.de wrote:
> 
> > +#define DECLARE_BRLOCK(name)						\
> 
> This:
> 
> > + DECLARE_PER_CPU(spinlock_t, name##_lock);				\
> > + static inline void name##_lock_init(void) {				\
> > +	int i;								\
> > +	for_each_possible_cpu(i) {					\
> > +		spinlock_t *lock;					\
> > +		lock = &per_cpu(name##_lock, i);			\
> > +		spin_lock_init(lock);					\
> > +	}								\
> > + }									\
> > + static inline void name##_rlock(void) {				\
> > +	spinlock_t *lock;						\
> > +	lock = &get_cpu_var(name##_lock);				\
> > +	spin_lock(lock);						\
> > + }									\
> 
> generates a definition, not a declaration.  Hence DEFINE_BRLOCK.
> 
> </petpeeve #29>

Well yes, but being a static inline, then I don't know of a better 
way. Probably just better not to pretend we are expanding a simple
declaration here, and name it something differently? (BRLOCK_HEADER(blah))?

