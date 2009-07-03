Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZGCMDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZGCMDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbZGCMDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:03:07 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42022 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZGCMDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RT8GUbPnew4lifcScpWK1ExMu+AveQIdz7L5kxKz9P/DOHuBOFQm2gzi4mpmxalKTa
         4eO4FdB7oz7oY0KnhJNXGFzMGI2Bm6zD1OFLs81Hvemde1iucc9jaLssuFuyvSNkVDbw
         coXig88f0qvSy8LFc5MsZanaj65rcBxuP33bk=
Date: Fri, 3 Jul 2009 12:03:01 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090703120301.GD4847@ff.dom.local>
References: <200907030331.32531.andres@anarazel.de> <20090703061213.GA4847@ff.dom.local> <200907031326.21822.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907031326.21822.andres@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 01:26:21PM +0200, Andres Freund wrote:
> On Friday 03 July 2009 08:12:13 Jarek Poplawski wrote:
> > On Fri, Jul 03, 2009 at 03:31:31AM +0200, Andres Freund wrote:
> > ...
> >
> > > Ok. I finally see the light. I bisected the issue down to
> > > eea08f32adb3f97553d49a4f79a119833036000a :  timers: Logic to move non
> > > pinned timers
> > >
> > > Disabling timer migration like provided in the earlier commit stops the
> > > issue from occuring.
> > >
> > > That it is related to timers is sensible in the light of my findings,
> > > that I could trigger the issue only when using delay in netem - that is
> > > the codepath using qdisc_watchdog...
> >
> > Andres, thanks for your work and time. It saved me a lot of searching,
> > because I wasn't able to trigger this on my old box.
> Thanks. It allowed me to go through some of my remaining paperwork ;-)
> 
> Does anybody of you have an idea where the problem actually resides? 

Do you mean possibly broken timers are not enough?

> qdisc_watchdog_schedule looks innocent enough for my uneducated eyes - and the 
> patch/infrastructure from Arun goes over my head...
> I will happily test some ideas/patches.
> 
> Aside from that - is the whole PSCHED_TICKS2NS/PSCHED_NS2TICKS conversion 
> business purely backward compatibility?

The whole PSCHED_ conversion was to get finer resolution without
breaking backward compatibility, I hope.;-)

Jarek P.
