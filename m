Return-Path: <linux-kernel-owner+w=401wt.eu-S1762969AbYBSWli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762969AbYBSWli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbYBSWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:41:20 -0500
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:58223 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762018AbYBSWlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:41:18 -0500
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Unable to continue testing of 2.6.25
Date: Tue, 19 Feb 2008 23:41:14 +0100
User-Agent: KMail/1.9.7
Cc: Paul Jackson <pj@sgi.com>, Adrian Bunk <bunk@kernel.org>, tilman@imap.cc,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <200802171025.30590.elendil@planet.nl> <20080217143851.c21a9cc4.pj@sgi.com> <20080217125139.287c880f@laptopd505.fenrus.org>
In-Reply-To: <20080217125139.287c880f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192341.15060.elendil@planet.nl>
X-OriginalArrivalTime: 19 Feb 2008 22:41:16.0025 (UTC) FILETIME=[8968DE90:01C87348]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008, Arjan van de Ven wrote:
> On Sun, 17 Feb 2008 14:38:51 -0600 Paul Jackson <pj@sgi.com> wrote:
> > Adrian wrote:
> > > So let's fix the problem (kernel lacks functionality)
> >
> > That's the problem as understood by Adrian.
> >
> > I hear another problem as well ...
> >
> > Frans wrote:
> > > Please allow external users some decent period for transitioning.
> > > The initial plan to "remove the old function in 2.6.27" was
> > > entirely sensible. It's a pity it was not followed through.
> >
> > That seems plain enough to me.  It's not just the lack of
> > functionality, but that such lack apparently happened with too little
> > warning.
> >
> > If this is a fair representation of what happened, then seems to me
> > that we could have left that EXPORT_UNUSED_SYMBOL(change_page_attr)
> > in place a bit longer.
>
> it's not a fair repersentation. Again.. this export was unkeepable due to
> the API being nasty and having to be fixed anyway ;(.
>
> One of the problems was that the c-p-a api has to be followed by a cache
> flush function call. Sadly that does a TOTAL flush of the caches of all
> cpus in the system. As part of the -rc1 changes, it is now done only on
> the exact pages that need to be flushed (so you no longer flush 12Mb of
> caches when you only needed to flush 4Kb), but to achieve that, it was no
> longer an option to keep this as 2 separate function calls.
> Add to this that some very fundemanteal bugs couldn't be fixed without
> the function underlying cpa changing prototype and behavior, so the
> function had to go.

That's a much better explanation than can be found in the changelog.

The changelog effectively says: this commits makes a few (new) functions 
static; oh, and by the way, let's delete the old function _because it is 
unused and ugly_.

Well, I've shown that the first is not true and the second by itself is 
absolutely not sufficient reason to remove an exported function that has 
long been part of the kernel.
I would probably have started this thread differently if the removal had 
been done in a separate commit and had included the explanation you give 
above.

> I understand where he's coming from; at the same time it's a very small
> change to virtualbox to fix this and has been done already... in minutes.

The problem here is that it may be a simple change for you and other 
similarly gifted people, but it's something that's above _my_ skills.

> Frans should take that up with the virtual box support forum, I'm sure

I did actually manage to create such a patch for the breakage in the 
VirtualBox source because of 2.6.24, but those really were very minor 
issues (basically overlapping definitions). I posted that on their user 
list (to which I am subscribed), but I never saw any response to it.

I also don't think it is really realistic to expect Innotek to provide 
patches for unreleased kernel versions. Maybe some other user could provide 
me with the patch, but I'm not as confident as you are.

My point still is that I feel they should not have to. That it's also the 
kernel developers responsibility to ensure backwards compatibility or at 
least a grace period for conversion whenever possible.
And IMO that not only goes for user-space API, but also for interfaces used 
by out-of-tree kernel modules.

Is it really impossible in this case for example to rewrite the old function 
so that it becomes a wrapper around the new interface? If it is impossible, 
then so be it.

> they have the patch available there.

I haven't seen anything on the user mailing list yet...

On Tuesday 19 February 2008, Arjan van de Ven wrote:
> I assume you've read the other mails right and went to the virtualbox
> form to get the small patch to make it work on .25 right?

If you can give me a link to that patch, I'd be grateful. As I said, I'm 
subscribed to their user list but have not seen any patch there.
I've also googled for it, without result.
I've also just quickly checked their "VirtualBox on Linux" forum, but did 
not see any obvious existing post about it.

Cheers,
FJP
