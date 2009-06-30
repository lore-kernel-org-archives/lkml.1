Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZF3VdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZF3VdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZF3Vcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:32:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53993 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZF3Vcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:32:54 -0400
Date: Tue, 30 Jun 2009 23:31:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and
	improve lpage NUMA support
Message-ID: <20090630213146.GA17492@elte.hu>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906301533400.29795@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 30 Jun 2009, Ingo Molnar wrote:
> 
> > Yeah, it's a bug for something like a virtual environment which 
> > boots generic kernels that might have 64 possible CPUs (on a 
> > true 64-way system), but which will have fewer in practice.

i think this bit should be quoted too, because it is the crux of the 
issue:

> > It's pretty basic stuff: the on-demand allocation of percpu 
> > resources.

> A machine (and a virtual environment) can indicate via the BIOS 
> tables or ACPI that there are less "possible" cpus. That is 
> actually very common.
> 
> The difference between actual and possible cpus only has to be the 
> number of processors that could be brought up later. In a regular 
> system that is pretty much zero. In a fancy system with actual 
> hotpluggable cpus there would be a difference but usually the 
> number of hotpluggable cpus is minimal.

You are arguing against the concept of the demand-allocation of 
resources, and i dont think that technical argument can be won.

Sure you dont have to demand-allocate if you know the demand 
beforehand and can preallocate and size accordingly.

But what if not? What if the kernel can run on up to 4096 CPUs and 
runs on a big box. Why should a virtual machine have the illogical 
choice between either wasting a lot of RAM preallocating stuff, or 
limiting its own extendability.

In other words: your proposed change in essence reduces the utility 
of CPU hotplug. It's a bad idea.

	Ingo
