Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbXFWRQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbXFWRQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758661AbXFWRQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:16:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:1531 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbXFWRQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:16:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OYogYI34pkXKDfJTtjUbjZXJZy0GmkjPLiYOBSVjKUIioUdWKpDF2foF45cAkkw+fBRYXDXc/rrwByp83iOjukANQDqaZXc1OylbsLK2G6i4EmLNeFKMlMg2aRYwIOXqmIm6aLK2kIRF17W3ZiMLEVqfINXX5aOjac2IK9bmjiU=
Message-ID: <a781481a0706231016i51c8534q918b4cb89126ede7@mail.gmail.com>
Date: Sat, 23 Jun 2007 22:46:09 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: "upping" a semaphore from interrupt context?
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Florin Iucha" <florin@iucha.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706231209490.15371@localhost.localdomain>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Sat, 23 Jun 2007, Satyam Sharma wrote:
>
> > Hi Robert, Arnd,
> >
> > On 6/23/07, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Saturday 23 June 2007, Robert P. J. Day wrote:
> > > > On Fri, 22 Jun 2007, Arnd Bergmann wrote:
> > > > >
> > > > > yes, but you should not. The use of semaphores is not recommended
> > > > > for new code, it should be replaced with either a mutex or a
> > > > > completion.
> > > >
> > > > can you clarify this? it sounds like you're saying that the current
> > > > implementation of semaphores is entirely superfluous. but surely it
> > > > isn't possible to replace all semaphores with either mutexes or
> > > > completions, is it?
> >
> > Semaphores being used as completions are superfluous, obsoleted by
> > completion handlers. Semaphores that are not counted (hence binary)
> > are superfluous, obsoleted by struct mutex.
>
> hang on, how is that true?  as i read it, mutexes are more than just
> binary semaphores -- they have additional restrictions that regular
> semaphores don't.

Yes, they do have additional restrictions (mutex_trylock() illegal from
contexts that cannot sleep, mutexes may only be unlocked by tasks
that took them in the first place). But note that these are
_implementation_ sanity checks that were introduced to catch
nonsensical usage, which was possible (and not explicitly being
guarded against, because of the generic-ness that was needed to
be maintained for the counted case too) with the "semaphore"s.

> so i'm not convinced that binary semaphores can
> simply be replaced by mutexes, unless that's not what you meant here.

I do mean precisely that. I really cannot think of any sensible / normal
usage case of binary semaphores that cannot be replaced with either
mutexes (if that's the kind of locking you actually want) or completion
handlers (if that's the kind of synchronization you actually want).

Satyam
