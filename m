Return-Path: <linux-kernel-owner+w=401wt.eu-S966051AbXDGQNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966051AbXDGQNJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966076AbXDGQNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:13:09 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:35101 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966051AbXDGQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:13:06 -0400
Date: Sat, 07 Apr 2007 12:12:57 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <200704071650.43905.kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704071212.57401.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 April 2007, Con Kolivas wrote:
>On Friday 06 April 2007 20:03, Ingo Molnar wrote:
>> * Con Kolivas <kernel@kolivas.org> wrote:
>[...]
>> 
>> firstly, testing on various workloads Mike's tweaks work pretty well,
>> while SD still doesnt handle the high-load case all that well. Note
>> that it was you who raised this whole issue to begin with: everything
>> was pretty quiet in scheduling interactivity land.

Con was scratching an itch, one we desktop users all have in a place we 
can't quite reach to scratch because we aren't quite the coding gods we 
should be.  Con at least has the coding knowledge to walk in and start 
shoveling, which is more than I can say of the efforts to derail the SD 
scheduler have demonstrated to this user.

>I'm terribly sorry but you have completely missed my intentions then. I
> was _not_ trying to improve mainline's interactivity at all. My desire
> was to fix the unfairness that mainline has, across the board without
> compromising fairness. You said yourself that an approach that fixed a
> lot and had a small number of regressions would be worth it. In a
> surprisingly ironic turnaround two bizarre things happened. People
> found SD fixed a lot of their interactivity corner cases which were
> showstoppers. That didn't surprise me because any unfair design will by
> its nature get it wrong sometimes. The even _more_ surprising thing is
> that you're now using interactivity as the argument against SD. I did
> not set out to create better interactivity, I set out to create
> widespread fairness without too much compromise to interactivity. As I
> said from the _very first email_, there would be cases of interactivity
> in mainline that performed better.
>
>> (There was one person who
>> reported wide-scale interactivity regressions against mainline but he
>> didnt answer my followup posts to trace/debug the scenario.)
>
>That was one user. As I mentioned in an earlier thread, the problem with
> email threads on drawn out issues on lkml is that all that people
> remember is the last one creating noise, and that has only been the
> noise from Mike for 2 weeks now. Has everyone forgotten the many many
> users who reported the advantages first up which generated the interest
> in the first place? Why have they stopped reporting? Well the answer is
> obvious; all the signs suggest that SD is slated for mainline. It is on
> the path, Linus has suggested it and now akpm is asking if it's ready
> for 2.6.22. So they figure there is no point testing and replying any
> further. SD is ready for prime time, finalised and does everything I
> intended it to. This is where I have to reveal to them the horrible
> truth. This is no guarantee it will go in. In fact, this one point that
> you (Ingo) go on and on about is not only a quibble, but you will call
> it an absolute showstopper. As maintainer of the cpu scheduler, in its
> current form you will flatly refuse it goes to mainline citing the 5%
> of cases where interactivity has regressed. So people will tell me to
> fix it, right?... Read on for this to unfold.

Sorry, this user got quiet to watch the cat fight.  Obviously I should 
have been throwing messages wrapped around rocks (or something).

>> SD has a built-in "interactivity estimator" as well, but hardcoded
>> into its design. SD has its own set of ugly-looking tweaks as well -
>> for example the prio_matrix.
>
>I'm sorry but this is a mis-representation to me, as I suggested on an
> earlier thread where I disagree about what an interactivity estimator
> is. The idea of fence posts in a clock that are passed as a way of
> metering out earliest-deadline-first in a design is well established.
> The matrix is simply an array designed for O(1) lookups of the fence
> posts. That is not the same as "oh how much have we slept in the last
> $magic_number period and how much extra time should we get for that".
>
>> So it all comes down on 'what interactivity
>> heuristics is enough', and which one is more tweakable. So far i've
>> yet to see SD address the hackbench and make -j interactivity
>> problems/regression for example, while Mike has been busy addressing
>> the 'exploits' reported against mainline.

Who gives a s*** about hackbench or a make -j 200?!  Those are NOT, and 
NEVER WILL BE, REAL WORLD LOADS for the vast majority of us.  For us SD 
Just Worked(TM).

