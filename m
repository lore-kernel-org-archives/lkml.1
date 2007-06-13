Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbXFMBMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbXFMBMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 21:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXFMBMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 21:12:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36499 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXFMBMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 21:12:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706061229.24486.jesse.barnes@intel.com>
Date: Tue, 12 Jun 2007 19:11:21 -0600
In-Reply-To: <200706061229.24486.jesse.barnes@intel.com> (Jesse Barnes's
	message of "Wed, 6 Jun 2007 12:29:23 -0700")
Message-ID: <m14plcpsjq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jesse.barnes@intel.com> writes:

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

A quick update.  This patch is horribly incorrect on a socket F 
opteron/Athlon 64 with memory above 4GB.

In particular those cpus are capable of mapping all of memory
above 4GB as write back without using a single MTRR.

So examining MTRRs is insufficient.

Eric
