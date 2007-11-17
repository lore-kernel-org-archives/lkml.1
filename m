Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbXKQKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbXKQKDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 05:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXKQKDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 05:03:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48223 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbXKQKDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 05:03:40 -0500
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Olsson <mnemo@minimum.se>
Cc: Dane Mutters <dmutters@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <473F281B.60408@minimum.se>
References: <473E815F.30900@minimum.se>
	 <20071116213137.6efe3f9e@the-village.bc.nu>  <473E9290.3040006@minimum.se>
	 <1195281942.15929.5.camel@Orchestrator> <1195285481.3059.12.camel@twins>
	 <473F281B.60408@minimum.se>
Content-Type: text/plain
Date: Sat, 17 Nov 2007 11:03:32 +0100
Message-Id: <1195293812.6739.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-17 at 09:42 -0800, Martin Olsson wrote:
> (taking this reply offline, so this is mostly intended for Alan)
> 
> Peter Zijlstra wrote:
> > 
> > If you don't know which limits to set and need a package for them, your
> > job title should not be system administrator.
> > 
> 
> In theory I agree with you Peter but in practice a lot of low-skill 
> people have to install and administer servers. I think the pragmatic and 
> realistic approach would be to accept that many admins are not perfect, 
> far from it.

Sure, I know that. But providing a package to tune a system setting
doesn't sound like a sane option either. This low-skill admin will
likely not know about this package either.

And between: 'install this package and magic happens', or 'If you have
problem A, fiddle know B so and so' I prefer the latter.

So my suggestion would be to provide good, simple and direct sys-ad 101
documentation for your specific distro.

Of course, your -server distro might have different default settings
from your desktop line.

> Also, this bug involves many aspects and it's possible to argue what 
> exactly is the bug. Even if we don't change any default values, we can 
> still change the kernel so that it survives a fork bomb. After all, the 
> Vista kernel does survive a fork bomb although the system as a whole 
> gets unusable.
> 
> ### On Ubuntu I currently see:
> 1. Launch fork bomb
> 2. System gets to a complete freeze (I can't move mouse and not a single 
> pixel is updated on the screen).
> 
> ### On Vista I currently see:
> 1. Launch fork bomb
> 2. System gets very slow to the point where the system is unusable (but 
> I can always mouse around the mouse freely with no sluggishness and the 
> screen updates continue to make progress even though it takes 1-3 
> seconds between each update). I can still open and close the start menu 
> if I got the patience to wait >45 seconds for it each time.
> 
> I don't think that setting a max process count by default is a 
> good/viable solution. But the kernel could still be changed so that it 
> doesn't hose itself completely.

Agreed, the kernel could perhaps handle it a little more graceful. Do
you happen to know what makes current Linux suck? Is it the excess of
tasks? (I've only ran a few thousand loops on CFS and that seemed to
work). Or is it the memory trashing that causes most problems?

My guess would be memory, and the problem is that the current overcommit
settings allow for a good experience for a lot of things, the downside
is this DoS scenario.

Our OOM killer often killing totally irrelevant processes doesn't help
either.


