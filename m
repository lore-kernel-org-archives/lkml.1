Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0CCIYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:24:51 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59215 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab0CCIYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:24:50 -0500
Date: Wed, 3 Mar 2010 09:24:43 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Call flush_dcache_page around PIO data transfers in
 libata-aff.c
Message-ID: <20100303082443.GA11944@Chamillionaire.breakpoint.cc>
References: <20100129160150.22571.28609.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100129160150.22571.28609.stgit@pc1117.cambridge.arm.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/ata/libata-sff.c |    6 ++++++
> 1 files changed, 6 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
>index 741065c..3d3c854 100644
>--- a/drivers/ata/libata-sff.c
>+++ b/drivers/ata/libata-sff.c
>@@ -893,6 +896,9 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
> 				       do_write);
> 	}
> 
>+	if (!do_write)
>+		flush_dcache_page(page);
>+
> 	qc->curbytes += qc->sect_size;
> 	qc->cursg_ofs += qc->sect_size;
 
That part got merged and it leads to a BUG if CONFIG_DEBUG_VM is
enabled. My mips box and arm use page_mapping() in flush_dcache_page()
which has VM_BUG_ON(PageSlab(page)) in it.

Any comments on that?

Sebastian
