Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbXETNuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbXETNuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXETNua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:50:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:35151 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbXETNu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MLmh+SqtgAZvh4R3iAC6FlFD2DL3QQlnPAdbijVWRTbWWQLyZuo3UXI5cH6YPS9tyYR6dpthWsPPNNo9yiEEGs9ThP/aTuD9/PNzc4VgP0M43UN9VIShN7UWwREeq1cFCARXf8v+yDVQTY8crF/a4Y5ALGCWS/A2TT1yN4I0fMM=
Message-ID: <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>
Date: Sun, 20 May 2007 19:20:25 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <46504876.9040802@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>
	 <464F9A7B.1030708@s5r6.in-berlin.de>
	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>
	 <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>
	 <4650074A.6000307@s5r6.in-berlin.de>
	 <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>
	 <46503542.50300@s5r6.in-berlin.de>
	 <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>
	 <46504876.9040802@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Satyam Sharma wrote:
> > I was only answering your *completely misplaced and
> > incorrect* original comment against the patch where you claimed
> > that the patch was "totally wrong" because of the way it removed
> > the "select" ... etc ...
>
> I believe I have explained why I labeled it as totally wrong.

Because it is not "readable"? Umm, "*totally wrong*" is a pretty strong
comment to make just because _you_ find something less readable /
maintainable! Anyway, your initial post did give the impression that
you weren't aware of the "default y if ..." mechanism at all, and so
somehow thought the removal of select would cause some graver
problems because somehow the "dependency on XYZ which was
implied by select XYZ" had been lost by the removal of select ... etc.

> > And remember, like I said already, the whole _idea_ is such arch-
> > specific helper code be not mentioned from arch-agnostic Kconfig
> > files. You may not like it, but this is the standard / most common way
> > such cases are handled for tons of other cases in arch/...
>
> The standard and maintainable way (for drivers at least) is
>
> config A
>         bool-or-tristate "option A"
>         depends on !PLATFORM_X || HELPER_N_ON_PLATFORM_X

??? I didn't get this entry, can you give a solid example (you can consider
the case at hand, MOUSE_ATARI and ATARI_KBD_CORE itself). Better
still, if you really think that the above is a better way to solve the
problem at
hand, why don't you submit a patch instead?

> It is not a matter of me disliking something.  It's a matter of that we
> can easily determine what A needs, but have a hard time to determine and
> maintain the dependencies in the reverse way.
>
> BTW, if A needs platform-specific helper N, then A is not
> platform-agnostic.  If A is desired to be platform-agnostic, then either
> A has to be implemented independently of N or N has to be made available
> on all platforms.

What you are suggesting is not practically possible / convenient. See, we
_want_ MOUSE_ATARI to appear in the arch-agnostic area which is along
with the other input devices and hence it is placed in drivers/input/Kconfig.
However, it does depend on arch-specific helper code. This is a real issue,
and we can't simply wish it away.

> > Which is why Adrian's way of solving this (shifting all such
> > arch-specific helper symbols also to drivers/... and then using depends
> > on select on it) is not viable.
>
> I'm not advocating any specific fixes or pseudo-fixes.  I'm advocating
> the notation of dependencies in the direction "A requires B".

See, if you really _still_ think this could / should be done some better
way (which is more maintainable, does not cause build failures and
also does not cause those bogus warnings to be printed etc etc),
then please submit a patch instead.

> These things really should be shifted into the UIs as much as possible,
> because we can have a number of special-purpose UIs but we want
> all-purpose Kconfig files.

Well, the shortcomings of Kconfig / build scripts that you mentioned are
are somewhat valid indeed, but as I said, unless you or someone submits
patches to clear up the above issues, we do need to solve problems within
that framework itself, isn't it?

Thanks,
Satyam
