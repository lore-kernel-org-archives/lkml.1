Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbYCFBZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbYCFBZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933364AbYCFBYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:24:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:51294 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbYCFBYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=siYINPtEZKiy2/vQh/l5Mf/g/IDjXj7yAchUa89t2uk36nd6ZsErdLoOZQYtO+LGyL0bWkj6+Dj6tyzWQM+YFwjIYSAKkV+gbkBJ6jIeDgEJLzsfcDOMKkiSf3XV5WtZepmyImipvzPpVZ4SsPm8eEBiYIMFTObWOuiJusyOZZ4=
Date: Thu, 6 Mar 2008 04:02:24 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: implement dynamic base allocation
Message-ID: <20080306010224.GA25717@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080304170307.GA29979@localhost.localdomain> <20080305152450.167c9e8c.akpm@linux-foundation.org> <200803051540.57499.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200803051540.57499.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 03:40:57PM -0800, David Brownell wrote:
> On Wednesday 05 March 2008, Andrew Morton wrote:
> > On Tue, 4 Mar 2008 20:03:07 +0300
> > Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > 
> > > If gpio_chip->base is negative during registration, gpiolib requests
> > > dynamic base allocation. This is useful for devices being registered
> > > at run-time (in contrast to platform devices).
> > > 
> > > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > > ---
> > >  drivers/gpio/gpiolib.c |   42 ++++++++++++++++++++++++++++++++++++------
> > >  1 files changed, 36 insertions(+), 6 deletions(-)
> > > 
> > 
> > This conflicts in non-trivial ways with gpio-define-gpio_is_valid.patch. 
> > Could you please redo and retest against 2.6.25-rc3-mm1?

No problem, will rebase.

> And when you do that, could you make it assign GPIO numbers from
> the biggest number on down, instead of from the smallest on up?
> 
> Platforms normally assign those numbers from the bottom up ... so
> dynamic assignment should try to avoid reusing any numbers that may
> have been explicitly assigned, but not yet registered.  (Of course,
> if you can come up with a cleaner solution than that, it'd be great.
> Maybe platforms should also be able to mark ranges as "in use" as
> they start up, or something.)

Well, it is also trivial to implement gpiochip_reserve(start, end)
function that will mark reserved gpio->chip as ERR_PTR(-EACCESS),
and these ranges will be unavailable for the dynamic allocation.

Then, platforms could do gpiochip_reserve(0, GPIO_ARCH_END).
I think This is good solution from all and every POV, but this
needs a bit of platform code assistance.

What would you choice?

> And please add a pr_debug level message reporting dynamically
> assigned ranges.  That way, when problems crop up it'll be that
> much easier to notice what went wrong.

Will do.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
