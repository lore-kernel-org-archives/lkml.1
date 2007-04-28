Return-Path: <linux-kernel-owner+w=401wt.eu-S1031203AbXD1UWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031203AbXD1UWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXD1UWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:22:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60264 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031203AbXD1UWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:22:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4633ACE4.50004@s5r6.in-berlin.de>
Date: Sat, 28 Apr 2007 22:21:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain> <46337BD2.7000701@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Sat, 28 Apr 2007, Stefan Richter wrote:
>> Robert P. J. Day wrote:
>>> http://fsdev.net/wiki/index.php?title=Maturity_levels
...
>>   - Your argument should include what the benefits of exposing
>>     DEPRECATED and OBSOLETE as machine-parsable tags are.

(I said that because most things go in because they have uses, not just
because we can.)

> assuming i understand you correctly, the advantage of adding these
> attributes is to be able to (de)select, in one operation, anything of
> that attribute type from your build (in the same way that you can
> deselect anything EXPERIMENTAL in one mouse click).
> 
> i think there's a real benefit in being able to say that you can
> configure and build a kernel that incorporates nothing that people
> have labelled as obsolete or deprecated (or broken, etc.).

And that benefit is...? :-)

I suppose it's for example a convenient way to test-build a kernel
without deprecated stuff, run the kernel, and see if anything in
userland breaks.  Then take measures to update userland in time, or get
in touch with whoever declared the deprecation, before it's too late.

You probably have more applications in mind and maybe even posted about
them before.  (See also at the end of this mail.)

[...]
>>   - "...it's not really experimental but nonetheless claims to be. Bad
>>     craziness all around."
> 
>>     Won't adding more maturity levels increase craziness?
> 
> not at all.  in fact, what it *will* do is prevent those mismatches
> between some kernel feature visually *advertising* itself as being,
> say, DEPRECATED, while, in reality, it's *not* tagged that way.

Ah, I see.  (It gets better because you reduce redundancy of Kconfig
expressions vs. Kconfig display strings.)

[...]
>> All of the levels except BROKEN are highly subjective.
> 
> i don't think so.  we've had this discussion before, and most people
> seem to agree on what it means for something to be "deprecated" and
> what it means to be "obsolete."  it's not really *that* subjective.

Sorry, I didn't express myself clearly.  It's quite clear what the
labels mean.  But it can be controversial whether a piece of code
deserves one of these labels.  Except for BROKEN, whose applicability
can be proven or falsified.

>> And such tags can and will become outdated.
> 
> how is that different from what's happening now?

The difference is that there will be even more tags which require
attention to keep them up to date.  Although that's hardly a problem if
there is an alert maintainer or janitor, or at least an enthusiastic
user who sends a notice to LKML.

> there's stuff marked
> "EXPERIMENTAL" that appears to have been in the kernel for years.

It is sometimes true for years, although that's not the goal for
software in mainline.

> and, obviously, the only way a scheme like this is going to work is if
> developers keep their own subsystems up to date and tag them
> appropriately.

Yep.

[...]
>> I sometimes voiced my opinion that the Kconfig language and files
>> should stick to reflect the mere dependencies, while presentation
>> should be left to the UIs.  The "maturity" directive is basically a
>> variant of "config" or "depends on" with added presentational
>> information.

[of "depend on", as you clarified]

> in a way, yes, it's a variant, but it's a variant that differs enough
> from a regular "config" and "depends on" that i think trying to mix
> the two would be a horribly bad idea.
[...]
>> Of course everybody is entitled to have a different opinion and ask
>> for more presentational markup in Kconfig.
> 
> fair enough, but it's not just presentational markup, in the same way
> that EXPERIMENTAL isn't *just* presentational markup -- it means more
> than that.

"maturity" is just like "depends on" with the added feature that UIs are
supposed to print the flag onto the screen even if the user did not
enable a debug mode of the UI.

It's really nothing more.  Nobody stops you for example from writing a
derivative of make allyesconfig which says N to CONFIG_EXPERIMENTAL.

>> Something /can/ sensibly be DEPRECATED and OBSOLETE at the same
>> time.
> 
> i disagree.  in previous exchanges, most people seemed satisfied that
> those two terms were mutually exclusive.  i think the difference in
> their definitions is self-evident.

Yes, they have different meanings.  No, they are not exclusive, they are
orthogonal.

DEPRECATED = "I don't want you to build or run this if you can possibly
avoid it."

OBSOLETE = "There is other stuff which does more or less the same, and
this here could go away in the future."

[...]
> also, once a few things get tagged, then, as i mentioned before, a
> full tree build can be done in stages.  i recall andrew grumbling that
> he was still trying to get a full configuration to build.  but why try
> to do it all at once?
> 
> i'd start with an "allyesconfig" but leaving out all the DEPRECATED,
> OBSOLETE and BROKEN stuff and beat on that until it worked.  then i'd
> add in the DEPRECATED stuff and do it again.  finally, add the
> OBSOLETE stuff.  at each stage, the build might fail but, the further
> you get into it, the less a build failure should concern you.

Aha, a tool to split and prioritize an integrator's efforts to unbreak
things.  It's another of the applications you could have mentioned to
show the benefits of the facility. :-)
-- 
Stefan Richter
-=====-=-=== -=-- ===--
http://arcgraph.de/sr/
