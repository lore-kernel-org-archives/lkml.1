Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbXKQH5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbXKQH5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 02:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXKQH5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 02:57:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:27461 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXKQH5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 02:57:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RPXiO4AON78YtulE3V7W5VWVEZP30BWPVRcdsJiEnmMQbRFQmKemtxYgwD4QeX0+HwZq9TjOIzq8rYXbUsprbKRgYXndBI7sjLfzcVnlXPXYttWYm3rzbYV0J1XkGywn4rDvC7jVW/vM0ScJLoHQ3cH+HKlJ7e6AvhEYBtDVkUQ=
Message-ID: <e7d8f83e0711162357k8e06c0dqedaf0abd6c67e3fe@mail.gmail.com>
Date: Sat, 17 Nov 2007 17:57:32 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Crispin Cowan" <crispin@crispincowan.com>
Subject: Re: More LSM vs. Containers (having nothing at all to do with the AppArmor Security Goal)
Cc: rmeijer@xs4all.nl, apparmor-dev@forge.novell.com,
       "LSM ML" <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <473E3EF3.7070008@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <10657.80.126.27.205.1194933072.squirrel@webmail.xs4all.nl>
	 <47395F00.6080507@crispincowan.com>
	 <e7d8f83e0711151458t3d4349d0k1b7ce4b030db87af@mail.gmail.com>
	 <473E3EF3.7070008@crispincowan.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 17, 2007 11:08 AM, Crispin Cowan <crispin@crispincowan.com> wrote:
> Peter Dolding wrote:
> >>> What is left unspecified here is 'how' a child 'with its own profile' is
> >>> confined here. Are it is confined to just its own profile, it may that
> >>> the "complicit process" communication may need to be wider specified to
> >>> include this.
> >>>
> > Sorry have to bring this up.  cgroups why not?
> Because I can't find any documentation for cgroups? :)
>
> >   Assign application to
> > a cgroup that contains there filesystem access permissions.   Done
> > right this could even be stacked.  Only give less access to
> > application unless LSM particularly overrides.
> >
> This comes no where close to AppArmor's functionality:
>
>     * Can't do learning mode
>     * Can't do wildcards
>     * Sucks up huge loads of memory to do that much FS mounting (imagine
>       thousands of bind mounts)
>     * I'm not sure, but I don't think you can do file granularity, only
>       directories
>
Ok sorry to say so far almost percent wrong.  Please note netlabels
falls into a control group.  All function of Apparmor is doable bar
exactly learning mode.   For learning mode that would have to be a
hook back to a LSM I would expect.

Done right should suck up no more memory than current apparmor.  But
it will required all LSM's doing file access to come to common
agreement how to do it.  Not just hooks into the kernel system any
more.

At the container entrance point there needs file granularity applied
for complete and correct container isolation to be done.
>
> > There are reasons why I keep on bring containers up it changes the
> > model.  Yes I know coming to a common agreement in these sections will
> > not be simple.   But at some point it has to be done.
> >
> Containers and access controls provide related but different functions.
> Stop trying to force containers to be an access control system, it does
> not fit well at all.
>
> Rather, we need to ensure that LSM and containers play well together.
> What you proposed in the past was to have an LSM module per container,
> but I find that absurdly complex: if you want that, then use a real VMM
> like Xen or something. Containers are mostly used for massive virtual
> domain hosting, and what you want there is as much sharing as possible
> while maintaining isolation. so why would you corrupt that with separate
> LSM modules per container?

Please stop being foolish.  Xen and the like don't share memory.   You
are basically saying blow out memory usage just because someone wants
to use a different LSM.

Besides file access control is part of running containers isolated in
the first place and need to be LSM neutral.

This is the problem current model just will not work.  Some features
are need in Linux kernel all the time and have to become LSM neutral
due to the features of containers.

Next big after filesystem most likely will be the common security
controls for devices.  These are just features need to complete
containers.  Basically to do containers LSM have to be cut up.  Or
containers function will be dependent on the current LSM to be use
completely.

Peter Dolding
