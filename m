Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYAFVRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYAFVRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYAFVRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:17:46 -0500
Received: from 1wt.eu ([62.212.114.60]:1206 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbYAFVRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:17:45 -0500
Date: Sun, 6 Jan 2008 22:08:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106210813.GA10136@1wt.eu>
References: <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain> <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu> <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106195802.GN2082@does.not.exist>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 09:58:02PM +0200, Adrian Bunk wrote:
> On Sun, Jan 06, 2008 at 08:10:44PM +0100, Willy Tarreau wrote:
> > I, as an end user of ntpd, have been harrassed to use it to get an
> > ntp bug reported "because by mail it would get lost". What complicated
> 
> Noone knows how many thousand bug reports have never reached lkml 
> since majordomo silently dropped them.

Since none of my mails has been dropped yet, I think that the false
positives are rather rare. Yes, sometimes someone complains about a
mail getting repeatedly killed. But that's not *that* much frequent
IMO and people are already used to re-post when mailing their friends,
coworkers or customers. It's no different here. Still, I agree that
it is a problem.

> This is the price for having lkml relatively spam-free.

yes and I think it works fairly well.

> > an interface it is when you don't know it ! I remember I wanted to
> > attach a patch and it didn't even get through the first time. I did
> > it wrong. Blame me if you want, but an interface which need training
> > for proper use is certainly not for casual end users.
> 
> What exactly is the problem with attaching files?
> What is "it didn't even get through the first time" exactly?

Well, it's quite old in my memories, it may be 2 years ago. IIRC, when
I wanted to attach files, I got brought to another page for this, and
once done there was some confusing indication about how to complete the
filing or get back to terminate the report. Sorry for not being much
precise on this one, it's too far ago.

> > Also, it's very annoying to have to create an account somewhere, leaving
> > there one of the passwords you use on many other sites, just to help a
> > random developer fix a bug in his code. You quickly wonder if someone
> > else will report it and have more patience.
> 
> If you already lack patience at this point,

Well, it took me 2 minutes to send my patch to the maintainer by then,
he very politely told me that the only way was through bugzilla, and
then it took me half an hour if not more to create a bugzilla account,
find how to use it, attach the files and put a description in a text-area.

Also, I remember that the ongoing mail exchanges through bugzilla
systematically removed the mail history, which made it very hard to
follow a discussion, because all mails I received were almost single-lined
looking like "how did that happen ?" or "in what circumstances ?" without
any history... Maybe this is configurable though.

> would you be willing to 
> bisect which requires more than a dozen kernel recompiles and reboots?

Certainly not! But I would like kernel people to become less egocentric
and understand that what they routinely do all the day appears very
complicated and time-consuming to many users, and that by imposing them
complex and/or costly methods to report bugs, they filter a lot of
reports out. Sure, there are still a bunch of them doing everything
up to and including the git bisects. But what percentage ?

People who encounter problems at work will not do that to start with,
because they cannot delay all their work to spend half a day building
kernels when their boss or customers are waiting for their work. Others
will report the problems they encounter at a customer's and will not
even be able to git-bisect because the customer's mail server is not
like a notebook they have everywhere with them and can reboot at will.
Some of them are more free of their time and will probably enjoy the
experience, but they are a minority IMHO.

If we had stats on the periods git bisects are run on, I suspect that
night and week-ends are the most frequent moments, simply because it's
when people have time.

IMHO, git bisect is excellent for kernel people. Not for random users.
They first have to install git, find free space, *clone the kernel tree* 
and start discovering the beast.

> > Another recent example: a coworker recently told me he installed the
> > latest beta from ubuntu, and that he had some problems with his WIFI
> > randomly hanging. I asked him if he filed a bug, he replied me "no,
> > it's too much boring, I'm not the only one with this hardware, others
> > have certainly already done it". When the release went out, he insisted
> > telling me he was right not filing the bug because indeed it was fixed !
> 
> He wouldn't have sent a bug report no matter how to report it.

I don't agree. It's a matter of effort vs expected advantage. Just
sending a 5-lines mail from work presents a lower entry barrier than
having to create an account and discover a new tool.

In fact, from the user's perspective, filing a kernel bug report is seen
as something annoying and useless, simply because the kernel is so much
used that someone else will file the same bug anyway. They act just like
microsoft users. Do you know anyone in your relatives who has *ever*
filed a bug to microsoft ? Probably zero. They passively wait for the
next patch, and just whine if their bug does not get magically fixed.

We must understand that our users who file bug reports are not doing this
*for them* anymore, they are offering us *presents for free*, because
someone tells them "report it before the release so that it gets fixed".
We must do everything to incitate them to do so. If the present becomes
even slightly annoying, we never get it. Have you noticed the number of
"me too" on the list ? Users find any sort of excuse for not having filed
a report in the first time, but are still willing to confirm another
one's bug. That's normal, they're just humans after all.

The ones making the most efforts are those with driver problems on rare
hardware, or those who encounter problems which look very specific to
their setups, because they know that nobody else will work on a fix if
they don't report the problem.

> > We must accept that end users :
> >   1) do not like creating accounts (remember or divulgate passwords,
> >      and risk of getting spam)
> 
> Send _one_ email to lkml and you'll get forever spam to this address.
> With one email addresses of mine exactly that happened.

