Return-Path: <linux-kernel-owner+w=401wt.eu-S1423054AbXDXT1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423054AbXDXT1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423055AbXDXT1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:27:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:47562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423054AbXDXT1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:27:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ashok Raj <ashok.raj@intel.com>
Subject: Re: [Intel IOMMU][patch 1/8] ACPI support for Intel Virtualization Technology for Directed I/O
Date: Tue, 24 Apr 2007 20:50:48 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070424060259.426374000@intel.com> <20070424061037.361212000@intel.com>
In-Reply-To: <20070424061037.361212000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704242050.49253.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +config DMAR
> +	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
> +	depends on PCI_MSI && ACPI && EXPERIMENTAL
> +	help
> +	  Support DMA Remapping Devices. The devices are reported via
> +	  ACPI tables and includes pci device scope under each DMA
> +	  remapping device.

The description needs to explain what a dma remapping device is.


And some high level comment here what this file does.

> +
> +LIST_HEAD(dmar_drhd_units);
> +LIST_HEAD(dmar_rmrr_units);

Comment describing what lock protects those lists?
In fact there seems to be no locking. What about hotplug?

>
> +
> +	dmar = (struct acpi_table_dmar *)table;
> +	if (!dmar) {
> +		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
> +		return -ENODEV;
> +	}

Shouldn't that be wherever the table is mapped. Or is it not needed?

-Andi
