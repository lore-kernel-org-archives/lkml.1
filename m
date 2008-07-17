Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbYGQUaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbYGQUaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760605AbYGQU3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:29:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49177 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760609AbYGQU3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:29:49 -0400
Message-ID: <487FABBA.5060009@firstfloor.org>
Date: Thu, 17 Jul 2008 22:29:46 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
References: <20080716214516.GA10777@basil.nowhere.org>	 <200807170011.12184.rjw@sisk.pl>	 <200807161633.01375.jbarnes@virtuousgeek.org>	 <487EEAEB.4050009@firstfloor.org>	 <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>	 <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>	 <487F71E8.9050705@firstfloor.org>	 <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com>	 <487FA24B.9060803@firstfloor.org> <2c0942db0807171311hae9b3e7v811e024990b05fe4@mail.gmail.com>
In-Reply-To: <2c0942db0807171311hae9b3e7v811e024990b05fe4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Thu, Jul 17, 2008 at 12:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Why would you care about the merge and not about the individual patches?
>> Note that these quilt merges don't have conflicts.
> 
> Because sometimes merges are non-trivial. If you roll that merge
> conflict resolution back into the original patch, then the patch is
> now different. And in all these rebasings, who's to say there won't be
> a typo that accidentally changes the original patch that has had more
> testing? We'er all human, y'know?

You only focus only on the merges, but I focus on all the other changes too.
The reason I maintain patches in quilt is that it's quite easy to
fix them up.

Besides as a subsystem maintainer the actual conflict points are
very rare because normally people don't change drivers/acpi without
going through me.

>>> It's the difference between having tested patches and an untested
>>> merge, or untested new patches
>> The patches are as tested individually as they were before. I don't see
>> how you can call something that was in linux-next for some time and also
>> in my test tree "untested".
> 
> Surely you agree that more testing is better? A rebased patch has had
> less testing than the original patch, by definition.

What I don't agree on is that a rebased patch had less testing than
a patch that got merged by someone else (in this case Linus) into
their tree when my tree wasn't at exactly the same point. In both
cases it's a merge and yes it is untested initially, but not less
so in both of the cases.


>>> and an untested merge.
>> So when I do a rebase versus Linus doing a merge (end result
>> the same code base) how is that more untested?
> 
> If you rebase, you're creating new patches that have less testing than
> the originals. You're also tossing away a history of the changesets,
> which means that any external testers can no longer point to a
> historical potion of a tree and say "I tested that".

They can't do that anyways because I maintain my patches in quilt.

So there's no canonical such tree. Besides I don't consider
it very likely that testers just test my tree (except me myself).

Normally testers either test individual patches (e.g. something that is posted
as a test patch in bugzilla) or completely merged trees like -mm
or linux-next. I am not aware of a significant test population
that just pulls ACPI trees only. It really wouldn't make much sense
either, testers should really test multiple subsystems in parallel,
otherwise testing wouldn't really scale.

> Uhm, the history is the whole point of using source control and git.
> If all we cared about was the end result and not the history, there'd
> be little point to using source management other than to help speed
> merging.

Sorry, but that's not really how it works.

Normally the rule is (and Linus used to encourage that)
is that when something hits his tree it shouldn't have the complete development
history.

Because normally for non trivial changes you would end up with sequences
like

initial change
fix some problems
fix more problems found during testing
make it compile in configuration foo
fix a typo ...
etc.

[just take a look at some of the version numbers in larger patch series.
Often they easily hit double digits. Or sometimes the fix-fix-fix-fix-foo
patches in -mm. Of course Andrew tends to clean that up before more]


Needless to say such a conglomeration is not bisectable. If your
bisect ends in the middle it might not compile or crash in trivial
ways etc.

Or as a maintainer submitter sends patch version A
Then someone finds a problem.
Review finds problems.
Submitter sends patch version A v2
repeat a few times

Or again if you asked to keep the whole history the final merge would have

merge A
revert A
merge Av2
revert Av2
merge Av3
revert Av3
...

Now in a ideal world the person doing the change would get everything
right the first time, but we're not living in a ideal world.

But when something goes into the Linus tree it just supposed to be a single
patch that does this change cleanly without all these additional development steps.

Anyways I'm dropping out of this discussion now because I think I made
all my points already multiples times.

-Andi

