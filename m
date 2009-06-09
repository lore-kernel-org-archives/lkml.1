Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbZFIM0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbZFIM0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbZFIM0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:26:15 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:58889 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703AbZFIM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:26:14 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Tue, 9 Jun 2009 07:26:11 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain> <20090609021551.GG4455@prithivi.gnumonks.org>
In-Reply-To: <20090609021551.GG4455@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906090726.14187.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Harald Welte wrote:
> On Mon, Jun 08, 2009 at 11:35:12AM -0700, Linus Torvalds wrote:
> > Hmm. This all really should be just
> > 
> > 	static int check_est_cpu(unsigned int cpuid)
> > 	{
> > 		struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
> > 		return cpu_has(cpu, X86_FEATURE_EST);
> > 	}
> > 
> > I suspect, with no vendor tests. That's the whole _point_ of CPU features, 
> > after all.
> 
> That's what I was thinking, too.  If there was no such vendor test, it would
> have worked ever since the code was written (the C7 is by far not a new
> component, it's around for years).
> 
> > If some vendor claims EST but doesn't actually support the EST interfaces, 
> > we should just have fixups to clear the bit in the per-vendor cpuinfo 
> > code, not in some random driver.
> 
> agreed.
> 
> > The only thing that makes me nervous about this is how close to 2.6.30 we 
> > are. I'd be happier if this was resolved by doing this as a patch 
> > post-2.6.30, and then adding 'stable@kernel.org' as a Cc: tag, and 
> > backporting it to 2.6.30.1 if no problems appear. 
> > 
> > It's not like this is a regression, I think.
> > 
> > Does that sound like a reasonable plan?
> 
> Sounds fine with me. But what I would definitely suggest merging before 2.6.30
> is the marking e_powersaver EXPERIMENTAL + DANGEROUS patch.
>

As posted somewhere in this thread,
the acpi-cpufreq controller appears to work on my machine in initial tests.

A few tests on only one machine is not much to go on and it
isn't enough to call it "tested" but is forward progress. 

I was only risking my "throw-away" machine yesterday, will see what
happens on the "good" one today (the HP-2133).

@H.W. - are you running any of these changes on your HP-2133?

Mike
> Regards,


