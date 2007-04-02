Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXDBQXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXDBQXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbXDBQXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:23:07 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46239 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXDBQXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:23:06 -0400
Message-ID: <46112D40.20508@zytor.com>
Date: Mon, 02 Apr 2007 09:20:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org,
       cpufreq@lists.linux.org.uk, davej@codemonkey.org.uk
Subject: Re: [PATCH 1/3] Introduce cpuid_on_cpu() and cpuid_eax_on_cpu()
References: <20070402113831.GA6785@localhost.sw.ru> <200704021410.29623.ak@suse.de>
In-Reply-To: <200704021410.29623.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Monday 02 April 2007 13:38, Alexey Dobriyan wrote:
>> They will be used by cpuid driver and powernow-k8 cpufreq driver.
>>
>> With these changes powernow-k8 driver could run correctly on OpenVZ kernels
>> with virtual cpus enabled (SCHED_VCPU).
> 
> This means openvz has multiple virtual CPU levels? One for cpuid/rdmsr and one
> for the rest of the kernel? Both powernow-k8 and cpuid attempt to schedule
> to the target CPU so they should already run there. But it is some other CPU,
> but when they ask your _on_cpu() functions they suddenly get a "real" CPU?
> Where is the difference between these levels of virtualness? 
> 

The CPUID and MSR drivers do not schedule to the target CPU; instead, on 
hardware, they rely on IPI'ing the target processor if it is not the one 
that's currently running.

There were a lot of discussion back when about which was the better 
solution.  Alan Cox, in particular, really preferred the interrupt 
solution as being less likely to cause implicit deadlock.

I do want to add that it's been on my list for some time -- in fact, I 
keep implementing it half-way and then having other things to do -- to 
add MSR and CPUID ioctls() that allow the full register file to be set 
and read back, in order to support architecturally broken MSR and CPUID 
levels.

	-hpa
