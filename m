Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYAZVpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYAZVpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 16:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAZVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 16:45:25 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45459 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbYAZVpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 16:45:25 -0500
Date: Sat, 26 Jan 2008 22:45:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Message-ID: <20080126214534.GA26651@uranus.ravnborg.org>
References: <479B69D2.5050603@wpkg.org> <200801262238.19222.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801262238.19222.toralf.foerster@gmx.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Ingo + Peter.

	Sam

On Sat, Jan 26, 2008 at 10:38:15PM +0100, Toralf Förster wrote:
> It seems to be rather a scheduler issue than a governor issue b/c
> the issue went away after unsetting CONFIG_FAIR_GROUP_SCHED.
> 
> If I unselect CONFIG_FAIR_GROUP_SCHED then the %CPU value raises 80%
> - which forces the ondemand governor do speed up the CPU frequency:
> 
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  7137 tfoerste  20   0  1796  488  428 R 95.5  0.0   0:01.40 factor
>  7083 dnetc     39  19   664  348  264 R  2.1  0.0   3:08.33 dnetc
>  4033 root      20   0 97252 9420 4008 R  0.7  0.9   0:09.43 X
>  
> 
> Am Samstag, 26. Januar 2008 schrieben Sie:
> > Toralf Förster wrote:
> > 
> > > I use a 1-liner for a simple performance check : "time factor 819734028463158891"
> > > Here is the result for the new (Gentoo) kernel 2.6.24:
> > > 
> > > With the  ondemand governor of the  I get:
> > > 
> > > tfoerste@n22 ~/tmp $ time factor 819734028463158891
> > > 819734028463158891: 3 273244676154386297
> > > 
> > > real    0m32.997s
> > > user    0m15.732s
> > > sys     0m0.014s
> > > 
> > > With the ondemand governor the CPU runs at 600 MHz,
> > > whereas with the performance governor I get :
> > > 
> > > tfoerste@n22 ~/tmp $ time factor 819734028463158891
> > > 819734028463158891: 3 273244676154386297
> > > 
> > > real    0m10.893s
> > > user    0m5.444s
> > > sys     0m0.000s
> > > 
> > > (~5.5 sec as I expected) b/c the CPU is set to 1.7 GHz.
> > > 
> > > The ondeman governor of previous kernel versions however automatically increased
> > > the CPU speed from 600 MHz to 1.7 GHz.
> > > 
> > > My system is a ThinkPad T41, I'll attach the .config 
> > 
> > During the test, run top, and watch your CPU usage. Does it go above 80% 
> > (the default for 
> > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold).
> > 
> > ondemand CPUfreq governor has a few tunables, described in 
> > Documentation/cpu-freq. One of them is up_threshold:
> > 
> > up_threshold: defines what the average CPU usaged between the samplings
> > of 'sampling_rate' needs to be for the kernel to make a decision on
> > whether it should increase the frequency. For example when it is set
> > to its default value of '80' it means that between the checking
> > intervals the CPU needs to be on average more than 80% in use to then
> > decide that the CPU frequency needs to be increased.
> > 
> > What CPUFreq processor driver are you using?
> > 
> > 
> > I had a similar problem with CPUfreq and dm-crypt (slow reads), see 
> > (more setup problem than something kernel-related):
> > 
> > http://blog.wpkg.org/2008/01/22/cpufreq-and-dm-crypt-performance-problems/
> > 
> > 
> 
> -- 
> MfG/Sincerely
> 
> Toralf Förster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


