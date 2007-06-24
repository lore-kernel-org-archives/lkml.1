Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbXFXQp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbXFXQp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 12:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFXQpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 12:45:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:49781 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXFXQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 12:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PUtd38K1QihrD34QFgR+kWjshIBOUZY5xqYl1QQrRu/SK9pUkZQlVLTzr33cLy/UjL9JpXgw7rB54U3g5uyr6cBFVxkG+F7oO5JR4LgGZn9t5M0OcRV4o7/lkQbEtOM2mG0eYOSU3kdXbxAM0QJJ7OPbGtGEk8/jEiF+9CiQMv4=
Message-ID: <a781481a0706240945j3a8afe8dkbb6b74d92bdedfc4@mail.gmail.com>
Date: Sun, 24 Jun 2007 22:15:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: "upping" a semaphore from interrupt context?
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Florin Iucha" <florin@iucha.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706241123130.7006@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622173839.GB8398@iucha.net>
	 <200706221934.18436.arnd@arndb.de>
	 <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain>
	 <200706231402.03617.arnd@arndb.de>
	 <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
	 <Pine.LNX.4.64.0706231209490.15371@localhost.localdomain>
	 <a781481a0706231016i51c8534q918b4cb89126ede7@mail.gmail.com>
	 <Pine.LNX.4.64.0706241123130.7006@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On 6/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Sat, 23 Jun 2007, Satyam Sharma wrote:
>
> > On 6/23/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
> > > hang on, how is that true?  as i read it, mutexes are more than
> > > just binary semaphores -- they have additional restrictions that
> > > regular semaphores don't.
> >
> > Yes, they do have additional restrictions (mutex_trylock() illegal
> > from contexts that cannot sleep, mutexes may only be unlocked by
> > tasks that took them in the first place). But note that these are
> > _implementation_ sanity checks that were introduced to catch
> > nonsensical usage, which was possible (and not explicitly being
> > guarded against, because of the generic-ness that was needed to be
> > maintained for the counted case too) with the "semaphore"s.
> >
> > > so i'm not convinced that binary semaphores can simply be replaced
> > > by mutexes, unless that's not what you meant here.
> >
> > I do mean precisely that. I really cannot think of any sensible /
> > normal usage case of binary semaphores that cannot be replaced with
> > either mutexes (if that's the kind of locking you actually want) or
> > completion handlers (if that's the kind of synchronization you
> > actually want).
>
> ok, i can see what you're getting at now.  i'm just going to have to
> convince myself that, once you have mutexes and completions, you have
> no further need for even general counting semaphores.

Whoa, hold on. But I've been explicitly mentioning *binary* semaphores
all along!

Of course users who want / allow multiple tasks (but only upto a specific
maximum number, which is what counted semaphores are all about)
to be present in a given critical section simultaneously would still want
to use the _counted_ semaphores, which is why you won't see the old
"struct semaphores" dying anytime soon.

Satyam
