Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYDJSD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYDJSD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbYDJSDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:03:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62015 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbYDJSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:03:03 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5271"; a="2347141"
Message-ID: <47FE5655.10900@qualcomm.com>
Date: Thu, 10 Apr 2008 11:03:01 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com>	<20080312143253.3dd72c7f.pj@sgi.com>	<47D83858.4030806@qualcomm.com>	<20080312153712.bc5df7a1.pj@sgi.com>	<47D8593A.6040503@qualcomm.com>	<20080312183059.6716d630.pj@sgi.com>	<47D87BE5.4010702@qualcomm.com> <20080313020300.92244956.pj@sgi.com>
In-Reply-To: <20080313020300.92244956.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The context here was that we were talking about a way to group irqs and assign 
them to the cpusets. I was proposing to just treat IRQs as tasks, and you were 
proposing to add some additional grouping. Replies inline below.

Paul Jackson wrote:
> Max K wrote:
>> cleaner imo than dealing with complex irq grouping schemes.
> 
> What's this "complex irq grouping scheme" that you're referring to?
> 
> If it's what I posted last week, with named sets of irqs, and each
> cpuset naming which set it belonged to, that seems to me to actually
> fit the usage pattern rather well.
I was just saying that cpuset already provides a nice grouping. After thinking 
about this some more I still do not see a need to group IRQs before assigning 
them to the cpusets. That's the complexity I was talking about.

> The jobs running in particular cpusets need only know the 'name' of
> the set of irqs it makes sense to send to its CPUs (the realtime
> irqs, a particular piece of hardwares irqs, the ordinary system
> irqs, the absolute minimum set of irqs, ...) and the system admin
> gets to specify, one time, which irq numbers are in which named
> set, or to change, later on, which set a particular irq is in, all
> without having to have detailed knowledge of the jobs that want
> particular irq sets directed to their CPUs.
> 
> We tend to label whatever makes sense to us as "simple", and whatever
> doesn't seem necessary in our experience, or doesn't make sense, as
> "complex".
> 
> Such labels are losing their meaning these days, other than to help
> others figure out what we favor, or disfavor.
I agree in general. In this particular case additional grouping introduces 
even more hierarchy. I seems to me that
	"irqN -> cpu1, cpu2, cpu3"
is a very simple, straightforward relationship. Whereas
	"irqN -> groupX"
	"groupX -> cpu1"
	"groupX -> cpu2"
	"groupX -> cpu3"
Is not that straightforward.

Anyway. I think it all boils down to the compatibility with existing 
user-space apps. I still like the simple approach of treating irqs like tasks 
when it comes to assigning them to the cpusets. Which as we discussed earlier 
in some cases may require an extra level in the cpuset hierarchy. The question 
is, is that really such a big problem. If we make in kernel boot set optional, 
by default all irqs will be in the root cpuset. Which means people can still 
use /proc/irq/N/smp_affinity and manage irqs just like they do now. There is 
no compatibility issues in that case.

So do you think the apps compatibility is an issue in that case ?
Also isn't it likely that the apps will gradually adapt to handling 
multi-level cpusets anyway ? I mean you guys were talking about how wonderful 
and flexible cpusets are, but we cannot seem to use the flexibility because 
the apps are designed for a flat layout.

Max
