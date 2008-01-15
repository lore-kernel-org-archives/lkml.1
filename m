Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYAORIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYAORIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYAORIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:08:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57718 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYAORIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:08:43 -0500
Date: Tue, 15 Jan 2008 18:11:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, pavel@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080115171146.GA2377@one.firstfloor.org>
References: <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu> <20080114201214.GC9257@uranus.ravnborg.org> <20080115151742.GB10722@elte.hu> <20080115162513.GA18338@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115162513.GA18338@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 05:25:13PM +0100, Sam Ravnborg wrote:
> On Tue, Jan 15, 2008 at 04:17:42PM +0100, Ingo Molnar wrote:
> > 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > > find below the current set of warnings on -git. There are 62.
> > > 
> > > The correct figure is 112.
> > > 
> > > You need to do a:
> > > make KCFLAGS=-fno-unit-at-a-time
> > > build to see them all.
> > 
> > btw., please add a .config option to trigger the -fno-unit-at-a-time 
> > flags. Something like CONFIG_SECTION_ERRORS=y - plus perhaps combine it 
> > with the patch below that turns such section bugs into detectable build 
> > errors. A distro does not want to build a kernel that could potentially 
> > corrupt kernel memory. (it's a security risk as well.) If we make the 
> > err=1 dependent on CONFIG_SECTION_ERRORS then we'll have this 
> > configurable.
> 
> The plan is to let section mismatch warnings become errors 
> after the merge window - so we hit -mm first.

A lot of those I look at seem to be not really bugs; also my
impression is that they sometimes crop up randomly. e.g. you
change something completely unrelated and suddenly you get
a section warning somewhere else.

> And I will add a config option to:
> - set -fno-unit-at-a-time

I was told future gcc versions would remove that. Why do you
want it?

> - add no-inline to all functions marked __init*
> - and maybe disable __inline if that gives additional errors

I sometimes do that for debugging "define static noinline" 
in specific files or similar because it's easier to make sense of oopses
when functions not inlined.  Not sure it would work
as a global option though because if you do it globally
then all the inlines in all .hs would be affected and that might
lead to immense code bloat.

-Andi
