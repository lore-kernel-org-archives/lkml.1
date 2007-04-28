Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXD1VFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXD1VFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXD1VFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:05:10 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38441 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXD1VFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:05:07 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 17:04:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
In-Reply-To: <4633ACE4.50004@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0704281635190.28274@localhost.localdomain>
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain>
 <46337BD2.7000701@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain>
 <4633ACE4.50004@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> > On Sat, 28 Apr 2007, Stefan Richter wrote:
> >> Robert P. J. Day wrote:

> > i think there's a real benefit in being able to say that you can
> > configure and build a kernel that incorporates nothing that people
> > have labelled as obsolete or deprecated (or broken, etc.).
>
> And that benefit is...? :-)

the same benefit you get from being able to deselect all EXPERIMENTAL
stuff -- the knowledge that you can build a fully-functional kernel
without having to rely on anything that's considered broken or
deprecated or obsolete.

at this point, i think i've pretty much bored everyone to tears making
a case for why i think there's actual value to this feature.  if
you're not convinced, there's nothing else i can think of to say that
will persuade you.

> I suppose it's for example a convenient way to test-build a kernel
> without deprecated stuff, run the kernel, and see if anything in
> userland breaks.  Then take measures to update userland in time, or
> get in touch with whoever declared the deprecation, before it's too
> late.

exactly.  being able to deselect deprecated or obsolete stuff en masse
this easily means you can figure out *way* ahead of time whether
finally removing something will cause problems, rather than suddenly
learning that only when the actual removal happens.

> Ah, I see.  (It gets better because you reduce redundancy of Kconfig
> expressions vs. Kconfig display strings.)

yup.  i'm assuming that it's a trivial change to the display routine
to add a parenthesized maturity level (or levels) to the end of the
label when you're running "make xconfig" or "make menuconfig" or ...
etc etc.

> [...]
> >> All of the levels except BROKEN are highly subjective.
> >
> > i don't think so.  we've had this discussion before, and most
> > people seem to agree on what it means for something to be
> > "deprecated" and what it means to be "obsolete."  it's not really
> > *that* subjective.
>
> Sorry, I didn't express myself clearly.  It's quite clear what the
> labels mean.  But it can be controversial whether a piece of code
> deserves one of these labels.

in the first place, that would be *entirely* the decision of the
maintainer, just as it is now.  but nothing says that starting to tag
stuff has to affect you in any way.  there should be a top-level
selection that lets you even *activate* the maturity level settings as
part of your configuration.

if you don't want to take that stuff into account, you should be able
to turn it off entirely with a single switch, as in:

  [*] Activate maturity attributes
    [*] EXPERIMENTAL
    [*] DEPRECATED
    [*] OBSOLETE
    [*] BROKEN

if you choose not to care about maturity levels, then nothing will be
filtered at all.  so everybody's happy.

> >> And such tags can and will become outdated.
> >
> > how is that different from what's happening now?
>
> The difference is that there will be even more tags which require
> attention to keep them up to date.

i don't see that being a problem.  personally, if i was building a
kernel for my system, my first attempt would be to build one without
anything tagged DEPRECATED, OBSOLETE or BROKEN.  and if that kernel
failed because a critical feature was left out of the build, i would
be *so* instantly all over the ass of the subsystem maintainer who
erroneously tagged it that way.

this wouldn't make maturity tagging harder -- it would make it
*easier*.

> Although that's hardly a problem if there is an alert maintainer or
> janitor, or at least an enthusiastic user who sends a notice to
> LKML.

i don't think it would even need that, if people change the way they
do builds by *starting* with only those features that aren't tagged
and seeing if that fails for some reason.  it would certainly be the
way *i* would start doing builds from now on.

> "maturity" is just like "depends on" with the added feature that UIs
> are supposed to print the flag onto the screen even if the user did
> not enable a debug mode of the UI.
>
> It's really nothing more.  Nobody stops you for example from writing
> a derivative of make allyesconfig which says N to
> CONFIG_EXPERIMENTAL.

sure, i have no disagreement with that.  (um ... was there something
there i was supposed to address?  it just sounded like you were
clarifying what we were talking about.)

> >> Something /can/ sensibly be DEPRECATED and OBSOLETE at the same
> >> time.
> >
> > i disagree.  in previous exchanges, most people seemed satisfied
> > that those two terms were mutually exclusive.  i think the
> > difference in their definitions is self-evident.
>
> Yes, they have different meanings.  No, they are not exclusive, they
> are orthogonal.
>
> DEPRECATED = "I don't want you to build or run this if you can
> possibly avoid it."
>
> OBSOLETE = "There is other stuff which does more or less the same,
> and this here could go away in the future."

nope.  we've been down this road before, and the consensus was that
something could be one of deprecated or obsolete, but not both.  i can
re-post those definitions if you want, or you could read about them
here:

http://kerneltrap.org/node/7593

> > also, once a few things get tagged, then, as i mentioned before, a
> > full tree build can be done in stages.  i recall andrew grumbling
> > that he was still trying to get a full configuration to build.
> > but why try to do it all at once?
> >
> > i'd start with an "allyesconfig" but leaving out all the
> > DEPRECATED, OBSOLETE and BROKEN stuff and beat on that until it
> > worked.  then i'd add in the DEPRECATED stuff and do it again.
> > finally, add the OBSOLETE stuff.  at each stage, the build might
> > fail but, the further you get into it, the less a build failure
> > should concern you.
>
> Aha, a tool to split and prioritize an integrator's efforts to
> unbreak things.  It's another of the applications you could have
> mentioned to show the benefits of the facility. :-)

i could have except i just thought of it as i was responding to your
earlier email.  :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