>And BANG there is the bullet you will use against SD from here to
> eternity. SD obeys fairness at all costs. Your interactivity regression
> is that SD causes progressive slowdown with load which by definition is
> fairness. You repeatedly ask me to address it and there is on unfailing
> truth; the only way to address it is to add unfairness to the design.
> So why don't I? Because the simple fact is that any unfairness no
> matter how carefully administered or metered will always have cases
> where it's wrong. Look at the title of this email for example - it's
> yet another exploit for the mainline sleep/run mechanism. This does
> _not_ mean I'm implying people are logging into servers and running
> ./tenp to hang the machine. What it demonstrates is a way of
> reproducing the scenario which is biting people with real world loads.
> It's entirely believable that a simple p2p app could be behaving like
> tenp, only generating a small load and it could take ages to log in and
> use the console. Willy has complained this is why people stick to 2.4.
> Sure I can create interactivity tweaks worse than anyone else. I will
> not, though, because that precisely undoes what is special about SD. It
> never looks backwards, and is predictable to absurdity. So you'll argue
> that mainline can manage it below...
>
>> > You'll end up with an incresingly complex state machine design of
>> > interactivity tweaks and interactivity throttlers all fighting each
>> > other to the point where the intearactivity estimator doesn't do
>> > anything. [...]
>>
>> It comes down to defining interactivity by scheduling behavior, and
>> making that definition flexible. SD's definition of interactivity is
>> rigid (but it's still behavior-based, so not fundamentally different
>> from an explicit 'interactivity estimator'), and currently it does not
>> work well under high load. But ... i'm still entertaining the notion
>> that it might be good enough, but you've got to demonstrate the
>> design's flexibility.
>
>I have yet to see someone find an "exploit" for SD's current design.
> Mainline is all about continually patching up the intrinsic design (and
> fixing this one test case is not the be all and end all).
>
>> furthermore, your description does not match my experience when using
>> Mike's tweaks and comparing it to SD on the same hardware. According
>> to your claim i should have seen regressions popping up in various,
>> already-fixed corners, but it didnt happen in practice. But ... i'm
>> awaiting further SD and Mike tweaks, the race certainly looks
>> interesting ;)
>
>Well you see a race. I do not. I see a flat predictable performance from
> SD where there will always be slowdown with load. I have no intention
> of changing that. Mike is making an admirable attempt to fix issues as
> they are pointed out. You say there are no regressions but I see
> absolutely no testers of his patches besides himself and you. If I
> introduce any unfairness based on sleep behaviour into SD I'll be
> undoing the whole point of the design and end up chasing new
> regressions. So I won't quibble over the numbers. SD has produced a lot
> of improvements and fairness that mainline struggles with ever
> increasing patches to emulate, but SD does so at the expense of
> proportional slowdown with load.

To be expected, there are after all, only so many cpu cycles to go around.  
Here I sit, running 2.6.21-rc6 ATM, and since there is not an SD patch 
that applies cleanly to rc6, I am back to typing half or more of a 
sentence blind while I answer a posting such as this because of x 
starvation while kmail is sorting incoming stuff.

All this while gkrellm, sitting on the right edge of my screen, is showing 
a 0 to 2% cpu usage in its graphic display!  FWIW, also isn't suffering 
the same display update problems, nor is the system clock down on the 
kickstart bar.  If that isn't prima faci evidence of an unfair scheduler, 
I don't know what is. With the SD patch applied to a working kernel, I've 
pretty well got my machine back and I'm in command again, just as if I 
was running nitros9 on my trs-80 Color Computer while it was compiling a 
program in the background, or back when I was doing all this on an amiga.

Both of these had, by their simplistic designs, schedulers that were fair, 
with (nitr)os9 having the ability to schedule the order that IRQ's were 
serviced with a priority setting on a per IRQ basis.  If Amigados ever 
had the ability to fiddle with the scheduler other than niceing the 
process, it wasn't important enough for me to see if I could tweak it 
because generally it simply worked.

Con's earlier patches worked very well for this desktop user, but as Mike 
kept bitching about "production", (who the hell runs a 'make -j 200' or 
50 while(1)'s in the real world? Certainly not this user, who would like 
to think he has more sense than that) and to heck with the users 
experience. Con kept trying to satisfy Mike, so the more recent ones 
(that I was able to apply & test since I was also fighting with the 
device-mapper change) weren't quite the night and day difference the 
earlier ones were for a desktop user.

I thought I made enough noise in favor of Con's approach early on, but you 
two got into what can only be described as a cat fight, with Ingo 
apparently siding with Mike, and Con apparently isn't up to that sort of 
thing either physically, or mentally after the seemingly endless 
criticism from Mike.  And I hate to say it, but Ingo, you weren't a lot 
of help either, the setbatch utility you had me doing in my scripts 
didn't work all that well, returning an error which was its process 
number when incorporated into a script, and still left me without a 
machine for 5 seconds at a time when gzip -best was running in the 
background, all this something I didn't report all that noisily because 
of the unrelated amanda problems I was having post 2.6.20.3.  The SD 
patches, generally speaking, brought this lag into the less than 1 second 
range 90% of the time.

Maybe I wasn't able to give SD vs mainline aspect my full attention 
either, you'll recall that I was, and am, still bouncing around from the 
in-out status of the device-mapper patch.  But, now that I know how to 
handle it (as a startup from square one for amanda) and the reason for 
the patch, I am more than willing to tolerate it if its a one time thing, 
and the amanda users have been advised, but now its been reverted for a 
bit, and will have to go through this particular bit of hassle again 
later.  I disagree with the reversion of that patch on that basis alone.

> At least I accept that and will no 
> longer put my health at risk trying to "fix" it by "breaking" it. SD is
> done.
>
>I feel sorry for the many users out there who are simply "waiting for it
> to end up in mainline" who just discovered you will veto it on that
> basis. lwn.net had it wrong; this was far more painful than any
> previous attempt to get anything into mainline.
>
>My health has been so badly affected by this that I've been given an
> ultimatum and must turn my computer off till I get well now which may
> be weeks. I already know the massive flameage and last-word comments
> that are likely to be fired off before the inevitable decision to veto
> it.

In this regard, my sympathies Con.  Do get well.  And re-armed for this 
battle.  It is a worthwhile battle, and many thanks from this user to you 
for having fought it.  And I apologize for not supporting your efforts a 
lot more vocally.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Is this going to involve RAW human ecstasy?
