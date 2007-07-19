Return-Path: <linux-kernel-owner+w=401wt.eu-S1761368AbXGSK4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368AbXGSK4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXGSK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:56:11 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38152 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752992AbXGSK4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:56:09 -0400
Date: Thu, 19 Jul 2007 12:55:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, kiran@scalex86.org,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [33/58] x86_64: Avoid too many remote cpu references
	due to /proc/stat
Message-ID: <20070719105532.GS3801@stusta.de>
References: <200707191154.642492000@suse.de> <20070719095519.10E4C14E11@wotan.suse.de> <20070719102149.GA7322@infradead.org> <200707191241.28383.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707191241.28383.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 12:41:28PM +0200, Andi Kleen wrote:
> On Thursday 19 July 2007 12:21:49 Christoph Hellwig wrote:
> > On Thu, Jul 19, 2007 at 11:55:19AM +0200, Andi Kleen wrote:
> > > 
> > > From: Ravikiran G Thirumalai <kiran@scalex86.org>
> > > Too many remote cpu references due to /proc/stat.
> > > 
> > > On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
> > > On every call to kstat_irqs, the process brings in per-cpu data from all
> > > online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
> > > results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
> > > /proc/stat is parsed by common commands like top, who etc, causing
> > > lots of cacheline transfers
> > > 
> > > This statistic seems useless. Other 'big iron' arches disable this.
> > > Can we disable computing/reporting this statistic?  This piece of
> > > statistic is not human readable on x86_64 anymore,
> > > 
> > > If not, can we optimize computing this statistic so as to avoid
> > > too many remote references (patch to follow)
> > 
> > If we disable this on x86_64 we should just kill it completely for consistency.
> 
> I guess it's fine on UP only architectures.  I will change it to !CONFIG_SMP
> unless someone complains.

Making it depending on the kernel configuration will only cause 
surprises for users. And if you really need the data you can get 
it from /proc/interrupts.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

