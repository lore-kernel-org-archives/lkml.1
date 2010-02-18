Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab0BRT5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:57:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025Ab0BRT5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:57:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 2/8] PCI PM: PCIe PME root port service driver (rev. 5)
Date: Thu, 18 Feb 2010 20:57:52 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
References: <201002172335.47703.rjw@sisk.pl> <201002172339.08865.rjw@sisk.pl> <4B7CBD37.9000706@jp.fujitsu.com>
In-Reply-To: <4B7CBD37.9000706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002182057.53002.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 February 2010, Kenji Kaneshige wrote:
> Hi,
> 
> I'm sorry for the delayed comments.
> 
> > +
> > +/**
> > + * pcie_pme_interrupt_enable - Enable/disable PCIe PME interrupt generation.
> > + * @dev: PCIe root port or event collector.
> > + * @enable: Enable or disable the interrupt.
> > + */
> > +static void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
> > +{
> > +	int rtctl_pos;
> > +	u16 rtctl;
> > +
> > +	rtctl_pos = pci_find_capability(dev, PCI_CAP_ID_EXP) + PCI_EXP_RTCTL;
> 
> How about
> 
> 	rtctl_pos = pci_pcie_cap(dev) + PCI_EXP_RTCTL;
> 
> ?
> 
> The pci_pcie_cap() returns PCIe capability offset saved in struct pci_dev.
> By using this, we can avoid redundant search in PCI configuration space.

While I agree with the comment, I'd prefer to change this with a separate
patch, unless the entire patchset misses the merge window.

Rafael
