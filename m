Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbXGEWiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbXGEWiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759819AbXGEWiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:38:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758413AbXGEWiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:38:02 -0400
Date: Thu, 5 Jul 2007 15:37:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk,
       linux-scsi@vger.kernel.org
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Message-Id: <20070705153718.3aaf8ea5.akpm@linux-foundation.org>
In-Reply-To: <20070705153334.08402809.akpm@linux-foundation.org>
References: <20070705194909.337398431@intel.com>
	<20070705130530.5873afeb.kristen.c.accardi@intel.com>
	<20070705153334.08402809.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 15:33:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 5 Jul 2007 13:05:30 -0700
> Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> 
> > +	ATA_DFLAG_IPM		= (1 << 6), /* device supports interface PM */
> >  	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
> 
> I had to bump this to (1<<7), so we've run out.

err, no, we've more than run out because you AN patches took the last one.


I guess we can bump ATA_DFLAG_CFG_MASK up to 12, like this?

--- a/include/linux/libata.h~ata-ahci-alpm-enable-link-power-management-for-ata-drivers
+++ a/include/linux/libata.h
@@ -140,11 +140,12 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* device supports Async notification */
-	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
+	ATA_DFLAG_IPM		= (1 << 8), /* device supports interface PM */
+	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
-	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SPUNDOWN	= (1 << 10), /* XXX: for spindown_compat */
+	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),


