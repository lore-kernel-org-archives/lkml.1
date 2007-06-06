Return-Path: <linux-kernel-owner+w=401wt.eu-S935581AbXFFU1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935581AbXFFU1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763366AbXFFU1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:27:00 -0400
Received: from lucidpixels.com ([75.144.35.66]:57024 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbXFFU07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:26:59 -0400
Date: Wed, 6 Jun 2007 16:26:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061229.24486.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706061626360.21038@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

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
> Justin, can you please test and make sure this patch works for
> you too?  It'll only work around the problem, but it's better
> than having to do mem= by hand or waiting for a fix from your
> BIOS vendor.
>
> Thanks,
> Jesse

Against what kernel version does this patch apply?

linux-2.6.21# patch -p1 < ../mtrr.patch
patching file arch/i386/kernel/cpu/mtrr/generic.c
Hunk #2 succeeded at 66 (offset -18 lines).
patching file arch/i386/kernel/cpu/mtrr/if.c
patching file arch/i386/kernel/cpu/mtrr/main.c
patching file arch/i386/kernel/cpu/mtrr/mtrr.h
can't find file to patch at input line 160
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/arch/x86_64/kernel/bugs.c b/arch/x86_64/kernel/bugs.c
|index c3c6b91..c138eac 100644
|--- a/arch/x86_64/kernel/bugs.c
|+++ b/arch/x86_64/kernel/bugs.c
--------------------------
File to patch:

