Return-Path: <linux-kernel-owner+w=401wt.eu-S1762749AbYB1UYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762749AbYB1UYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYB1UXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:23:55 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33081 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYB1UXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:23:54 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5241"; a="988951"
Message-ID: <47C71857.5060606@qualcomm.com>
Date: Thu, 28 Feb 2008 12:23:51 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Paul Jackson <pj@sgi.com>, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com> <20080228090847.GA1133@elte.hu>
In-Reply-To: <20080228090847.GA1133@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Paul Jackson <pj@sgi.com> wrote:
> 
>>> i've queued up your patches in sched-devel.git
>> Before this patchset gets too far, I'd like to decide on whether to 
>> adapt my suggestion to call that per-cpuset flag 'cpus_system' (or 
>> anything else with 'cpu' in it, perhaps 'system_cpus' would be more 
>> idiomatic), rather than the tad too generic 'system'.
> 
> yeah. In fact i'm not at all sure this is really a "system" thing - it's 
> more of a "bootup" default.
> once the system has booted up and the user is in a position to create 
> cpusets, i believe the distinction and assymetry between any bootup 
> cpuset and the other cpusets should vanish. The "bootup" cpuset is just 
> a convenience container to handle everything that the box booted up 
> with, and then we can shrink it (without having to enumerate every PID 
> and every irq and other resource explicitly) to make place for other 
> cpusets.
> 
> maybe it's even more idomatic to call it "set0" and just create a 
> /dev/cpuset/set0/ directory for it and making it an explicit cpuset - 
> instead of the hardcoded /dev/cpusets/system thing? Do you have any 
> established naming scheme for cpusets that we could follow here?

I think that is a separate thing. Bootup default is one thing and being able
to explicitly allow/disallow kernel activity on a CPU(s) is another.

I think "boot" or "set0" makes perfect sense. In fact that was the first thing
I noticed when I started playing with it. ie Even if I just wanted to isolated
 one cpu I now need to create a cpuset for the other cpus and move all the
tasks there explicitly. It'd be very useful if it happens by default.

Max



