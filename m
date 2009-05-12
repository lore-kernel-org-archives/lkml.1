Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbZELWny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbZELWny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZELWnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:43:45 -0400
Received: from www.tglx.de ([62.245.132.106]:33200 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZELWno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:43:44 -0400
Date: Wed, 13 May 2009 00:42:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
In-Reply-To: <1242167171.3462.13.camel@localhost>
Message-ID: <alpine.LFD.2.00.0905130027530.3561@localhost.localdomain>
References: <1242094321.7214.156.camel@localhost.localdomain>  <4A095139.30347.48783F@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <1242167171.3462.13.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, john stultz wrote:
> > stored or accumulated before. For the TSC calibaration one could build the average 
> > of previous calibration values (if the value jumps between different numbers).
> > That would require a sysctl (or equivalent) interface however.
> 
> I still feel that a sysctrl or /sys/ interface for this sort of thing is
> overkill. It creates yet another interface we have to manage, and really
> doesn't improve the situation more then the boot option would.
> Additionally it would require quite a bit of work at the clocksource
> level to allow for re-calibration (currently we avoid this by
> disqualifying the TSC if it changes freq). 
> 
> That said, I've gotten very few positive comments from my patch, so I'm
> going to give it one more spin (to address Serge's point) and if folks
> are still feeling blah about it I'll stop pushing it.

I'm fine with the command line option, but I refuse to add some sys/
thingy which makes us add extra calibration stuff.

Honestly all this is just the futile attempt to fix the flaws of NTP
via (super)user interaction.

Darn, it can not be that hard to adjust the math to do what you think
it should do. I'm not an expert on that NTP stuff, but blindly
stuffing the last known value into the kernel and expect that the
calibration value did not change is nonsense.

You know the calibration value which created the last known parameters
and you want an extra interface to inject this last known calibration
value into the kernel instead of doing the math of adjusting the NTP
parameters according to the change of calibration values ?

Thanks,

	tglx


