Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbXFTLfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbXFTLfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXFTLfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:35:45 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:43272 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751683AbXFTLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:35:44 -0400
Message-ID: <46790DFA.5090503@aitel.hist.no>
Date: Wed, 20 Jun 2007 13:22:34 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706061229.24486.jesse.barnes@intel.com>
In-Reply-To: <200706061229.24486.jesse.barnes@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
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
I assume this cannot be fixed by the simple approach
of echoing some useful numbers into /proc/mtrr like
we used to do for video memory? (Before X did this
automatically?)

An extra bootscript seems better than loosing memory.


Helge Hafting
