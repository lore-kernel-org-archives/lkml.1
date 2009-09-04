Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZIDG0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZIDG0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZIDG0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:26:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:51546 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750852AbZIDG0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:26:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+iGmFhVgeiUm5yye6EVfDq5GTpooP8J5v8xiXUBh
	Hy0eN1Oa7UVO51
Subject: Re: CPU scheduler weirdness?
From: Mike Galbraith <efault@gmx.de>
To: Marton Balint <cus@fazekas.hu>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0909032350580.20701@cinke.fazekas.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de>
	 <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu>
	 <20090813155812.GA15714@rhlx01.hs-esslingen.de>
	 <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu>
	 <1250665455.7583.326.camel@twins>
	 <alpine.LNX.2.00.0908191353100.19120@cinke.fazekas.hu>
	 <1250683834.7583.360.camel@twins>
	 <alpine.LNX.2.00.0908191428300.20409@cinke.fazekas.hu>
	 <1250707331.7154.1.camel@laptop>
	 <alpine.LNX.2.00.0908192125180.4364@cinke.fazekas.hu>
	 <20090820105645.GA23635@elte.hu>
	 <alpine.LNX.2.00.0908201814270.12548@cinke.fazekas.hu>
	 <alpine.LNX.2.00.0908282240480.32738@cinke.fazekas.hu>
	 <alpine.LNX.2.00.0909032350580.20701@cinke.fazekas.hu>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 08:26:01 +0200
Message-Id: <1252045561.7005.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 23:57 +0200, Marton Balint wrote:

> >> In the meantime, I updated my original C program and also created a kernel 
> >> module (schedtest_mod.c) which causes the same scheduling problems as the 
> >> kernel module of my TV card. The kernel module is a skeleton of the 
> >> infrared sensor polling code in cx88-input.c. It uses 
> >> schedule_delayed_work, this seems to cause the problem. The C program 
> >> (schedtest.c) is also updated, it now detects the number of CPU cores, from 
> >> now, what you can set as a command line parameter is the CPU core number, 
> >> on which the schedtest processes will not quit. (previously this was always 
> >> the last core).
> >> 
> >> So to reproduce the bug on a dual core system, compile and insert the 
> >> kernel module (schedtest_mod.c). Then check dmesg, it should contain on 
> >> which CPU core is the delayed_work running. You should use the CPU core id 
> >> of the _other_ CPU core as a command line parameter to the updated 
> >> schedtest program.
> >> 
> >> And by the way, thank you guys for the help so far, hopefully we'll get to 
> >> the bottom of this :)
> >
> > I reproduced the bug with the previously provided kernel module and C program 
> > on a different computer (it's a laptop with a core2 duo P8400 CPU), and also 
> > bisected the bug to this commit:
> >
> > sched: fine-tune SD_MC_INIT:
> > 14800984706bf6936bbec5187f736e928be5c218
> >
> > If I add again the removed SD_BALANCE_NEWIDLE to flags, then everything works 
> > as expected. So what would be the correct fix for this bug? Revert the patch? 
> > Or just add SD_BALANCE_NEWIDLE to flags?

Or, figure out what's going weird with that module loaded.

> Ingo, Peter, could any of you guys have a look at the commit that caused 
> this bug? Is it OK to revert it? Or a fix somewhere else is necessary? I'm 
> pushing this because I hope that this bug will get fixed in the upcoming 
> stable kernel...

Where does your schedtest.c and schedtest_mod.c live?

	-Mike

