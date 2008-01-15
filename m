Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYAOR3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYAOR3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYAOR2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:28:54 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38164 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYAOR2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:28:53 -0500
Date: Tue, 15 Jan 2008 19:27:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080115172750.GC9571@does.not.exist>
References: <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu> <20080114201214.GC9257@uranus.ravnborg.org> <20080115151742.GB10722@elte.hu> <20080115162513.GA18338@uranus.ravnborg.org> <20080115171146.GA2377@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080115171146.GA2377@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 06:11:46PM +0100, Andi Kleen wrote:
> On Tue, Jan 15, 2008 at 05:25:13PM +0100, Sam Ravnborg wrote:
> > On Tue, Jan 15, 2008 at 04:17:42PM +0100, Ingo Molnar wrote:
> > > 
> > > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > > 
> > > > > find below the current set of warnings on -git. There are 62.
> > > > 
> > > > The correct figure is 112.
> > > > 
> > > > You need to do a:
> > > > make KCFLAGS=-fno-unit-at-a-time
> > > > build to see them all.
> > > 
> > > btw., please add a .config option to trigger the -fno-unit-at-a-time 
> > > flags. Something like CONFIG_SECTION_ERRORS=y - plus perhaps combine it 
> > > with the patch below that turns such section bugs into detectable build 
> > > errors. A distro does not want to build a kernel that could potentially 
> > > corrupt kernel memory. (it's a security risk as well.) If we make the 
> > > err=1 dependent on CONFIG_SECTION_ERRORS then we'll have this 
> > > configurable.
> > 
> > The plan is to let section mismatch warnings become errors 
> > after the merge window - so we hit -mm first.
> 
> A lot of those I look at seem to be not really bugs;

Half of them are possible Oopses, and the other half are about wasted 
memory.

The warnings in the kernel that are not really bugs you can count with 
your fingers.

> also my
> impression is that they sometimes crop up randomly. e.g. you
> change something completely unrelated and suddenly you get
> a section warning somewhere else.
>...

Not all errors are always visible, they might depend on CONFIG_ 
options, and sometimes gcc optimizes such bugs away.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

