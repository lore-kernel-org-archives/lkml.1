Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbZCSTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbZCSTxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZCSTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:53:32 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56448 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZCSTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:53:31 -0400
Date: Thu, 19 Mar 2009 13:53:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 1/8] PCI: initialize and release SR-IOV capability
Message-ID: <20090319195312.GC14127@parisc-linux.org>
References: <1236756349-18892-1-git-send-email-yu.zhao@intel.com> <1236756349-18892-2-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236756349-18892-2-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 03:25:42PM +0800, Yu Zhao wrote:
> +config PCI_IOV
> +	bool "PCI IOV support"
> +	depends on PCI
> +	help
> +	  PCI-SIG I/O Virtualization (IOV) Specifications support.
> +	  Single Root IOV: allows the creation of virtual PCI devices
> +	  that share the physical resources from a real device.
> +
> +	  When in doubt, say N.

It's certainly shorter than my text, which is nice.  But I think it
still has too much spec-ese and not enough explanation.  How about:

	help
	  I/O Virtualization is a PCI feature supported by some devices
	  which allows them to create virtual devices which share their
	  physical resources.

	  If unsure, say N.

> +	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> +		if (pdev->is_physfn)
> +			break;
> +	if (list_empty(&dev->bus->devices) || !pdev->is_physfn)
> +		pdev = NULL;

This is still wrong.  If the 'break' condition is not hit, pdev is
pointing to garbage, not to the last pci_dev in the list.

> @@ -270,6 +278,7 @@ struct pci_dev {
>  	struct list_head msi_list;
>  #endif
>  	struct pci_vpd *vpd;
> +	struct pci_sriov *sriov;	/* SR-IOV capability related */

Should be ifdeffed?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
