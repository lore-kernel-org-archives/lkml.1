Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYG2QVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYG2QVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYG2QVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:21:07 -0400
Received: from xenotime.net ([66.160.160.81]:53493 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751955AbYG2QVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:21:06 -0400
Date: Tue, 29 Jul 2008 09:21:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Paul Menage" <menage@google.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Matthew Wilcox" <matthew@wil.cx>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from
 down_trylock()
Message-Id: <20080729092102.14e6d964.rdunlap@xenotime.net>
In-Reply-To: <200807292301.18733.rusty@rustcorp.com.au>
References: <200807291015.02865.rusty@rustcorp.com.au>
	<6599ad830807281727r63a57a1g11972c5395828aae@mail.gmail.com>
	<200807292301.18733.rusty@rustcorp.com.au>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 23:01:17 +1000 Rusty Russell wrote:

> On Tuesday 29 July 2008 10:27:15 Paul Menage wrote:
> > On Mon, Jul 28, 2008 at 5:15 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > +/**
> > > + * down_try - try to down a semaphore, but don't block
> > > + * @sem: the semaphore
> >
> > Is there a reason to avoid using a return type of "bool" for this?
> 
> Probably, but not a good one.
> 
> This incorporates Andrew's whitespace fix as well (ie:
> introduce-down_try-so-we-can-move-away-from-down_trylock.patch and
> introduce-down_try-so-we-can-move-away-from-down_trylock-checkpatch-fixes.patch)
> 
> Introduce down_try()
> 
> I planned on removing the much-disliked down_trylock() (with its
> backwards return codes) in 2.6.27, but it's creating something of a
> logjam with other patches in -mm and linux-next.
> 
> Andrew suggested introducing "down_try" as a wrapper now, to make
> the transition easier.

Hi Rusty,

Will you also be making updates to Documentation/DocBook/kernel-locking.tmpl ?


> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/semaphore.h |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff -r 92664ae4130b include/linux/semaphore.h
> --- a/include/linux/semaphore.h	Wed May 21 14:54:40 2008 +1000
> +++ b/include/linux/semaphore.h	Wed May 21 15:07:31 2008 +1000
> @@ -48,4 +48,18 @@ extern int __must_check down_timeout(str
>  extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
>  extern void up(struct semaphore *sem);
>  
> +/**
> + * down_try - try to down a semaphore, but don't block
> + * @sem: the semaphore
> + *
> + * This is equivalent to down_trylock(), but has the same return codes as
> + * spin_trylock and mutex_trylock: 1 if semaphore acquired, 0 if not.
> + *
> + * down_trylock() with its confusing return codes will be deprecated
> + * soon.  It will not be missed.
> + */
> +static inline bool __must_check down_try(struct semaphore *sem)
> +{
> +	return !down_trylock(sem);
> +}
>  #endif /* __LINUX_SEMAPHORE_H */


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
