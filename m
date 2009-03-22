Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZCVMtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZCVMtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 08:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZCVMth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 08:49:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50688 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZCVMtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 08:49:36 -0400
Date: Sun, 22 Mar 2009 13:48:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090322124818.GA31466@elte.hu>
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302235120.GF27240@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Sat, Feb 28, 2009 at 10:44:30AM +0100, Ingo Molnar wrote:
> >
> >* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> >
> >> 
> >> True, but by how much? 212 bytes, out of 7285943 bytes which 
> >> is very very small percentage wise.
> >
> >How does this eliminate the validity of the patch?
> >
> 
> It costs 212 bytes to leave is_vsmp_box() to not just be a dummy 
> no-op. Having is_vsmp_box() detect if the hardware is indeed vSMP, 
> is meaningful even when CONFIG_VSMP is not turned on.  This is 
> because is_vsmp_box() is used to tell the kernel, that although 
> the cpus being used are supposed to have TSCs in sync, they are 
> not really in sync.  This is because you cannot ensure TSCs won't 
> drift between multiple boards being aggregated on vSMP systems. 
> Take the case of distro kernels.  Distro kernels typically do not 
> have CONFIG_X86_VSMP on.  Due to the large internode cacheline 
> setting, CONFIG_VSMP would not be on on the generic distro 
> installer kernels. If is_vsmp_box() is a no-op, the generic distro 
> installer kernels will assume TSCs to be synched, which is bad.  
> Hence, it will be nice if, for the cost of 212 bytes, vsmp64.o be 
> compiled either unconditionally, OR conditionally for 64bit 
> architectures only.  The question is, is 212 bytes out of 7285943 
> bytes too expensive for the generic kernels?  I hope not.

Sorry - got distracted and forgot about this thread. The TSC quirk 
indeed looks required for your systems - you dont have a reliable 
TSC due to virtualization, right?

Mind sending a patch (partial revert or so) against latest -tip that 
fixes that?

	Ingo
