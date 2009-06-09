Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbZFICU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbZFICU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 22:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZFICUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 22:20:15 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:46496 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZFICUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 22:20:14 -0400
Date: Tue, 9 Jun 2009 10:15:51 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Zick" <lkml@morethan.org>, Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for
	VIA/Centaur CPUs
Message-ID: <20090609021551.GG4455@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090606132847.GB14088@prithivi.gnumonks.org> <200906060846.36303.lkml@morethan.org> <200906060856.15016.lkml@morethan.org> <20090608102754.GP4106@prithivi.gnumonks.org> <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906081128410.6847@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 11:35:12AM -0700, Linus Torvalds wrote:
> Hmm. This all really should be just
> 
> 	static int check_est_cpu(unsigned int cpuid)
> 	{
> 		struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
> 		return cpu_has(cpu, X86_FEATURE_EST);
> 	}
> 
> I suspect, with no vendor tests. That's the whole _point_ of CPU features, 
> after all.

That's what I was thinking, too.  If there was no such vendor test, it would
have worked ever since the code was written (the C7 is by far not a new
component, it's around for years).

> If some vendor claims EST but doesn't actually support the EST interfaces, 
> we should just have fixups to clear the bit in the per-vendor cpuinfo 
> code, not in some random driver.

agreed.

> The only thing that makes me nervous about this is how close to 2.6.30 we 
> are. I'd be happier if this was resolved by doing this as a patch 
> post-2.6.30, and then adding 'stable@kernel.org' as a Cc: tag, and 
> backporting it to 2.6.30.1 if no problems appear. 
> 
> It's not like this is a regression, I think.
> 
> Does that sound like a reasonable plan?

Sounds fine with me. But what I would definitely suggest merging before 2.6.30
is the marking e_powersaver EXPERIMENTAL + DANGEROUS patch.

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
