Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbXJaKTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbXJaKTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbXJaKSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:18:53 -0400
Received: from 8bytes.org ([88.198.83.132]:36740 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbXJaKSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:18:52 -0400
Date: Wed, 31 Oct 2007 11:18:48 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, benjamin.serebrin@amd.com,
       vojtech@suse.cz
Subject: Re: Whats the purpose of get_cycles_sync()
Message-ID: <20071031101848.GD29700@8bytes.org>
References: <20071030174452.GA18619@amd.com> <p73sl3s2w29.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73sl3s2w29.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Tue, Oct 30, 2007 at 09:21:02PM +0100, Andi Kleen wrote:
> "Joerg Roedel" <joerg.roedel@amd.com> writes:
> 
> > I would like to answer what the special purpose of the get_cycles_sync()
> > function is in the x86 architecture. In special I ask myself why
> > this function has to be *sync*?
> 
> Vojtech had one test that tested time monotonicity over CPUs 
> and it constantly failed until we added the CPUID on K8 C stepping. 
> He can give details on the test.

Interesting, I wasn't aware of that.

> I suspect the reason was because the CPU reordered the RDTSCs so that
> a later RDTSC could return a value before an earlier one. This can
> happen because gettimeofday() is so fast that a tight loop calling it can
> fit more than one iteration into the CPU's reordering window.

Ok, that is the reason why the get_cycles_sync() function only exists on
x86_64 and not on i386, because on i386 gettimeofday() is a real
syscall?

> That is why newer kernels use RDTSCP if available which doesn't need
> to be intercepted and is synchronous.  And since all AMD SVM systems
> have RDTSCP they are fine.

The problem with KVM here is that they wan't to migrate guests between
Intel and AMD boxes. So they don't export RDTSCP or FEATURE_SYNC_TSC to
the guests in the CPUID calls. A 64bit Linux guest will execute the
CPUID in that function.

Joerg
