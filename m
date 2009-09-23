Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZIWJM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZIWJM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZIWJM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:12:26 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48848 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbZIWJMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:12:25 -0400
Date: Wed, 23 Sep 2009 10:13:23 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Kevin D. Kissell" <kevink@paralogos.com>
Cc: Julia Lawall <julia@diku.dk>, dmitri.vorobiev@gmail.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/mips: remove duplicate structure field
	initialization
Message-ID: <20090923091323.GC5457@linux-mips.org>
References: <Pine.LNX.4.64.0909211708200.8549@pc-004.diku.dk> <20090921192520.GB17310@linux-mips.org> <4AB7E0D1.10506@paralogos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB7E0D1.10506@paralogos.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 01:23:45PM -0700, Kevin D. Kissell wrote:

> I'm still on the mailing list, and had seen this going by.  I'm not sure  
> where that second .flags declaration got added.  Way, way back when I  
> was pretty much the only maintainer of the file, irq_ipi.flags was  
> explicitly  initialized to IRQF_DISABLED by an actual assignment  
> statement in setp_cross_vpe_interrupts(), and the per-CPUness was  
> handled by an "irq_desc[cpu_ipi_irq].status |= IRQ_PER_CPU".  My guess  
> is that first someone (maybe me) migrated the IRQF_DISABLED assignment  
> into the declaration of the struct, and that later someone found the  
> IRQ_PER_CPU thing bogus or deprecated and converted it into a second  
> .flags line in the struct declaration, missing the fact that there was  
> already one there.
>
> In any case, I'm willing to sign off on Julia's patch.  It's certainly  
> more important that the IRQ be PER_CPU than initially DISABLED, but  
> during the time when SMTC was seeing its heaviest testing at MIPS, both  
> attributes were true.

I've reverted my patch and merged Julia's original patch with an extra
comment added.

Thanks Julia,

   Ralf
