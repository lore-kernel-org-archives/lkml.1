Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZCTBUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZCTBUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZCTBUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:20:22 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:35323 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753043AbZCTBUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:20:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JgwsLGjeN4TNTltEHinZZRsuWxpivkdFo8OAxOT9LymTESRRaQ9NXs9jBhFwpMGVAM7mdt2PDJJo7HWiYU1D7u+Q5ZA4cjxKklDvAW/2Ee5QzdJFY8JKwLHwdCYQ/bpY;
Date: Thu, 19 Mar 2009 18:20:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Yu Zhao <yu.zhao@intel.com>, linux-pci@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 1/8] PCI: initialize and release SR-IOV capability
Message-ID: <20090319182016.33a9a1f2@hobbes.lan>
In-Reply-To: <20090319195312.GC14127@parisc-linux.org>
References: <1236756349-18892-1-git-send-email-yu.zhao@intel.com>
	<1236756349-18892-2-git-send-email-yu.zhao@intel.com>
	<20090319195312.GC14127@parisc-linux.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009 13:53:12 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Mar 11, 2009 at 03:25:42PM +0800, Yu Zhao wrote:
> > +config PCI_IOV
> > +	bool "PCI IOV support"
> > +	depends on PCI
> > +	help
> > +	  PCI-SIG I/O Virtualization (IOV) Specifications support.
> > +	  Single Root IOV: allows the creation of virtual PCI
> > devices
> > +	  that share the physical resources from a real device.
> > +
> > +	  When in doubt, say N.
> 
> It's certainly shorter than my text, which is nice.  But I think it
> still has too much spec-ese and not enough explanation.  How about:
> 
> 	help
> 	  I/O Virtualization is a PCI feature supported by some
> devices which allows them to create virtual devices which share their
> 	  physical resources.
> 
> 	  If unsure, say N.
> 
> > +	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> > +		if (pdev->is_physfn)
> > +			break;
> > +	if (list_empty(&dev->bus->devices) || !pdev->is_physfn)
> > +		pdev = NULL;
> 
> This is still wrong.  If the 'break' condition is not hit, pdev is
> pointing to garbage, not to the last pci_dev in the list.
> 
> > @@ -270,6 +278,7 @@ struct pci_dev {
> >  	struct list_head msi_list;
> >  #endif
> >  	struct pci_vpd *vpd;
> > +	struct pci_sriov *sriov;	/* SR-IOV capability
> > related */
> 
> Should be ifdeffed?

Ok Yu, I'm ready to apply this set, can you send an updated one with
the fixes Matthew mentioned?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
