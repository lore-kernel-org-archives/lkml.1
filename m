Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYAOS0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYAOS0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYAOS0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:26:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34460 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYAOS0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:26:03 -0500
Date: Tue, 15 Jan 2008 19:29:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@kernel.org>, rjw@sisk.pl, pavel@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080115182904.GA3393@one.firstfloor.org>
References: <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu> <20080114201214.GC9257@uranus.ravnborg.org> <20080115151742.GB10722@elte.hu> <20080115162513.GA18338@uranus.ravnborg.org> <20080115171146.GA2377@one.firstfloor.org> <20080115182142.GC18338@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115182142.GC18338@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 07:21:42PM +0100, Sam Ravnborg wrote:
> With default options to gcc my .config produces ~65 warnings
> but with -fno-unit-a-time I get 112 warnings.
> Solely due to less inlining done by gcc.
> 
> So there are two sources for the 'randomization':
> a) The actual config
> b) The sometimes agressive inlining

Inlining should not be random.  And how does inlining cause such a warning?
> 
> a) will be addressed by having separate sections for each
> __init* type that is at link time combined where it belongs.

One problem I ran into the past was that older binutils seem
to have some exponential behaviour with a lot of named sections
and run very slowly.

> 
> b) is addressed by a Kernel Hacking option which
>    1) uses -fno-unit-at-a-time to get less gcc inlining
>    2) maybe make all __*init function no-inline
>    3) maybe disable inlining globally
> 
> > > And I will add a config option to:
> > > - set -fno-unit-at-a-time
> > 
> > I was told future gcc versions would remove that. Why do you
> > want it?
> Are there any better way to tell gcc no to inline so agressively?

You can either sprinkle noinlines or set specific --params to throttle
back the inliner. The later is very gcc version specific unfortunately.

-Andi
