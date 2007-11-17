Return-Path: <linux-kernel-owner+w=401wt.eu-S1764930AbXKQTW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764930AbXKQTW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbXKQTWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:22:48 -0500
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:37322 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758879AbXKQTWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:22:46 -0500
X-YMail-OSG: zVNpq3kVM1lDph.Ko.xZ8hXm2mpso955CNnUFhuJZNzquV4CK9lOF0JX_OYqGilPL9dEfDlBmQ--
X-RocketYMMF: rancidfat
Date: Sat, 17 Nov 2007 11:22:45 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: More LSM vs. Containers (having nothing at all to do with the AppArmor Security Goal)
To: Peter Dolding <oiaohm@gmail.com>, Crispin Cowan <crispin@crispincowan.com>
Cc: rmeijer@xs4all.nl, apparmor-dev@forge.novell.com,
       LSM ML <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <e7d8f83e0711162357k8e06c0dqedaf0abd6c67e3fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <757605.51592.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Peter Dolding <oiaohm@gmail.com> wrote:

> On Nov 17, 2007 11:08 AM, Crispin Cowan <crispin@crispincowan.com> wrote:
> > Peter Dolding wrote:
> > >>> What is left unspecified here is 'how' a child 'with its own profile'
> is
> > >>> confined here. Are it is confined to just its own profile, it may that
> > >>> the "complicit process" communication may need to be wider specified to
> > >>> include this.
> > >>>
> > > Sorry have to bring this up.  cgroups why not?
> > Because I can't find any documentation for cgroups? :)
> >
> > >   Assign application to
> > > a cgroup that contains there filesystem access permissions.   Done
> > > right this could even be stacked.  Only give less access to
> > > application unless LSM particularly overrides.
> > >
> > This comes no where close to AppArmor's functionality:
> >
> >     * Can't do learning mode
> >     * Can't do wildcards
> >     * Sucks up huge loads of memory to do that much FS mounting (imagine
> >       thousands of bind mounts)
> >     * I'm not sure, but I don't think you can do file granularity, only
> >       directories
> >
> Ok sorry to say so far almost percent wrong.  Please note netlabels
> falls into a control group.  All function of Apparmor is doable bar
> exactly learning mode.   For learning mode that would have to be a
> hook back to a LSM I would expect.
> 
> Done right should suck up no more memory than current apparmor.  But
> it will required all LSM's doing file access to come to common
> agreement how to do it.  Not just hooks into the kernel system any
> more.

The ability to provide alternative access control schemes is the
purpose of LSM. The fact that we insane security people can't come
to the agreement you require is why we have LSM. You can not have
what you are asking for. Please suggest an alternative design.

> At the container entrance point there needs file granularity applied
> for complete and correct container isolation to be done.
> >
> > > There are reasons why I keep on bring containers up it changes the
> > > model.  Yes I know coming to a common agreement in these sections will
> > > not be simple.   But at some point it has to be done.
> > >
> > Containers and access controls provide related but different functions.
> > Stop trying to force containers to be an access control system, it does
> > not fit well at all.
> >
> > Rather, we need to ensure that LSM and containers play well together.
> > What you proposed in the past was to have an LSM module per container,
> > but I find that absurdly complex: if you want that, then use a real VMM
> > like Xen or something. Containers are mostly used for massive virtual
> > domain hosting, and what you want there is as much sharing as possible
> > while maintaining isolation. so why would you corrupt that with separate
> > LSM modules per container?
> 
> Please stop being foolish.  Xen and the like don't share memory.   You
> are basically saying blow out memory usage just because someone wants
> to use a different LSM.

Yup. No one ever said security was cheap. Most real, serious security
solutions implemented today rely on separate physical machines for
isolation. Some progressive installations are using virtualization,
and the lunatic fringe uses the sort of systems well served by LSM.
Let's face it, people who really care are willing to pay a premium. 

> Besides file access control is part of running containers isolated in
> the first place and need to be LSM neutral.

File access control is within the scope of the LSM. If your feature
can't deal with that you need to fix your feature.

> This is the problem current model just will not work.  Some features
> are need in Linux kernel all the time and have to become LSM neutral
> due to the features of containers.

Sounds like a conflict in requirements.

> Next big after filesystem most likely will be the common security
> controls for devices.  These are just features need to complete
> containers.  Basically to do containers LSM have to be cut up.  Or
> containers function will be dependent on the current LSM to be use
> completely.

I would be perfectly happy without containers, just as I understand
you don't give a rat's pitute about LSMs. If you want my cooperation
and/or backing on containers, show me how they make my life better,
and how cutting up LSM is to my advantage. I am perfectly willing
to consider alternatives, but I confess that my natural reaction to
confrontation is to fight back.


Casey Schaufler
casey@schaufler-ca.com
