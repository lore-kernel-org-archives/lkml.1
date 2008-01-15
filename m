Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYAOSVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYAOSVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYAOSVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:21:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48971 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYAOSVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:21:39 -0500
Date: Tue, 15 Jan 2008 19:21:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>, rjw@sisk.pl,
       pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080115182142.GC18338@uranus.ravnborg.org>
References: <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu> <20080114201214.GC9257@uranus.ravnborg.org> <20080115151742.GB10722@elte.hu> <20080115162513.GA18338@uranus.ravnborg.org> <20080115171146.GA2377@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115171146.GA2377@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > The plan is to let section mismatch warnings become errors 
> > after the merge window - so we hit -mm first.
> 
> A lot of those I look at seem to be not really bugs; also my
> impression is that they sometimes crop up randomly. e.g. you
> change something completely unrelated and suddenly you get
> a section warning somewhere else.
I have fixed a lot of these warnings.
And when I look closer at them they are explainable.

The warnings are today very dependent on the configuration
and the inlining that gcc uses.
With default options to gcc my .config produces ~65 warnings
but with -fno-unit-a-time I get 112 warnings.
Solely due to less inlining done by gcc.

So there are two sources for the 'randomization':
a) The actual config
b) The sometimes agressive inlining

a) will be addressed by having separate sections for each
__init* type that is at link time combined where it belongs.

b) is addressed by a Kernel Hacking option which
   1) uses -fno-unit-at-a-time to get less gcc inlining
   2) maybe make all __*init function no-inline
   3) maybe disable inlining globally

> > And I will add a config option to:
> > - set -fno-unit-at-a-time
> 
> I was told future gcc versions would remove that. Why do you
> want it?
Are there any better way to tell gcc no to inline so agressively?

	Sam
