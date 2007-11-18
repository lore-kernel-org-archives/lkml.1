Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXKRLfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXKRLfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 06:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXKRLf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 06:35:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:22456 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbXKRLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 06:35:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aGJhwMqOE9Vdd+slEwiInpBZGlVH7hngB5SC8J+qCOQKmloT2leYBWyKKhv/fFadt7rW4TDIMcn1lxPHEI/CbuMyOwKCgRzJklA1+jwZZBU3bkhdeC2Fh3PHme3Jma5UAV9EXpH0Dv6zI5nkOs82LCn83uM6mfUtBBVBrj4lmbQ=
Message-ID: <e7d8f83e0711180335s208b91b3tc112490a8c4f6fd7@mail.gmail.com>
Date: Sun, 18 Nov 2007 21:35:25 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: casey@schaufler-ca.com
Subject: Re: More LSM vs. Containers (having nothing at all to do with the AppArmor Security Goal)
Cc: "Crispin Cowan" <crispin@crispincowan.com>, rmeijer@xs4all.nl,
       apparmor-dev@forge.novell.com,
       "LSM ML" <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <757605.51592.qm@web36610.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7d8f83e0711162357k8e06c0dqedaf0abd6c67e3fe@mail.gmail.com>
	 <757605.51592.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 18, 2007 5:22 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>
> --- Peter Dolding <oiaohm@gmail.com> wrote:
>
> > On Nov 17, 2007 11:08 AM, Crispin Cowan <crispin@crispincowan.com> wrote:
> > > Peter Dolding wrote:
> > > >>> What is left unspecified here is 'how' a child 'with its own profile'
> > is
> > > >>> confined here. Are it is confined to just its own profile, it may that
> > > >>> the "complicit process" communication may need to be wider specified to
> > > >>> include this.
> > > >>>
> > > > Sorry have to bring this up.  cgroups why not?
> > > Because I can't find any documentation for cgroups? :)
> > >
> > > >   Assign application to
> > > > a cgroup that contains there filesystem access permissions.   Done
> > > > right this could even be stacked.  Only give less access to
> > > > application unless LSM particularly overrides.
> > > >
> > > This comes no where close to AppArmor's functionality:
> > >
> > >     * Can't do learning mode
> > >     * Can't do wildcards
> > >     * Sucks up huge loads of memory to do that much FS mounting (imagine
> > >       thousands of bind mounts)
> > >     * I'm not sure, but I don't think you can do file granularity, only
> > >       directories
> > >
> > Ok sorry to say so far almost percent wrong.  Please note netlabels
> > falls into a control group.  All function of Apparmor is doable bar
> > exactly learning mode.   For learning mode that would have to be a
> > hook back to a LSM I would expect.
> >
> > Done right should suck up no more memory than current apparmor.  But
> > it will required all LSM's doing file access to come to common
> > agreement how to do it.  Not just hooks into the kernel system any
> > more.
>
> The ability to provide alternative access control schemes is the
> purpose of LSM. The fact that we insane security people can't come
> to the agreement you require is why we have LSM. You can not have
> what you are asking for. Please suggest an alternative design.

Part of the building the alternative design requires aggreeing to
build sections common.
Like the netlabels.  We need this for other parts like filesystems.
>
> > At the container entrance point there needs file granularity applied
> > for complete and correct container isolation to be done.
> > >
> > > > There are reasons why I keep on bring containers up it changes the
> > > > model.  Yes I know coming to a common agreement in these sections will
> > > > not be simple.   But at some point it has to be done.
> > > >
> > > Containers and access controls provide related but different functions.
> > > Stop trying to force containers to be an access control system, it does
> > > not fit well at all.
> > >
> > > Rather, we need to ensure that LSM and containers play well together.
> > > What you proposed in the past was to have an LSM module per container,
> > > but I find that absurdly complex: if you want that, then use a real VMM
> > > like Xen or something. Containers are mostly used for massive virtual
> > > domain hosting, and what you want there is as much sharing as possible
> > > while maintaining isolation. so why would you corrupt that with separate
> > > LSM modules per container?
> >
> > Please stop being foolish.  Xen and the like don't share memory.   You
> > are basically saying blow out memory usage just because someone wants
> > to use a different LSM.
>
> Yup. No one ever said security was cheap. Most real, serious security
> solutions implemented today rely on separate physical machines for
> isolation. Some progressive installations are using virtualization,
> and the lunatic fringe uses the sort of systems well served by LSM.
> Let's face it, people who really care are willing to pay a premium.

Bigger problem Containers are processor neutral Xen and lot of the
other solutions are not.  There are advantages for people who don't
need full blown.  There needs to be two levels.  Ie VM for the heavy.
 Containers for where the security is needed but no to the point of
