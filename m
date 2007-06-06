Return-Path: <linux-kernel-owner+w=401wt.eu-S935597AbXFFU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935597AbXFFU3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXFFU3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:29:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:29741 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbXFFU3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236353455"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 13:28:52 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061626360.21038@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706061626360.21038@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061328.53443.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 1:26 pm Justin Piszcz wrote:
> On Wed, 6 Jun 2007, Jesse Barnes wrote:
> > On some machines, buggy BIOSes don't properly setup WB MTRRs to
> > cover all available RAM, meaning the last few megs (or even gigs)
> > of memory will be marked uncached.  Since Linux tends to allocate
> > from high memory addresses first, this causes the machine to be
> > unusably slow as soon as the kernel starts really using memory
> > (i.e. right around init time).
> >
> > This patch works around the problem by scanning the MTRRs at
> > boot and figuring out whether the current end_pfn value (setup
> > by early e820 code) goes beyond the highest WB MTRR range, and
> > if so, trimming it to match.  A fairly obnoxious KERN_WARNING
> > is printed too, letting the user know that not all of their
> > memory is available due to a likely BIOS bug.
> >
> > Something similar could be done on i386 if needed, but the boot
> > ordering would be slightly different, since the MTRR code on i386
> > depends on the boot_cpu_data structure being setup.
> >
> > Justin, can you please test and make sure this patch works for
> > you too?  It'll only work around the problem, but it's better
> > than having to do mem= by hand or waiting for a fix from your
> > BIOS vendor.
> >
> > Thanks,
> > Jesse
>
> Against what kernel version does this patch apply?

Um... git as of b4946ffb1860597b187d78d61ac6504177eb0ff8.  Sorry I 
should have updated before spinning the patch (will do now).

Jesse
