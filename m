Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXITPCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXITPCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbXITPCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:02:44 -0400
Received: from rex.snapgear.com ([203.143.235.140]:35662 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755533AbXITPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:02:44 -0400
Date: Fri, 21 Sep 2007 01:03:14 +1000
From: David McCullough <David_Mccullough@securecomputing.com>
To: Paul Mundt <lethal@linux-sh.org>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       miles@lsi.nec.co.jp, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
Message-ID: <20070920150314.GA27079@securecomputing.com>
References: <1190102965.4406.9.camel@roc-desktop> <200709192131.09469.rgetz@blackfin.uclinux.org> <20070920015525.GA16615@securecomputing.com> <20070920031807.GA31263@linux-sh.org> <46F261CA.50201@t-online.de> <20070920142543.GA3268@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920142543.GA3268@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Paul Mundt lays it down ...
...
> > The other maintainers who have spoken up didn't seem to think this was 
> > ugly, or an abuse.  I'm surprised to hear language like that when 
> > discussing a patch that adds an if statement, a local variable and one 
> > parameter in a function call.
> > 
> Yes, well, the scope of the changes is really rather irrelevant, it's the
> technical basis behind it that should be the concern. My suggestion was
> to lose the local variable, get rid of this "persistent" API, and plug in
> something like flat_validate_relval() or something equally silly where
> each architecture has the option to grab the relval and set up whatever
> sort of state it wants to out-of-line.
> 
> This is making API changes where it's convenient for your platform to use
> this value, and there's no reason to change the API here at all. The
> if/continue block are not an issue, it is the whole concept of persistent
> data in this case that has no need to be applied uniformally across all
> other architectures.
> 
> Why should all architectures have to change their APIs (not just adding
> new things mind you, also changing existing definitions) to accomodate
> something that can trivially be kept in the blackfin code?

Fair comment.  I hadn't considered that it could be even cleaner.
If it's easily doable then I agree with your concerns.

> I wager the other maintainers either a) don't care because it doesn't
> effect them, or b) have resigned binfmt_flat to its fate. Neither option
> is particularly appealing in terms of getting that code tidied. That sort
> of indifference is largely why binfmt_flat is as much of a mess as it is
> today. Your patch is certainly not the cause of this, the architecture
> callbacks there are just a mess to begin with, I would prefer that we try
> to keep new additions flexible without blindly hardcoding more usage
> assumptions all over the place and having to paper over them again later.

I would say that (a) is definately not the case.  I am sure the BF guys
will say they have been banging us on the head with changes for a long
time and getting no where as we considered the changes to severe or out
of line.

This particular patch was trivial in comparison to others I've seen,
it fixed all the existing arches (not something that is always done) and
seemed a reasonable start to finally get the BF guys up and running.
Still, happy to make it better of course ;-)

As for (b),  I think it will be around for a while.  It's not as flexible
as fdpic,  but it's still a tiny, simple format and not everyone has an
fdpic implementation yet :-)

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
