Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbXFUTlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbXFUTlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbXFUTlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:41:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:60524 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbXFUTk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KhQoNiTGVgPvzsCveHzaG4PgQWI9WXxJqesd1ZPJdPq/xL2O4fFhFw0EjYk5aCKUMtAXJBiJbja2ApKVGLsysd8OLDEcqsFuzFZUI9fFWlHMmsohxNsCOg8RDmF495ux8K5RIPT/Uq1iux7tlXywaVgrkktTVRvmqZl97bk8RFc=
Message-ID: <86802c440706211240s27d58679k43cee4488ce8a70e@mail.gmail.com>
Date: Thu, 21 Jun 2007 12:40:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <200706071530.51552.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706071530.51552.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Jesse Barnes <jesse.barnes@intel.com> wrote:
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
>   - use MAX_VAR_RANGES instead of NUM_VAR_RANGES
>   - move array declaration to header file as an extern
>   - add command line disable option "disable_mtrr_trim"
>   - don't run the trim code if the MTRR default type is cacheable
>   - don't run the trim code on non-Intel machines
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

NAK.

for AMD Rev F Opteron later CPU, BIOS will not set WB in MTRR for 4G above mem.

This patch will get rid of those RAM.

YH
