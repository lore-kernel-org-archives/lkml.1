Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbXJ1Azq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbXJ1Azq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 20:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXJ1Azh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 20:55:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57578 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752017AbXJ1Azg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 20:55:36 -0400
Date: Sun, 28 Oct 2007 02:55:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: eradicating out of tree modules (was: : Linux Security
	*Module* Framework)
Message-ID: <20071028005555.GC23339@stusta.de>
References: <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47234F73.3040809@imap.cc>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 04:47:15PM +0200, Tilman Schmidt wrote:
> Adrian Bunk schrieb:
> > On Fri, Oct 26, 2007 at 11:46:39AM +0200, Tilman Schmidt wrote:
> >> On Thu, 25 Oct 2007 19:56:47 -0700, Greg KH wrote:
> >>> On Fri, Oct 26, 2007 at 01:09:14AM +0200, Tilman Schmidt wrote:
> >>>> [...] Once you admit that there is code which, for very good
> >>>> reasons, won't ever be accepted into the mainline kernel tree, what you
> >>>> are saying amounts to: "Code that isn't fit to be included in the
> >>>> mainline kernel isn't fit to exist at all."
> >>> What kind of code is not accepted into the mainline kernel tree for good
> >>> reasons?
> >> - proprietary code
> > 
> > It's unclear whether distributing not GPL compatible modules is legal
> > at all.
> 
> We're neither talking about distribution nor legal aspects, but
> about existence. But anyway, you seem to agree with me that there
> are very good reasons for not including these in the kernel.
> 
> > And they are definitely not "very good reasons" for doing anything in 
> > the kernel.
> 
> There is a big difference between "not doing anything to help"
> and "actively doing something to make life difficult for". The
> former is undoubtedly legitimate. It's the latter we're
> discussing here.

Justifying anything with code with not GPL compatible licences has zero 
relevance here.

And there's value in making life harder for such modules with 
questionable legality. As an example, consider people who experienced 
crashes of "the Linux kernel" caused by some binary-only driver.
Not that uncommon e.g. with some graphics drivers.
This harms the reputation of Linux as being stable.

The solution is not to support proprietary drivers, the solution is to 
get open source replacements.

>...
> >> - code conflicting with existing kernel structure or policy
> >> - code in which the concerned subsystem maintainers see no benefit
> > 
> > Let's fix the problems, not work around them.
> 
> That's certainly better, but not always possible. Do you
> agree with me that if it isn't, then that's a very good
> reason for not including that code in the kernel?

No, it's still a reason for fixing the real problem.

> > There is a conflict between getting code included and ensuring some 
> > minimum quality of the kernel, but in many cases we could try better.
> 
> Correct. Again, you appear to agree with my statement that
> for some code there are very good reasons not to include it
> in the kernel.

But this does not result in any obligation of supporting low quality 
external code that destabilizes the kernel of people using it.

If it's low quality code doing something useful - well, how many hundred 
people are on Greg's list only waiting for some driver they could write?

> > And when there's a good reason for a kernel policy, then code that
> > violates this policy is not a "very good reason" for anything.
> 
> >> - code which its author is unable and/or unwilling to convert to
> >>   kernel coding standards
> >> - code whose author is unable and/or unwilling to defend it on LKML
> >> ...
> > 
> > That's their fault, and definitely not a "very good reason" for making 
> > life easier for them.
> 
> Putting aside the fruitless question of whose fault it is,
> is it a "very good reason" for actively making life more
> difficult for them than it is already, eg. by gratuitiously
> breaking interfaces they rely on for no other "very good
> reason" than to discourage out-of-tree development? In other
> words, do you think it benefits the Linux community if you
> discourage those programmers you've already scared away from
> submitting their code to the kernel from continuing their
> work off-tree, too? In summary, do you think the world would
> be a better place if all the existing out-of-tree modules
> just ceased to exist, without any replacement?

With your "without any replacement" you needlessly excluded the 
reasonable solution:

The solution is that someone other than the author either takes the 
existing external code or rewrites it from scratch, submits it for 
inclusion into the kernel, and maintains it there.

Let me repeat that Greg has said he has hundreds of volunteers for such 
tasks.

> T.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

