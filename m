Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbXKRTYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbXKRTYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 14:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXKRTYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 14:24:42 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:36467 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751426AbXKRTYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 14:24:41 -0500
Message-ID: <47409191.8050709@crispincowan.com>
Date: Sun, 18 Nov 2007 11:25:05 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Dolding <oiaohm@gmail.com>
CC: casey@schaufler-ca.com, rmeijer@xs4all.nl, apparmor-dev@forge.novell.com,
       LSM ML <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: More LSM vs. Containers (having nothing at all to do with the
 AppArmor Security Goal)
References: <e7d8f83e0711162357k8e06c0dqedaf0abd6c67e3fe@mail.gmail.com>	 <757605.51592.qm@web36610.mail.mud.yahoo.com> <e7d8f83e0711180335s208b91b3tc112490a8c4f6fd7@mail.gmail.com>
In-Reply-To: <e7d8f83e0711180335s208b91b3tc112490a8c4f6fd7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Dolding wrote:
> On Nov 18, 2007 5:22 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>   
>> --- Peter Dolding <oiaohm@gmail.com> wrote:
>>> On Nov 17, 2007 11:08 AM, Crispin Cowan <crispin@crispincowan.com> wrote:
>>>       
>>>> Peter Dolding wrote:
>>>>         
>>>>>   Assign application to
>>>>> a cgroup that contains there filesystem access permissions.   Done
>>>>> right this could even be stacked.  Only give less access to
>>>>> application unless LSM particularly overrides
>>>> This comes no where close to AppArmor's functionality:
>>>>
>>>>     * Can't do learning mode
>>>>     * Can't do wildcards
>>>>     * Sucks up huge loads of memory to do that much FS mounting (imagine
>>>>       thousands of bind mounts)
>>>>     * I'm not sure, but I don't think you can do file granularity, only
>>>>       directorie
>>> Ok sorry to say so far almost percent wrong.  Please note netlabels
>>> falls into a control group.  All function of Apparmor is doable bar
>>> exactly learning mode.   For learning mode that would have to be a
>>> hook back to a LSM I would expect.
>>>
>>> Done right should suck up no more memory than current apparmor.  But
>>> it will required all LSM's doing file access to come to common
>>> agreement how to do it.  Not just hooks into the kernel system any
>>> more.
>>>       
>> The ability to provide alternative access control schemes is the
>> purpose of LSM. The fact that we insane security people can't come
>> to the agreement you require is why we have LSM. You can not have
>> what you are asking for. Please suggest an alternative design.
>>     
> Part of the building the alternative design requires aggreeing to
> build sections common.
>   
Ok.

I vehemently disagree with your design ideas. So do lots of other
people, and I have not seen one single person ever speak up in favor of
your ideas. So far, you have no agreement at all.

>>>> Containers and access controls provide related but different functions.
>>>> Stop trying to force containers to be an access control system, it does
>>>> not fit well at all.
>>>>
>>>> Rather, we need to ensure that LSM and containers play well together.
>>>> What you proposed in the past was to have an LSM module per container,
>>>> but I find that absurdly complex: if you want that, then use a real VMM
>>>> like Xen or something. Containers are mostly used for massive virtual
>>>> domain hosting, and what you want there is as much sharing as possible
>>>> while maintaining isolation. so why would you corrupt that with separate
>>>> LSM modules per container?
>>>>         
>>> Please stop being foolish.  Xen and the like don't share memory.   You
>>> are basically saying blow out memory usage just because someone wants
>>> to use a different LSM.
>>>       
>> Yup. No one ever said security was cheap. Most real, serious security
>> solutions implemented today rely on separate physical machines for
>> isolation. Some progressive installations are using virtualization,
>> and the lunatic fringe uses the sort of systems well served by LSM.
>> Let's face it, people who really care are willing to pay a premium.
>>     
>
> Bigger problem Containers are processor neutral Xen and lot of the
> other solutions are not.  There are advantages for people who don't
> need full blown.  There needs to be two levels.  Ie VM for the heavy.
>  Containers for where the security is needed but no to the point of
> needing two different kernels.
Remarkable. I agree completely with this paragraph, but draw the
opposite conclusion that you do.

Having private LSMs per container means having a separate kernel per
container. That would seem to put that idea in the "heavy" category.
Which is why I suggested that people who want to do what you desire
should use full VMM instead of containers.

