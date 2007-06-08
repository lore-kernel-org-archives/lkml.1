Return-Path: <linux-kernel-owner+w=401wt.eu-S970059AbXFHVPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970059AbXFHVPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbXFHVPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:15:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbXFHVPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:15:44 -0400
Date: Fri, 8 Jun 2007 14:15:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-Id: <20070608141500.0af58fac.akpm@linux-foundation.org>
In-Reply-To: <200706061229.24486.jesse.barnes@intel.com>
References: <200706061229.24486.jesse.barnes@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 12:29:23 -0700
Jesse Barnes <jesse.barnes@intel.com> wrote:

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

i386 allmodconfig:

arch/i386/kernel/cpu/mtrr/main.c: In function 'mtrr_trim_uncached_memory':
arch/i386/kernel/cpu/mtrr/main.c:655: error: 'end_pfn' undeclared (first use in this function)
arch/i386/kernel/cpu/mtrr/main.c:655: error: (Each undeclared identifier is reported only once
arch/i386/kernel/cpu/mtrr/main.c:655: error: for each function it appears in.)

I'll poke some ifdefs in there.
