Return-Path: <linux-kernel-owner+w=401wt.eu-S967748AbXFHIVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967748AbXFHIVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936377AbXFHIU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:20:58 -0400
Received: from lucidpixels.com ([75.144.35.66]:50437 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936302AbXFHIU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:20:56 -0400
Date: Fri, 8 Jun 2007 04:20:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706071530.51552.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706080419260.29016@p34.internal.lan>
References: <200706071530.51552.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Jesse Barnes wrote:

> On some machines, buggy BIOSes don't properly setup WB MTRRs to
> cover all available RAM, meaning the last few megs (or even gigs)
> of memory will be marked uncached.  Since Linux tends to allocate
> from high memory addresses first, this causes the machine to be
> unusably slow as soon as the kernel starts really using memory
> (i.e. right around init time).
>
> This patch works around the problem by scanning the MTRRs at
> boot and figuring out whether the current end_pfn value (setup
> by early e820 code) goes beyond the highest WB MTRR range, and
> if so, trimming it to match.  A fairly obnoxious KERN_WARNING
> is printed too, letting the user know that not all of their
> memory is available due to a likely BIOS bug.
>
> Something similar could be done on i386 if needed, but the boot
> ordering would be slightly different, since the MTRR code on i386
> depends on the boot_cpu_data structure being setup.
>
> This patch incorporates the feedback from Eric and Andi:
>  - use MAX_VAR_RANGES instead of NUM_VAR_RANGES
>  - move array declaration to header file as an extern
>  - add command line disable option "disable_mtrr_trim"
>  - don't run the trim code if the MTRR default type is cacheable
>  - don't run the trim code on non-Intel machines
>
> Justin, feel free to test again if you have time and add your
> "Tested-by" signoff.
>
> Andi, as for large pages, do you think this is ok as is, or should
> I trim a larger granularity?  If so, what granularity?
>
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
>
> Thanks,
> Jesse
>

Looks good, it sustained many backups, bzip2, and even some encoding
processes, no issues.  Let me know if you need me to test any future
iterations of the patch, so far each has been fine, no problems to
report using the 965WH motherboard with 8GB of memory.

Signed-off-by:  Justin Piszcz <jpiszcz@lucidpixels.com>

