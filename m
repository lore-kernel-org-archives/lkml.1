Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbYEUBWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbYEUBWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYEUBVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:21:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2352 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbYEUBVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:21:51 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5299"; a="3104325"
Message-ID: <4833792D.5050704@qualcomm.com>
Date: Tue, 20 May 2008 18:21:49 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com>	<20080312143253.3dd72c7f.pj@sgi.com>	<47D83858.4030806@qualcomm.com>	<20080312153712.bc5df7a1.pj@sgi.com>	<47D8593A.6040503@qualcomm.com>	<20080312183059.6716d630.pj@sgi.com>	<47D87BE5.4010702@qualcomm.com>	<20080313020300.92244956.pj@sgi.com>	<47FE5655.10900@qualcomm.com>	<20080414133902.7878cfce.pj@sgi.com>	<1210329926.13978.224.camel@twins>	<20080509061727.5057de1f.pj@sgi.com>	<1210333738.13978.246.camel@twins>	<20080509070314.f86aece4.pj@sgi.com>	<1210335270.13978.252.camel@twins> <20080509073650.045d037d.pj@sgi.com>
In-Reply-To: <20080509073650.045d037d.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Peter, responding to pj:
>>> What am I missing?
>> Two points:
>>
>>  - we can't currently set irq affinities for non-existent (aka new) IRQs
>>  - its a shame to duplicate the masks - most of this information would
>>    also be used in the cpuset structure used to place the tasks.
> 
> Ok.  Let me twist this a turn tighter then.
> 
> The first of your two points, a default affinitiy mask for new irqs,
> would seem to require a kernel change.  But that change could be a
> single cpumask, settable in /sys somewhere, specifying the default
> affinity.  If that's all we needed, it would be easy.
Looks like we arrived at the same conclusion. See my prev reply.
I'm in the process of making a patch for exposing default affinity mask.

> The second of your two points, "duplicating masks", seems more delicate.
There is actually no duplication as far as I can see because IRQ layer already 
has the default_mask variable. It just needs to be exposed via /proc or /sys.

> The space of named cpusets (the directory pathnames below the usual
> mount point, /dev/cpuset) is not really much more compact than the
> set of interesting cpumasks.  But I suppose your point is that some
> of the -particular- cpumasks already named by the cpuset hierarchy
> are tantilizingly close to the set of interesting cpumasks needed for
> irq affinity ... close given some combination of union, intersection,
> set difference and compliment operations, given my usual bias toward
> looking at such things as this using set theory mechanisms.  That is,
> for example, one might want all the CPUs in cpusets foo, bar and baz,
> except the CPUs in cpuset blip, to handle IRQs so and so.
> 
> Let me think on that ... it's my nap time now.
This would be an overkill imho.

Max