>   Now restricting what can be in a
> Container due to some poor reason that has not been attempted to be
> worked around is not a valid reason.
It is rejected for perfectly sound engineering reasons like complexity
bloat and memory bloat. Come back with a workable design or STFU.

>    In theory using Containers you
> should be able to run every Linux distro on earth under one kernel as
> long as it supports that series kernel.  Ie 2.6 2.4...
In "theory" as long as this theory ignores the fact that all distros
patch their kernel. So yeah, you can run different "distros" as long as
you don't care about device support, and you ignore which LSM you want
to use.

Containers fundamentally share the kernel, and the LSM module(s) loaded
are part of the kernel, and therefore are fundamentally shared among the
Containers.

>>> Besides file access control is part of running containers isolated in
>>> the first place and need to be LSM neutral.
>>>       
>> File access control is within the scope of the LSM. If your feature
>> can't deal with that you need to fix your feature.
>>     
> This is the problem for containers File access controls need to be
> like netlabels common between LSM's.
>   
This is one of your impossible dreams. For file access controls to be
"common between LSM's" there would have to be one file access model that
everyone can agree on. It is quite clear that this is not the case, and
Linus has said, clearly and repeatedly, that he *will not* arbitrarily
choose one.

Give it up. You cannot have this. Stop being foolish :)

>> I would be perfectly happy without containers, just as I understand
>> you don't give a rat's pitute about LSMs. If you want my cooperation
>> and/or backing on containers, show me how they make my life better,
>> and how cutting up LSM is to my advantage. I am perfectly willing
>> to consider alternatives, but I confess that my natural reaction to
>> confrontation is to fight back.
> Containers doing them will just require some parts becoming default no
> matter the LSM.
If you need such a feature, then design it, build it, and propose a
patch. But be prepared for more resistance to your idea if it ends up
breaking all the existing LSM code and modules.

>   I am not exactly happy with LSM is due to the
> conflict.  Because there are features Containers will require no
> matter the LSM loaded.  At moment only LSM's provide them in different
> ways.  So running Containers becomes a lot harder than it should be to
> imposable to get what containers truly offers.
>   
I still don't get the problem you are trying to solve.

There *are* problems with containers and LSMs; LSMs are currently
system-wide, and not customizable per container. I believe this is
mostly fixable within each LSM, and may only require some modest changes
to LSM to achieve. I would much rather be discussing what that would
require than arguing this impossible dream of One True File Access
Control model, which will never happen in our lifetimes.

> I hope segmenting LSM would allow focus and reduce code base size.
> Less mine is better than yours arguments comparing LSM to each other
> as a whole is basically imposable to come to a single solution due too
> many differences to fight over at one time.  So instead of selinux and
> apparmor and other LSM fighting over there complete system.  It would
> better to do it segment by segment.  This could allow common
> agreements for parts to be formed less code to look after.   Some
> answers will have to be both.
You hope. Except that there are 2 big problems with this dream:

   1. One of your "segments" is file access control, and there is
      fundamental conflict over how file access control should be done.
      So segmenting LSM fails to achieve anything here.
   2. Segmenting security models fragments them. One security model may
      well depend on all of its "segments" supporting a certain
      property, and if you break it apart, it is no longer secure.

So while you hope for lots of nice things, I think this is an absolutely
horrible, unworkable idea.

>   Current design of LSM has no chance of
> creating a single LSM that does everyones need effectively.
It was never intended to do that. It was deliberately designed so that
Linux could accommodate diverse LSM designs in the same kernel, without
having to achieve global agreement on what the right model is.

>   Instead
> current design of LSM allows duplication.  Its a design failure.
>   
Says you. I think it is a design success. It has produced more practical
shared code and cooperation among otherwise conflicting camps of
security philosophies than anything I know of, at least since the IPSec
interop wars.

