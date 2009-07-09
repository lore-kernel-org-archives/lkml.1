Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbZGIOYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbZGIOYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760762AbZGIOYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:24:38 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:32877 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760755AbZGIOYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aMXCCtmIh2hnnZvCSzEgJFotYFy4kTgewRiYI7jbXmKJWVZNMEX+bcF1CkvsnbekIe
         x2bJYj4i5LaLsTAHWM47r70W0vzLZJMetULvvlk5jsMtUsjE07fZLkRSMSOQpa2V7TsO
         Lp7BRa1vjU/9k3AotP3u3PbHMIjneGfQGMRj4=
Date: Thu, 9 Jul 2009 16:24:14 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andres Freund <andres@anarazel.de>,
       Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090709142414.GC3651@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <200907071811.27570.andres@anarazel.de> <20090708080852.GC3148@ami.dom.local> <200907090023.18040.andres@anarazel.de> <20090708224828.GD3666@ami.dom.local> <alpine.LFD.2.00.0907090956490.24704@localhost.localdomain> <20090709104412.GA3651@ami.dom.local> <alpine.LFD.2.00.0907091401040.24704@localhost.localdomain> <20090709132256.GB3651@ami.dom.local> <alpine.LFD.2.00.0907091601120.24704@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907091601120.24704@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 04:15:28PM +0200, Thomas Gleixner wrote:
> On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> > On Thu, Jul 09, 2009 at 02:03:50PM +0200, Thomas Gleixner wrote:
> > > On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> > > > > 
> > > > > I have the feeling that the code relies on some implicit cpu
> > > > > boundness, which is not longer guaranteed with the timer migration
> > > > > changes, but that's a question for the network experts.
> > > > 
> > > > As a matter of fact, I've just looked at this __netif_schedule(),
> > > > which really is cpu bound, so you might be 100% right.
> > > 
> > > So the watchdog is the one which causes the trouble. The patch below
> > > should fix this.
> > 
> > I hope so. On the other hand it seems it should work with this
> > migration yet, so it probably needs additional debugging.
> 
> Right. I just provided the patch to narrow down the problem, but
> please test the fix of the hrtimer migration code which I sent out a
> bit earlier: http://lkml.org/lkml/2009/7/9/150
> 
> It fixes a possible endless loop in the timer code which is related to
> the migration changes. Looking at the backtraces of the spinlock
> lockup I think that is what you hit.

Actually, Andres and Joao hit this, and I hope they'll try these two
patches.

Thanks,
Jarek P.
