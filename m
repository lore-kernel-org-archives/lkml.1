Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZIMWZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZIMWZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 18:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZIMWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 18:25:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35177 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZIMWZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 18:25:15 -0400
Date: Sun, 13 Sep 2009 23:25:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Shaohua Li <shaohua.li@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/4] PCI / ACPI PM: Platform support for PCI PME
	wake-up
Message-ID: <20090913222505.GC31175@srcf.ucam.org>
References: <200909132320.05077.rjw@sisk.pl> <200909132324.03340.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909132324.03340.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 11:24:03PM +0200, Rafael J. Wysocki wrote:
> +	} else if (!dev->wakeup.flags.run_wake) {
> +		acpi_set_gpe_type(dev->wakeup.gpe_device,
> +					dev->wakeup.gpe_number,
> +					ACPI_GPE_TYPE_WAKE);

Is this going to work for cases where we have multiple devices attached 
to the same GPE? The common one is EHCI, where both EHCI HCDs will be 
one a single GPE. If we wake one, that'll then disable the GPE for the 
other. Further wakeup events will then be lost.

> +	if (device->wakeup.flags.valid)
> +		acpi_install_notify_handler(device->handle, ACPI_SYSTEM_NOTIFY,
> +						pci_acpi_device_wakeup,
> +						&dev->dev);
> +

I think this will fail for the root bridge if acpiphp has already 
grabbed it to check for hotplug events.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
