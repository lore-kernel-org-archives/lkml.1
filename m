Return-Path: <linux-kernel-owner+w=401wt.eu-S965815AbXDCRY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815AbXDCRY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965920AbXDCRYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:24:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:19828 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965815AbXDCRYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:24:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,366,1170662400"; 
   d="scan'208"; a="207507384:sNHT3162275081"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] msi: Immediately mask and unmask msi-x irqs.
Date: Tue, 3 Apr 2007 10:24:40 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6E01043C7D@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <m1lkh9dhvm.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] msi: Immediately mask and unmask msi-x irqs.
Thread-Index: Acd1w5eVskTHjDA9QHaxU+uLUiiCkgAUSipA
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <linux-kernel@vger.kernel.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 03 Apr 2007 17:24:41.0251 (UTC) FILETIME=[F6A0DF30:01C77614]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mitch Williams <mitch.a.williams@intel.com>

>This is a simplified and actually more comprehensive form of a bug
>fix from Mitch Williams <mitch.a.williams@intel.com>.
[snip]
>Then if people do have a kernel message stating "No irq for vector" we
>will know it is yet another novel cause that needs a complete new
>investigation.
>
>So here is a one liner that will hopefully be a part of 2.6.21.
>
>Cc: Mitch Williams <mitch.a.williams@intel.com>
>Cc: Greg KH <greg@kroah.com>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>---
> drivers/pci/msi.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>index ad33e01..435c195 100644
>--- a/drivers/pci/msi.c
>+++ b/drivers/pci/msi.c
>@@ -94,6 +94,7 @@ static void msi_set_mask_bit(unsigned int 
>irq, int flag)
> 		int offset = entry->msi_attrib.entry_nr * 
>PCI_MSIX_ENTRY_SIZE +
> 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> 		writel(flag, entry->mask_base + offset);
>+		readl(entry->mask_base + offset);
> 		break;
> 	}
> 	default:
>-- 
>1.5.0.4
>
