Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZGCW5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZGCW5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 18:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZGCW5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 18:57:09 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:53672 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZGCW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 18:57:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EHM3dI6KTiv6uGVV8oZ9DFEbM0U3/EP/eJr4IJom6eI0vITZfg5GyehifvafrYZoe1
         qF2jD4YvJm3ZophHz9jovDW2CWOB6rnZjDHqrvP2hMkbxpW1Ol4aFnpWF0stV5/1sEEk
         m1ogaSKTkwSM4nHhoETFx/Xuu4RfKDwhfQpWQ=
Date: Sat, 4 Jul 2009 00:56:40 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: andres@anarazel.de, arun@linux.vnet.ibm.com, tglx@linutronix.de,
       shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090703225640.GA3639@ami.dom.local>
References: <20090703061213.GA4847@ff.dom.local> <200907031326.21822.andres@anarazel.de> <20090703120301.GD4847@ff.dom.local> <20090703.132220.57384838.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703.132220.57384838.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 01:22:20PM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Fri, 3 Jul 2009 12:03:01 +0000
> 
> > On Fri, Jul 03, 2009 at 01:26:21PM +0200, Andres Freund wrote:
> >> On Friday 03 July 2009 08:12:13 Jarek Poplawski wrote:
> >> > On Fri, Jul 03, 2009 at 03:31:31AM +0200, Andres Freund wrote:
> >> > ...
> >> >
> >> > > Ok. I finally see the light. I bisected the issue down to
> >> > > eea08f32adb3f97553d49a4f79a119833036000a :  timers: Logic to move non
> >> > > pinned timers
> >> > >
> >> > > Disabling timer migration like provided in the earlier commit stops the
> >> > > issue from occuring.
> >> > >
> >> > > That it is related to timers is sensible in the light of my findings,
> >> > > that I could trigger the issue only when using delay in netem - that is
> >> > > the codepath using qdisc_watchdog...
> >> >
> >> > Andres, thanks for your work and time. It saved me a lot of searching,
> >> > because I wasn't able to trigger this on my old box.
> >> Thanks. It allowed me to go through some of my remaining paperwork ;-)
> >> 
> >> Does anybody of you have an idea where the problem actually resides? 
> > 
> > Do you mean possibly broken timers are not enough?
> 
> Well, if you look at that commit the bisect pointed to Jarek, it is a
> change which starts causing a situation which never happened before.
> Namely, timers added on one cpu can be migrated and fire on another.
> 
> So this could be exposing races in the networking that technically
> always existed.

I'm not sure I get your point; could you give some example?
Actually, I've suspected races in timers code.

Jarek P.