needing two different kernels.  Now restricting what can be in a
Container due to some poor reason that has not been attempted to be
worked around is not a valid reason.   In theory using Containers you
should be able to run every Linux distro on earth under one kernel as
long as it supports that series kernel.  Ie 2.6 2.4...  Now that is
only the base level of Containers.  More advanced Zones like solaris
will see other platforms running in a container under the same kernel.
 Current designing around containers is not dealing with what I can
do.  It more how will we hack it to work.  Not make sure it will
support where Container design can go.
>
> > Besides file access control is part of running containers isolated in
> > the first place and need to be LSM neutral.
>
> File access control is within the scope of the LSM. If your feature
> can't deal with that you need to fix your feature.

This is the problem for containers File access controls need to be
like netlabels common between LSM's.

Yes this is going to get up noses.
>
> > This is the problem current model just will not work.  Some features
> > are need in Linux kernel all the time and have to become LSM neutral
> > due to the features of containers.
>
> Sounds like a conflict in requirements.

This is the problem it is a conflict of requirements.
>
> > Next big after filesystem most likely will be the common security
> > controls for devices.  These are just features need to complete
> > containers.  Basically to do containers LSM have to be cut up.  Or
> > containers function will be dependent on the current LSM to be use
> > completely.
>
> I would be perfectly happy without containers, just as I understand
> you don't give a rat's pitute about LSMs. If you want my cooperation
> and/or backing on containers, show me how they make my life better,
> and how cutting up LSM is to my advantage. I am perfectly willing
> to consider alternatives, but I confess that my natural reaction to
> confrontation is to fight back.
>
Containers doing them will just require some parts becoming default no
matter the LSM.  I am not exactly happy with LSM is due to the
conflict.  Because there are features Containers will require no
matter the LSM loaded.  At moment only LSM's provide them in different
ways.  So running Containers becomes a lot harder than it should be to
imposable to get what containers truly offers.

Basic idea of containers and cgroups.  Is that everyone can use them
directly.  Of course each layer should only be able to give less
access than the layer above it.

I hope segmenting LSM would allow focus and reduce code base size.
Less mine is better than yours arguments comparing LSM to each other
as a whole is basically imposable to come to a single solution due too
many differences to fight over at one time.  So instead of selinux and
apparmor and other LSM fighting over there complete system.  It would
better to do it segment by segment.  This could allow common
agreements for parts to be formed less code to look after.   Some
answers will have to be both.  Current design of LSM has no chance of
creating a single LSM that does everyones need effectively.  Instead
current design of LSM allows duplication.  Its a design failure.

cgroups provide things like memory usage limits, memory allocation
preferences(What application gets to keep itself in ram), cpu access
limits and so on as well .  Fully functional containers need to be
able to contain whatever distro happens to be in there from the rest
of the system.  Also it has to Independent to the LSM being used.  Too
far independent means doubling of code.  What is needed is shared
modules.  Modules used by LSM and Containers to do security.   The
segments LSM makers fight over how to do become both container
features and shared code.

Its a hard thing to come to grips with is that containers is a
security model in its own right.   If you can isolate something inside
containers system it should be out of reach of the rest of the system
if person using containers wish this.   Now if person uses containers
might only want to  control one of memory, cpu, disk or device access
this is perfectly acceptable too.

Applications controlling containers in theory could model most
security models.  Usermode testing of a security mode or even
applications doing there own internal security models independent of
distros.  PAM the login system can also use containers to limit user
memory usage or cpu access now.  Could have pam forbid users from
being able to switch to root at all or even put users in there own
virtual space..   Security features no longer stop at the LSM.  PAM
could be allocating them based on ldap or other user locations no
matter the LSM in use.  Windows 2000 XP and Vista in a network can be
secured from the ADS.  Same trick login system apply security.

The major differences is flexibility, maintainability and standardisation.

Other major issue with LSM how would you make it for Distro neutral
programs like LSB programs be correctly secured on every Distro.

Since system admins threw to users can be using containers
applications can use them as well like firefox could use it to contain
it scripts and the like from being able to do user harm without user
consent.

As everyone knows every person likes there own distro.  Making a user
operate a distro they don't like will reduce there effectiveness.
Current LSM does not address a completely secured network with mixed
Distros.

Basically LSM was designed pre Containers, pre Linux on a desktop and
pre Linux applications needing to run and operate across distros and
stay secure.  Its showing its age and soon its going to start being a
bugger to operate with.  Its basically reached a redesign point for
future need containers offer part of the solution.  LSM still have a
place after Containers.  Just a different one to now.  Construction of
the LSM needs to change.   Staying with status quo is just trouble.
My ideas maybe not be the complete solution.  Outside of demons may
stay the role of LSM alone..  The internals of applications and pam
system on the common core of Containers.  In the process as much code
as able shared.

Peter Dolding
