Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZEEJau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZEEJau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 05:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZEEJal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 05:30:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35306 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZEEJal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 05:30:41 -0400
Date: Tue, 5 May 2009 11:35:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD Magny-Cours
Message-ID: <20090505093520.GL23223@one.firstfloor.org>
References: <20090504173330.GF28728@alberich.amd.com> <87vdogbp4g.fsf@basil.nowhere.org> <20090505092238.GB29045@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505092238.GB29045@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Best example is node interleaving. Usually you won't get a SRAT table
> on such a system.

That sounds like a BIOS bug. It should supply a suitable SLIT/SRAT
even for this case. Or perhaps if the BIOS are really that broken
add a suitable quirk that provides distances, but better fix the BIOSes.

 Thus you see just one NUMA node in
> /sys/devices/system/node.  But on such a configuration you still see
> (and you want to see) the correct CPU topology information in
> /sys/devices/system/cpu/cpuX/topology. Based on that you always can
> figure out which cores are on the same physical package independent of
> availability and contents of SRAT and even with kernels that are
> compiled w/o NUMA support.

So you're adding a x86 specific mini NUMA for kernels without NUMA
(which btw becomes more and more an exotic case -- modern distros
are normally unconditionally NUMA) Doesn't seem very useful.

My problem with that is that imho the x86 topology information is already
too complicated -- i suspect very few people can make sense of it --
and you're making it even worse, adding another strange special case.

On the other hand NUMA topology is comparatively straight forward and well 
understood and it's flexible enough to express your case too.

>    physical package == two northbridges (two nodes)
> 
> and this needs to be represented somehow in the kernel.

It's just two nodes with a very fast interconnect.

> 
> > Who needs this additional information?
> 
> The kernel needs to know this when accessing processor configuration
> space, when accessing shared MSRs or for counting northbridge specific
> events.

You're saying there are MSRs shared between the two in package nodes?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
