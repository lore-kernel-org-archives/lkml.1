Return-Path: <linux-kernel-owner+w=401wt.eu-S937101AbXGSKmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937101AbXGSKmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXGSKmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:42:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:39093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019AbXGSKmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:42:45 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [33/58] x86_64: Avoid too many remote cpu references due to /proc/stat
Date: Thu, 19 Jul 2007 12:41:28 +0200
User-Agent: KMail/1.9.6
Cc: kiran@scalex86.org, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095519.10E4C14E11@wotan.suse.de> <20070719102149.GA7322@infradead.org>
In-Reply-To: <20070719102149.GA7322@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191241.28383.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 12:21:49 Christoph Hellwig wrote:
> On Thu, Jul 19, 2007 at 11:55:19AM +0200, Andi Kleen wrote:
> > 
> > From: Ravikiran G Thirumalai <kiran@scalex86.org>
> > Too many remote cpu references due to /proc/stat.
> > 
> > On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
> > On every call to kstat_irqs, the process brings in per-cpu data from all
> > online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
> > results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
> > /proc/stat is parsed by common commands like top, who etc, causing
> > lots of cacheline transfers
> > 
> > This statistic seems useless. Other 'big iron' arches disable this.
> > Can we disable computing/reporting this statistic?  This piece of
> > statistic is not human readable on x86_64 anymore,
> > 
> > If not, can we optimize computing this statistic so as to avoid
> > too many remote references (patch to follow)
> 
> If we disable this on x86_64 we should just kill it completely for consistency.

I guess it's fine on UP only architectures.  I will change it to !CONFIG_SMP
unless someone complains.

-Andi

