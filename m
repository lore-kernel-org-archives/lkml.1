Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZLDQVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZLDQVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbZLDQVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:21:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58166 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbZLDQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:21:33 -0500
Date: Fri, 4 Dec 2009 16:21:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH 10/12] PCI / ACPI PM: Platform support for PCI PME
	wake-up (rev. 4)
Message-ID: <20091204162107.GA13371@srcf.ucam.org>
References: <200911160047.46299.rjw@sisk.pl> <200911291632.44763.rjw@sisk.pl> <200911291642.20172.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911291642.20172.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 04:42:20PM +0100, Rafael J. Wysocki wrote:

> +	if (event == ACPI_NOTIFY_DEVICE_WAKE) {
> +		if (nb->dev->wakeup.run_wake_count > 0) {
> +			if (nb->pci_bus)
> +				pci_pme_wakeup_bus(nb->pci_bus);
> +			if (nb->pci_dev)
> +				pci_pme_wakeup(nb->pci_dev);

We may receive wakeup events on devices that aren't PME capable, which 
is the case for uhci on my test box. In that case we probably want to 
wake them up unconditionally.

+                       if (nb->pci_dev) {
+                               if (nb->pci_dev->pm_cap)
+                                       pci_pme_wakeup(nb->pci_dev);
+                               else
+                                       pm_request_resume(&nb->pci_dev->dev);

seems to work, though possibly we should assume that the firmware knows 
best and always schedule a wake in respose to a resume request?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