Of course LSM can be improved. But that will require specific, well
thought-out design proposals, not vague dreams like assuming we can have
one file access control model (we can't) and that such segmentation
would help security (it won't, it will break security).

> cgroups provide things like memory usage limits, memory allocation
> preferences(What application gets to keep itself in ram), cpu access
> limits and so on as well .
Ok. So do ulimits. What's your point?

>   Fully functional containers need to be
> able to contain whatever distro happens to be in there from the rest
> of the system.
Ok, again, what's your point?

>   Also it has to Independent to the LSM being used.
No it does not. That requires a private kernel per container. Guess
what: that means heavyweight virtualization.

> Its a hard thing to come to grips with is that containers is a
> security model in its own right.   If you can isolate something inside
> containers system it should be out of reach of the rest of the system
> if person using containers wish this.
A very, very simple security model: total isolation.

Security models have 2 extremes: "total sharing" (think MS DOS from
1990) and "total isolation" (think separate physical machines with no
network in between). These two models are very easy to implement. What
is difficult in security is controlled sharing.

LSMs are always designed to facilitate some kind of controlled sharing.
SELinux, AppArmor, LIDS, TOMOYO, MultiADM, they all implement some kind
of mechanism so that you can write a policy that determines which
objects are shared, and which are not.

>    Now if person uses containers
> might only want to  control one of memory, cpu, disk or device access
> this is perfectly acceptable too.
>   
That is a truly crappy security model. Instead of a policy controlling
which objects get to be shared (these files over here are shared, those
files over there are private) you have a model that determines which
*classes* of objects are shared (files are private, memory is shared).

Of course this configuration has nice flexibility for performance. But
as a security model it is hopeless.

> Applications controlling containers in theory could model most
> security models.
ROFL.

>   Usermode testing of a security mode or even
> applications doing there own internal security models independent of
> distros.
... is a job for full virtualization, not Containers. Testing a security
model means messing with the kernel, which is fundamentally shared
across containers.

>   PAM the login system can also use containers to limit user
> memory usage or cpu access now.  Could have pam forbid users from
> being able to switch to root at all or even put users in there own
> virtual space..   Security features no longer stop at the LSM.
Security features never did stop at LSM. LSM is about kernel-mediated
access control. There's lots of other security issues that don't have
anything to do with LSM, and always have been.

A PAM feature that disallows a user to switch to root is an interesting
idea. But it seems to me that it requires kernel mediation to do it, and
likely would be best done in an LSM.

> Since system admins threw to users can be using containers
> applications can use them as well like firefox could use it to contain
> it scripts and the like from being able to do user harm without user
> consent.
>   
Yes, you could do that. But the total isolation imposed by Containers
would be horrible compared to the controlled isolation provided by LSMs.

> As everyone knows every person likes there own distro.  Making a user
> operate a distro they don't like will reduce there effectiveness.
> Current LSM does not address a completely secured network with mixed
> Distros.
>   
I submit that supporting mixed distros on one kernel is an inappropriate
goal for both LSM and for Containers. It is a job best done by full
virtualization.

Containers are a great way to give each container user a virtual private
copy of the host distro. Don't break the lightweight property by trying
to make Containers do too much, it will just turn into a bad clone of
full virtualization.

> Basically LSM was designed pre Containers,
False: there was discussion in the design phase of providing
virtualization features so that LSM could support containers. They were
rejected as being out of scope for LSM.

>  pre Linux on a desktop and
>   
False: Linux desktops have been around since the dawn of Linux. I was
running the Helix desktop while I was working on the LSM design.

> pre Linux applications needing to run and operate across distros and
> stay secure.
ROFL. False. Linux applications have always sought to run across
distros, and have always wanted to be secure. An application that wants
to be secure can:

    * bundle an AppArmor profile in its RPM or Deb that secures it on
      any AppArmor-supporting distro (SUSE, Ubuntu, Mandriva, Annvix,
      etc.) and have no effect on non-AppArmor platforms
    * bundle an SELinux targeted policy in its RPM that secures it on
      any SELinux-supporting distro (RHEL, Fedora, Hardened Gentoo,
      Engarde, etc.) and have no effect on non-SELinux platforms
    * do both at the same time to provide security across all of the
      above distros

So I don't know WtF you are talking about here.

>   Its showing its age and soon its going to start being a
> bugger to operate with.
Translation: it is in the way of your goals, so you criticize it to try
to get agreement to get it out of your way. LSM is not generally
difficult to work with, it is difficult for *you* to work with, which is
not the same thing.

>   Its basically reached a redesign point for
> future need containers offer part of the solution.  LSM still have a
> place after Containers.  Just a different one to now.  Construction of
> the LSM needs to change.   Staying with status quo is just trouble.
> My ideas maybe not be the complete solution.  Outside of demons may
> stay the role of LSM alone..  The internals of applications and pam
> system on the common core of Containers.  In the process as much code
> as able shared.
>   
Certainly LSM and Containers interact, and can and should be modified to
work together better. But your specific ideas are IMHO badly broken. I
would like to discuss other possibilities, with a principle focus on how
a single kernel LSM can support per-Container policy sets.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

