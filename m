Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZBRTyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZBRTyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZBRTyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:54:45 -0500
Received: from rosi.naasa.net ([212.8.0.13]:57128 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZBRTyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:54:44 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Frans Pop <elendil@planet.nl>
Subject: Re: cpuinfo shows wrong MHz value
Date: Wed, 18 Feb 2009 20:54:38 +0100
User-Agent: KMail/1.9.9
References: <200902142217.51655.jplatte@naasa.net> <200902150811.36826.jplatte@naasa.net> <200902151741.30303.elendil@planet.nl>
In-Reply-To: <200902151741.30303.elendil@planet.nl>
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902182054.38840.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 15. Februar 2009 schrieben Sie:
> Can you check whether or not you were also using p4-clockmode with the
> last kernel that did show correct values? The same grep command should
> show this.

The last kernel that was working correct was 2.6.24 (here the output from 
2.6.24.6):

affected_cpus:0
cpuinfo_cur_freq:1600000
cpuinfo_max_freq:1600000
cpuinfo_min_freq:400000
scaling_available_frequencies:400000 600000 800000 1000000 1200000 1400000 
1600000
scaling_available_governors:conservative ondemand userspace powersave 
performance
scaling_cur_freq:1600000
scaling_driver:p4-clockmod
scaling_governor:performance
scaling_max_freq:1600000
scaling_min_freq:400000
root@jako:/sys/devices/system/cpu/cpu0/cpufreq> uname -a
Linux jako 2.6.24.6 #1 PREEMPT Tue Feb 17 20:33:58 CET 2009 i686 GNU/Linux

The log output is somewhat limited, because I forgot to enable debugging:

root@jako:/sys> dmesg | grep clock
Time: tsc clocksource has been installed.
intel8x0_measure_ac97_clock: measured 55906 usecs
intel8x0: measured clock 71 rejected
intel8x0: clocking to 48000
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available

Here is the output from 2.6.28.5 and debug info enabled:
root@jako:~> dmesg | grep clock
intel8x0_measure_ac97_clock: measured 55894 usecs
intel8x0: measured clock 71 rejected
intel8x0: clocking to 48000
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available

It looks like the debug code does not provide more information.

> It would also help to know which kernel version was the last working one.
> You mentioned 2.6.26, but with some uncertainty. Can you check for 2.6.26
> and possibly for 2.6.27?

I was wrong, it was working long ago with kernel 2.6.24, sorry. 

> Note that p4-clockmode does not really help with power saving, but only
> with thermal management (prevention of overheating). Possibly the
> speedstep or acpi-cpufreq modules will work better for you, but it can
> also be they don't support your processor.

Yes, I know. I just installed it to play with it and now I'm using the 
performance governor all the time which disables frequency modulation.

> That does not mean this issue should not be looked into of course.

I can simply unload the module but a fix would be appreciated as well :)

regards,
Jörg
