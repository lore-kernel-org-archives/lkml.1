Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbXGXXOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbXGXXOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbXGXXOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:14:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:52623 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761771AbXGXXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BpH1Um5+x5HLbZ5migd6RpXx9IEo7oUS0FUVUUH5pDPDe/xkZLpFht41XNiDVb0AjIQ5t3k1btys8uyFEtdMHOizdhulqZ9DYiEMu/PaKtZlhJEFrdc6KMxeVUBehxQ9mvEfHIXr7APGEsy77LfuHk2fl9OqchaoCb4pXzQ1EAU=
Message-ID: <4240b9160707241614k5d8d51ack9c231c4a023ae110@mail.gmail.com>
Date: Wed, 25 Jul 2007 01:14:00 +0200
From: "Jerome Glisse" <j.glisse@gmail.com>
To: "david@lang.hm" <david@lang.hm>
Subject: Re: [linux-pm] Power Management framework proposal
Cc: "Igor Stoppa" <igor.stoppa@nokia.com>,
       "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707241303010.6590@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185091022.19678.28.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>
	 <1185105911.29238.43.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm>
	 <1185187720.26628.23.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707231033430.3828@asgard.lang.hm>
	 <4240b9160707240143u6cdaba64rae93528661f4475c@mail.gmail.com>
	 <Pine.LNX.4.64.0707241303010.6590@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, david@lang.hm <david@lang.hm> wrote:
> On Tue, 24 Jul 2007, Jerome Glisse wrote:
>
> > On 7/23/07, david@lang.hm <david@lang.hm> wrote:
> >>  On Mon, 23 Jul 2007, Igor Stoppa wrote:
> >> >  again, HAL / OHM / Mobilin
> >>
> >>  I was trying to define the lower level interfaces that these tools need.
> >>  today they can only know what is possible by reading the source code for
> >>  each driver and implementing the driver-specific interfaces nessasary to
> >>  set things, I was proposing a common interface that tools like this could
> >>  use instead of requiring all the driver-specific knowledge.
> >>
> >>
> >>  in a nutshell (and I know this is probably not detailed to be acceptable)
> >>
> >>  1. the software needs to know what the interconnects and dependancies
> >>      between devices are (supposedly this is provided via sysfs)
> >>
> >>  2. the software needs to know what type of device this is (again,
> >>      supposedly this is provided via sysfs)
> >>
> >>  3. the software needs to know what modes exist for a driver/piece of
> >>      hardware. to make any decisions this infomation needs to provide some
> >>      information about the capability of the mode and the power consumed in
> >>      that mode. in addition there will need to be flags to indicate any
> >>      special restrictions of a mode
> >>
> >>  4. the software needs to know the cost of switching from any mode to any
> >>      other mode. since some transitions will interact with other devices
> >>      there will need to be flags to indicate such requirements for specific
> >>      transitions.
> >>
> >>  5. the software needs to be able to find out what mode a device is in.
> >>
> >>  6. the software needs to be able to tell the driver to switch to a
> >>      different mode (I think it would be a very good thing if going to a
> >>      particular mode was always the same command, no matter what mode it is
> >>      currently in)
> >>
> >>  7. the software needs to figure out the desire of the user.
> >>
> >>  my proposal was addressing items #3-#6. it isn't trying to decide what to
> >>  do, simply to allow the software that _is_ trying to decide what to do a
> >>  way to find out what it can do.
> >>
> >>  David Lang
> >
> > I believe a central place where user can set/change hw state to save
> > power or to increase computational power is definitely a goal to pursue.
> > But i truly think that the OHM approach is the best one ie using plugins
> > so that one can make a plugin specific for each device. The point is that
> > i believe there is no way to do an abstract interface for this and trying to
> > do so will endup doing ugly code and any interface would fail to encompass
> > all possible tweak that might exist for all devices.
>
> will each plugin have it's own interface? or will you have one interface
> to access the plugins and then the plugins do things behind the scenes?
>
> I'll bet that the API for the plugins is common, and if so then it could
> be similar to the API that I suggested.

I take here ohm as a reference (this come from my limited understanding of
this daemon so there might be inaccuracy) driver export through HAL
there power management tunning capacity, Then an ohm plugin would use
HAL to give a higher
view of this capacity and also manage policy, preference, permission, ...

Last consumer in power management food chain would be an user interface which
will communicate with ohm (and with all ohm plugin) so desktop writter (gnome,
kde, ...) can write some kind of power management center where each ohm plugin
can have its own panel. So in the end the user got one place to do all its
power management which is the goal i think you are trying to aim.

> > For instance on graphics card you could do the following (maybe more):
> > -change GPU clock
> > -change memory clock
> > -disable part of engine
> > -disable unit
> > i truly don't think you can make a common interface for all this, more
> > over there might be constraint on how you can change things (GPU &
> > memory clock might need to follow a given ratio). So you definitely
> > need knowledge in the user space program to handle this.
>
> sure you can, just enumerate all the options the driver writer wants to
> offer as options. yes this could be a lengthy list, so what?
>

My point was that your interface by trying to fit square pegs into round hole
will fail to expose all subtility of each device which might in the end bring
to wrong power management decision. So i believe we can't sum up
power management to list of mode whose attribute are power consumption
& capacity.

And there is no way to design an abstraction given that all hw we will have
to deal with are too much different and do not follow any standard things
(beside ACPI there is other way to save power brightness, gpu/memory
clock, pll, ...) so i don't see how one might give a common view of things
which are fundamentally different in how they affect consumption (same end
result with many different paths leading to it).

best,
Jerome Glisse
