Return-Path: <linux-kernel-owner+w=401wt.eu-S965667AbXBOPSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667AbXBOPSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965985AbXBOPSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:18:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:5681 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965667AbXBOPSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YT1n8q0qgfyR30cKjR/w5wU/8YCHuZidY1fwzv5Tu+MqiVki6aGL9nVgARwUE19pn5JyBOb+eBdnUukWSnIozGY9YqXRCv4sFKmiE4UpxQ6U5Il2Rcu1eYsECPFQEELHtxBx2uxN0qh9qg19vFR+zuc8DfVi4WlKSrWnS0CRLn0=
Message-ID: <f2b55d220702150718i36f54ac7v89ed4e2adc05eada@mail.gmail.com>
Date: Thu, 15 Feb 2007 07:18:00 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "v j" <vj.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I sympathize with you, VJ, I really do, but you're going to have to do
a lot more homework in order to understand what is happening to Linux
in embedded space.  Allow me to supply some worthless, non-lawyer,
non-measurable-kernel-contributor observations, which are at least
quite different from those of most people who will bother to respond
in this thread.  Let's start with: Don't believe everything you read
on the Internet.  That goes double for press releases and public
mailing lists.

On 2/14/07, v j <vj.linux@gmail.com> wrote:
> This is in reference to the following thread:
>
> http://lkml.org/lkml/2006/12/14/63
>
> I am not sure if this is ever addressed in LKML, but linux is _very_
> popular in the embedded space. We (an embedded vendor) chose Linux 3
> years back because of its lack of royalty model, robustness and
> availability of infinite number of open-source tools.

That's not why you chose Linux.  You chose Linux because it made your
lives easy in the short term and you didn't know or care what the
long-term consequences would be.  You didn't have to interact with any
human beings, cut any deals, make any business case, obtain any
executive approvals, sign any contracts, or forecast any per-seat,
per-unit, or per-incident costs.  You did have to put work into making
it work for you, but you chalked your salaries up to "investment" in
an "IP asset".  Now you're finding out that the difference between a
sunk cost and an asset is that an asset produces a revenue stream, and
that few of the people who actually work on the mainline Linux kernel
care whether or not your investment in building things with Linux
inside will continue to produce revenues.  Live and learn.

> We recently decided to move to Linux 2.6 for our next product, mainly
> because Linux has worked so well for us in the past, and we would like
> to move up to keep up with the latest and greatest.

Don't kid a kidder.  2.6 was the latest and greatest three years ago.
Now it's the only game in town if you want anyone to talk to you
without a cash retainer up front.  Mind you, 2.4 still runs great on
anything it ran great on back then; but nowadays the sort of
application coders who work cheap are dead in the water without the
(relatively) inexpensive threads of NPTL/TLS.  Even the most un-hip
and non-showing-up-at-the-table of chip vendors realize that their
price/performance slides will look better under 2.6 unless they are
really, really memory constrained.  Sticking to 2.4 would require a
business case for carrying your own maintenance weight, and we've
already established that proactive analysis of business cases is not
your enterprise's strong point.

> However in moving to  2.6, we noticed a number of alarming things.
> Porting drivers over from devfs to udev, though easy raised a number
> of alarming issues. Driver's no longer could dynamically allocate
> their MAJOR/MINOR numbers. Doing so would mean they would have to use
> sysfs. However it seems that sysfs (and the class_ interface) is only
> available to GPL modules. This is very concerning. The drivers which
> we have written over the last three years are suddenly under threat.
> We don't mind statically assigning MAJOR/MINOR numbers to our drivers.
> We can do this and modify our user space applications too.

Given all the technical and cultural changes in the Linux ecosystem
since you last checked in, it's kinda funny you picked on device
numbering.  Do you really expect your customers to combine your
drivers with someone else's closed-source special sauce that happens
to pick the same major number?  Or if you're concerned about sharing a
major with other devices in the same conceptual class, do you really
think there's a legal risk in using a standardized, published,
arm's-length interface to interchangeable drivers, no matter what the
symbols are labeled?  Ask your lawyer to interpret Lotus v. Borland
and Lexmark v. Static Control for you, and to show you parallels to
the law in other markets that are relevant to you.  Then ask yourself
whether you really want to be calling EXPORT_SYMBOL_MOVING_TARGET
entrypoints from your out-of-tree drivers anyway.

> However we have a worrying trend here. If at some point it becomes
> illegal to load our modules into the linux kernel, then it is
> unacceptable to us. We would have been better off choosing VxWorks or
> OSE 3 years ago when we made an OS choice. The fact that Linux is
> becoming more and more closed is very very alarming.

Illegal, shmillegal.  What's it's becoming is pointless, because all
the kernel "features" that matter in a modern embedded system (bounded
preemption latency, effective power management, reliable I/O
peristalsis with predictable system impact) can't be localized to
"core code".  I can tell you from experience that they're next to
impossible to achieve when there's a big opaque lump of binary driver
stuck in the platform integrator's craw.  Fans of EXPORT_SYMBOL_GPL
may be perversely motivated, but they're telling you in advance what
any customer worth having will tell you next year: if you're trying to
sell components into the embedded market, closed drivers are more
trouble than they're worth.

