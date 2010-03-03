Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab0CCL1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:27:05 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37335 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab0CCL1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:27:01 -0500
Subject: Re: [PATCH] Call flush_dcache_page around PIO data transfers in
 libata-aff.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <20100303082443.GA11944@Chamillionaire.breakpoint.cc>
References: <20100129160150.22571.28609.stgit@pc1117.cambridge.arm.com>
	 <20100303082443.GA11944@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 03 Mar 2010 11:18:25 +0000
Message-ID: <1267615105.15589.68.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2010 11:18:25.0891 (UTC) FILETIME=[3E3ACB30:01CABAC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 08:24 +0000, Sebastian Andrzej Siewior wrote:
> > drivers/ata/libata-sff.c |    6 ++++++
> > 1 files changed, 6 insertions(+), 0 deletions(-)
> >
> >diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> >index 741065c..3d3c854 100644
> >--- a/drivers/ata/libata-sff.c
> >+++ b/drivers/ata/libata-sff.c
> >@@ -893,6 +896,9 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
> >                                      do_write);
> >       }
> >
> >+      if (!do_write)
> >+              flush_dcache_page(page);
> >+
> >       qc->curbytes += qc->sect_size;
> >       qc->cursg_ofs += qc->sect_size;
> 
> That part got merged and it leads to a BUG if CONFIG_DEBUG_VM is
> enabled. My mips box and arm use page_mapping() in flush_dcache_page()
> which has VM_BUG_ON(PageSlab(page)) in it.
> 
> Any comments on that?

There is a long thread on USB HCD and cache coherency on ARM which I
started pretty much at the same time with the libata-sff change. I need
to do some testing but in the view of the discussions in the other
thread, we may not need this patch at all:

http://thread.gmane.org/gmane.linux.usb.general/27072

Basically, the meaning of PG_arch_1 should be page clean rather than
page dirty.

-- 
Catalin

