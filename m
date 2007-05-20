Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXETL6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXETL6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXETL6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:58:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:56635 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbXETL57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q18SFGLKe5r6o3Dh4RQJHzVLjTTrJt7UOoDCNlILXzcWUwVTe+R53GeNWLhBG0vrMBV7jPS2babcE2PiOOFvLbBfz7n5kXLiMccnAU5LMW3Z2O5iD11I4mCsMd/LPVQyH/Wrvm7qAQsDWeEAOfMn9yo64ex4Zct7UYrasAz8jYE=
Message-ID: <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>
Date: Sun, 20 May 2007 17:27:58 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <46503542.50300@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>
	 <464F9A7B.1030708@s5r6.in-berlin.de>
	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>
	 <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>
	 <4650074A.6000307@s5r6.in-berlin.de>
	 <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>
	 <46503542.50300@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Satyam Sharma wrote:
> > On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> However you fix it --- don't remove "depends on" or "select".  You can
> >> interchange them, but not remove them, unless there wasn't a dependency
> >> to begin with.
> >
> > They _can_ be removed, with absolutely no build failures at all, because
> > of the "default y if ..." on the dependency that is defined in some
> > arch/.../Kconfig.
>
> You are right, they can be removed, and the Kconfig files can be turned
> into an unmaintainable mess.
>
>         A requires B
>
> Maintainable.
>
>         B serves A
>
> Logically equivalent, yet unmaintainable.

Well, whether it is readable / maintainable is subjective and hence
debatable. I was only answering your *completely misplaced and
incorrect* original comment against the patch where you claimed
that the patch was "totally wrong" because of the way it removed
the "select" ... etc ...

And remember, like I said already, the whole _idea_ is such arch-
specific helper code be not mentioned from arch-agnostic Kconfig
files. You may not like it, but this is the standard / most common way
such cases are handled for tons of other cases in arch/.... Which
is why Adrian's way of solving this (shifting all such arch-specific
helper symbols also to drivers/... and then using depends on select
on it) is not viable.
