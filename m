Return-Path: <linux-kernel-owner+w=401wt.eu-S935053AbYEUBPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935053AbYEUBPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760988AbYEUBPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:15:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8451 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368AbYEUBPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:15:00 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5299"; a="3281981"
Message-ID: <48337792.20606@qualcomm.com>
Date: Tue, 20 May 2008 18:14:58 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com>	<20080312143253.3dd72c7f.pj@sgi.com>	<47D83858.4030806@qualcomm.com>	<20080312153712.bc5df7a1.pj@sgi.com>	<47D8593A.6040503@qualcomm.com>	<20080312183059.6716d630.pj@sgi.com>	<47D87BE5.4010702@qualcomm.com>	<20080313020300.92244956.pj@sgi.com>	<47FE5655.10900@qualcomm.com>	<20080414133902.7878cfce.pj@sgi.com>	<1210329926.13978.224.camel@twins> <20080509061727.5057de1f.pj@sgi.com>
In-Reply-To: <20080509061727.5057de1f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Peter wrote:
>> That's a new feature; and its quite common that new features require
>> code changes.
> 
> It's common for new features to require code changes to take advantage
> of the new features.
> 
> It's less desirable that taking advantage of such new features breaks
> existing, basically unrelated, code.
> 
> My gut sense is that, in a misguided effort to find a "simple" answer
> to irq distribution, we (well, y'all) are trying to attach this
> feature to cpusets or cgroups.
> 
> Let me ask a different question:
> 
>   What solutions would you (Max, Peter, Ingo, lurkers, ...) be
>   suggesting for this 'IRQ affinity' problem if cpusets and
>   cgroups didn't exist in any form whatsoever?

As Peter explained I'm focusing on the "CPU isolation" aspect. ie Shielding a 
CPU (or a set of CPUs) from various kernel activities (load balancing, soft 
and hard irq handling, workqueues, etc).

For the IRQs specifically all I need is to be able to tell the kernel to not 
route IRQs to certain CPUs. That's mostly works already via 
/proc/irq/N/smp_affinity, the problem is dynamically allocated irqs because 
/proc/irq/N directory does not exist until those IRQs are allocated/enabled.

Originally I introduced global cpu_isolated_map. IRQ code was using that map 
to exclude CPU(s) from IRQ routing. What I realized now is that all I need is
/proc/irq/default_smp_affinity. In other words I just need to export default 
mask used by the IRQ layer. I think this makes sense regardless of what cpuset 
  based solution we'll come up with.

Max
