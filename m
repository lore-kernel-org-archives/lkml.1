Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbZLDVOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbZLDVOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbZLDVOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:14:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33708 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbZLDVOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:14:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH 10/12] PCI / ACPI PM: Platform support for PCI PME wake-up (rev. 4)
Date: Fri, 4 Dec 2009 22:15:03 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl> <200911291642.20172.rjw@sisk.pl> <20091204162107.GA13371@srcf.ucam.org>
In-Reply-To: <20091204162107.GA13371@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912042215.03776.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009, Matthew Garrett wrote:
> On Sun, Nov 29, 2009 at 04:42:20PM +0100, Rafael J. Wysocki wrote:
> 
> > +	if (event == ACPI_NOTIFY_DEVICE_WAKE) {
> > +		if (nb->dev->wakeup.run_wake_count > 0) {
> > +			if (nb->pci_bus)
> > +				pci_pme_wakeup_bus(nb->pci_bus);
> > +			if (nb->pci_dev)
> > +				pci_pme_wakeup(nb->pci_dev);
> 
> We may receive wakeup events on devices that aren't PME capable, which 
> is the case for uhci on my test box. In that case we probably want to 
> wake them up unconditionally.
> 
> +                       if (nb->pci_dev) {
> +                               if (nb->pci_dev->pm_cap)
> +                                       pci_pme_wakeup(nb->pci_dev);
> +                               else
> +                                       pm_request_resume(&nb->pci_dev->dev);
> 
> seems to work, though possibly we should assume that the firmware knows 
> best and always schedule a wake in respose to a resume request?

I  think we can simply do:

+        if (nb->pci_dev) {
+                pci_pme_wakeup(nb->pci_dev);
+                pm_request_resume(&nb->pci_dev->dev);
+        }

If the pci_pme_wakeup() spawns a resume request, the other call will just
return.

Thanks,
Rafael