Back on the topic of crusaders:  There's a tried-and-true way to get
people to care about your revenue stream: cut them in on it, in a
currency they find valuable.  This isn't a moral issue, except in the
sense that all ethics is economics and vice versa.  There are,
however, some people involved in Linux kernel development who try to
make a moral issue out of it and claim not to be willing to cut deals
in mere dollars.  (Maybe you just couldn't pay them enough to put up
with whinging about erratic system behavior when you've invited a bull
into the ring 0 china shop.)  A few of these are such valued
contributors that Linus lets them get away with silliness like
EXPORT_SYMBOL_GPL, and that chums the water for the bigger sharks at
the SFLC.

So you've put yourselves in harm's way, to the extent that you have
become dependent on the ignorance, indifference, or goodwill of people
you've never met, who derive no value from the continued viability of
your business.  Notwithstanding the vitriol poured out in this thread,
there's actually more goodwill to go around than you might think; but
to make use of it you'll have to put on your asbestos skivvies and
show up to the table.  Whether that's worth doing is a business issue
about which I can't advise you, since I'm no more a psychic than a
lawyer.

Legal niceties are not, however, what's actually going to bite you --
unless you do something really stupid like Fortinet did (dissemble
about the presence of Linux inside the box, which is probably what
induced a Munich judge to overlook Harald Welte's dubious claim to
"authorship" in a copyright sense).  That kind of stunt could easily
lead to criminal charges under 17 USC 506, and more to the point, it
makes you look terminally dim as well as dishonest -- not good viral
marketing.  Also totally unnecessary if you just come clean about any
changes to GPL code you make and distribute -- although "derivative
work" is not really the right term for this, it's clearly something
you don't have the legal authority to do without accepting the offer
of contract in the GPL.  But I'll come back to that.

In all probability, what's going to eat your revenue stream hollow is
not pseudo-legal sniping from the cheap seats but the predictable
converse of the very virtues you cited:
    because those infinitely available free-as-in-speech tools are
also free-as-in-beer, you've taken them for granted and barely learned
how to use them or even tested whether the sharper ones work on your
platform;
    Linux is robust except when it's not, for instance when the
underlying hardware has subtle bugs that trigger in wonderful new ways
as code and toolchains evolve; and
    that enticing royalty-free model means that no one owes you a damn
thing in return, and there's no paymaster around to curb certain
people's congenital hostility to freeloaders and suits generally.

Ever noticed that the only thing worse than a salesman who's on
commission is a salesman who isn't on commission?  That goes double
for kernel hackers.  It's hard to find one who's genuinely competent,
not just at refining his subsystem but at pushing a Linux-dependent
product up the steep part of the quality curve.  It's even harder to
outbid Nokia and Google for him and then get him to work on your
actual priorities beyond the initial, fun phase.  And even then, he
doesn't control the evolution of the Linux mainline, unless his name
is Linus Torvalds.  So you had better hope he's also a master
strategist when it comes to "stabilization" (forking by any other
name) for embedded applications, which is playing with fire but
unavoidable in the Brave New World of 2.6.x.y.

Now, I have already glossed a dozen points here in terms different
from the other flamers', and will doubtless be torn to pieces by those
who don't choose to ignore me entirely.  Yet one gloss of a legal
nature is worth emphasizing anyway (but remember, I don't even play a
lawyer on TV.)  The aside about Linus is not entirely a jest; he does,
in fact, control the evolution of the Linux mainline and is the only
candidate for "authorship" in a copyright sense, to the extent that
"the Linux kernel" is a well-defined work of authorship.  Aalmuhammed
v. Lee is good law and has analogues in other important jurisdictions,
notwithstanding Harald Welte's efforts to establish independent
copyright in netfilter and initrd.  Google "Linus Torvalds estoppel"
(omit quotes) for some of the reasons why this matters, even if Linus
chooses to downplay the legal significance of his unique role.

However, getting a correct judgment in a court of fact is always a
crapshoot, and I suppose it's conceivable that a judge would buy the
"GPL is a dark continent" story long enough to issue a preliminary
injunction.  Judge Saris wasn't fooled (she gave Eben Moglen's
affidavit the brush-off that it deserved and dismissed MySQL's GPL
claim according to routine contract law standards), but the judge
_you_ get might have different sympathies, especially if your
established pattern of behavior makes look like a conniving greedhead
or a freeloading scriptmonkey.  Even so, odds are that it'll get fixed
on appeal if you bother; but in the meantime there's a new batch of
disingenuous chest-pounding press releases from the usual suspects
with your name filled in the blank.  Again, not good viral marketing.

What's the bottom line?  Free the software!  It's not the law, it's
just a good idea.  Assuming, of course, that:
    you are selling your hardware at a positive gross margin, and can
therefore afford for it to become more popular among end users (sadly,
this does not go without saying);
    the information content of your software does not totally reveal
your hardware's internals, or at least does not make them so
blindingly obvious that it is cheaper for cloners in poor countries to
reengineer it than to make a backdoor deal with your own contract
manufacturers;
    there is not an authentic, bona fide Prince of Heck from a
regulatory agency warning you not to make it too easy for hobbyists to
Pump Up The (RF) Volume;
    there have been at least two reorgs since the decision was made to
"invest" in an "IP asset", so the bodies are decently buried and you
can unload your albatross without getting fired by an embarrassed
suit; and
    you, personally, can plausibly claim that the code was even worse
before it entered your hands, just in case it comes back to haunt you
in a future job interview.

HTH, HAND, Cheers,
- Michael
