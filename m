Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbXH2RRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbXH2RRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXH2RRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:17:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39935 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbXH2RRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:17:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828230459.GA15937@infradead.org>
	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
	<46D4CC81.4060400@zytor.com>
	<m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>
	<20070829114604.242b976c@the-village.bc.nu>
Date: Wed, 29 Aug 2007 11:16:26 -0600
In-Reply-To: <20070829114604.242b976c@the-village.bc.nu> (Alan Cox's message
	of "Wed, 29 Aug 2007 11:46:04 +0100")
Message-ID: <m1absa5kid.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> >> adequate job of warning our users.  A printk when we run a program
>> >> that uses the binary interface and an long enough interval the warning
>> >> makes it to the Enterprise kernels before we remove the interface
>> >> should be sufficient.
>
> The enterprise products will probably just remove the printk. Even if
> they didn't you are looking at ten years before things finish changing
> based on current experiences, probably longer as things stabilize.
>
> The whole "whine a bit" process simply doesn't work when you are trying
> to persuade people to move in a non-hobbyist context. They don't want to
> move, the message is simply an annoyance, their upstream huge package
> vendor won't change just to deal with it and they'll class it as a
> regression from previous releases, an incompatibility and file bugs until
> it goes away.

My hypothesis.  No one cares now.

My observation. The way we have been maintaining the binary sysctl
side of things using it is asking for your application to be broken in
subtle and nasty ways.

If that is true none of your enterprise concerns apply because it isn't
used, or we will be breaking the enterprise application by accident
anyway in a much more difficult way to diagnose.

Right now there is only one way to find out.  Plan on removing it
and see what the fallout really is.

If the grace period needs to be longer then 2 years I have no problem
upping it.  If my hypothesis is wrong and there are real users who
care that aren't easy to change I don't mind keeping it.

> Its user ABI and as Linus said - we don't break it. Trimming down all the
> crap that never worked via sysctl is one thing, not putting sysctl in new
> platforms likewise. Trying to undo it isn't going to work

Then this will fail and we will have a good case for maintaining
sys_sysctl.  No breaking user space is the point of the grace period.

At the rate things are going now I suspect that we will wind up
removing sys_sysctl one entry at a time as we discover new and
interesting ways that the code has been broken through bad
maintenance.

I am very much in favor of not breaking user space, and preserving
a binary ABI.  I think we can best avoiding breaking user space
applications by getting them to avoid sys_sysctl, and getting
them to stop if they already are.

This isn't "Oh some apps are using it let's get them to stop, because
it is inconvenient".  This is  "No apps seems to be using this, we
keep goofing up the maintenance and no one notices, and so it is
likely a source of security problems and other nasties"

I have evidence that there are 1 or 2 open source applications using
this (not counting the glibc weirdness).  Although the ones I have
found were either old installers or were already patched to not
do this in some of the distros, or in the case of glibc really don't
care.   So currently I believe that after we spread the word far and
wide in a way that people will listen to no one will have any real
complaints and the proof that it is safe to remove will be complete.

Eric