That's true too. But given the number of people who randomly forward
stupidities by mails to lists of "friends" from their work address, I
think that getting their address spammed is not a problem for many of
them.

Oh and BTW, mail addresses entered in bugzilla are publicly readable
anyway. I've just randomly picked bug #1234 and the reporter and
participants may trivially be spammed.

> >   2) do not know how to classify their problem, and are not even
> >      sure it's a real bug. On the first page, when uncertain they
> >      would probably click "Other". Adding doubt in the reporter's
> >      mind is counter-productive as it will refrain him from being
> >      precise about what he did to get the problem.
> 
> If the bug ends at Other/Other that's not a problem - this usually gets 
> fixed within a few hours.

OK, but we should indicate it clearly at the very beginning :

 "If you don't know which category your report belongs to, simply
  select Other, and it will be qualified by a more skilled person"

> >   3) are not familiar with our vocabulary :
> >      - "Tree" : mainline? mm? mjb? ac? what's that ?
> >      - "Component" : Configuration? LSM? Modules? Other?
> 
> Then let's improve that.
> 
> >   => finally, I'm not sure I had to click "Other" in the first place,
> >      I want to choose something else, I click "Back" and I get back
> >      to the login page! Bye bye.
> 
> Works fine here.
> 
> Did you disable cookies?

Not at all (I don't even think the web works well anymore without cookies
these days). I retried. In fact I was still authenticated it seems, I
think that it's just that the login page is poorly placed in the sequence
of pages. By clicking on "back", I intuitively expected to get back to
the selection of another category.

> > Also :
> >   "No binary modules - NVIDIA users this means YOU!"
> >    => about half the reporters will wonder if they should stop here
> >       or not. Most of those with an NVidia chipset and/or graphics
> >       card will wonder, while the bug may still interest us.
> 
> Then sugggest a better text.

 "Before reporting a bug, please ensure that you can reproduce the
  problem without any binary module loaded (such as Nvidia's drivers,
  ndiswrapper, etc...). Ensuring that a problem happens without any
  third party drivers (which are not provided with the kernel) increases
  your report's accuracy and avoids wasting developer's time. If you
  are not sure, please check for [blacklist names here] by running
  'lsmod|more' in a shell window. If you do not know how to run without
  those drivers, please still file the report, it may still be considered
  valuable, but you may be recontacted and guided to unload them."

> > At least, on the mailing list, there's no real rules, the mail will
> > be posted anyway. And if the user gets flamed, at least we have the
> > report.
> >...
> 
> If majordomo didn't drop it.

You seem to have experienced a lot of trouble with LKML!

> And if it didn't get ignored and forgotten.

... by maintainers who deliberately refuse to read LKML ? :-)

Seriously, LKML is bad for *long term* tracking, as most people will
rotate their mailboxes once a month or week and old mails become dead
archives with no reminder. Something like bugzilla makes it possible
never to forget them. But the expensive work is still to get the bug
description there without discouraging newcomers.

Regards,
Willy

