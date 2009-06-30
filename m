Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZF3WRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZF3WRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZF3WQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:16:53 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47271 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753913AbZF3WQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:16:52 -0400
Date: Tue, 30 Jun 2009 18:16:23 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
In-Reply-To: <20090630213146.GA17492@elte.hu>
Message-ID: <alpine.DEB.1.10.0906301809330.11362@gentwo.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu>
 <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Ingo Molnar wrote:

> > The difference between actual and possible cpus only has to be the
> > number of processors that could be brought up later. In a regular
> > system that is pretty much zero. In a fancy system with actual
> > hotpluggable cpus there would be a difference but usually the
> > number of hotpluggable cpus is minimal.
>
> You are arguing against the concept of the demand-allocation of
> resources, and i dont think that technical argument can be won.

I looked at allocating for online cpus only a couple of years back but at
that per cpu state was kept for offlined cpus in per cpu areas. There are
numerous assumptions in per cpu handling all over the kernel that a percpu
area is always available. We successfully restricted it to only possible
cpus. ACPI may be the worst offender there. If you can get all of that
addressed then we can move to pure on demand allocation. Which also would
complicate a per cpu memory allocator allocator.

> Sure you dont have to demand-allocate if you know the demand
> beforehand and can preallocate and size accordingly.

Well you know the demand from the BIOS information.

> But what if not? What if the kernel can run on up to 4096 CPUs and
> runs on a big box. Why should a virtual machine have the illogical
> choice between either wasting a lot of RAM preallocating stuff, or
> limiting its own extendability.

The kernel may be able to run on 4096 but the machines config information
that is available via ACPI knows how many processors the machine we are
booting on is able to add.

> In other words: your proposed change in essence reduces the utility
> of CPU hotplug. It's a bad idea.

Change? I am talking about what is the case.
