Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbYDPUES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbYDPUES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYDPUEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:04:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbYDPUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:03:59 -0400
Date: Wed, 16 Apr 2008 13:03:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Chiang <achiang@hp.com>
Cc: benh@kernel.crashing.org, pbadari@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
Message-Id: <20080416130343.a82702f0.akpm@linux-foundation.org>
In-Reply-To: <20080416171127.GA18290@ldl.fc.hp.com>
References: <1207331616.5916.15.camel@badari-desktop>
	<20080404180518.GA12642@ldl.fc.hp.com>
	<1207340371.5916.23.camel@badari-desktop>
	<20080404224227.GA31436@ldl.fc.hp.com>
	<1207352128.5916.26.camel@badari-desktop>
	<20080407234255.GA22514@ldl.fc.hp.com>
	<20080416031712.GB3333@ldl.fc.hp.com>
	<1208331916.6958.270.camel@pasglop>
	<20080416171127.GA18290@ldl.fc.hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 11:11:27 -0600
Alex Chiang <achiang@hp.com> wrote:

> Hi Ben,
> 
> * Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> > 
> > On Tue, 2008-04-15 at 21:17 -0600, Alex Chiang wrote:
> > > 
> > > Could you take a look at this patch and tell me what I'm doing
> > > wrong?
> > 
> > Hrm, I'll have a look but I'd need some context first... This is to fix
> > a problem introduced by another serie of patches ? Can you give me some
> > pointers here ?
> 
> Thanks for taking a look. The patch series that got accepted into
> -mm is here:
> 
> 	http://lkml.org/lkml/2008/3/25/228
> 
> There have been several fixes on top of that series. I'm not sure
> what the canonical way to refer to -mm patches is, but if you
> navigate to this URL:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/patch-list
> 
> You'll also need to apply:
> 
> 	pci-hotplug-introduce-pci_slot-fix.patch
> 	pci-hotplug-introduce-pci_slot-fix-fix.patch
> 	pci-hotplug-introduce-pci_slot-fix-2.patch
> 	pci-hotplug-introduce-pci_slot-fix-99.patch
> 	pci-hotplug-introduce-pci_slot-fix-3.patch
> 	pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
> 	drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch

I folded it all down to two patches.  Unfortunately they don't apply very
well to mainline:

1 out of 4 hunks FAILED -- saving rejects to file drivers/pci/hotplug/acpiphp_core.c.rej
2 out of 3 hunks FAILED -- saving rejects to file drivers/pci/hotplug/acpiphp_ibm.c.rej
1 out of 6 hunks FAILED -- saving rejects to file drivers/pci/hotplug/pciehp_core.c.rej
1 out of 4 hunks FAILED -- saving rejects to file drivers/pci/hotplug/shpchp_core.c.rej
1 out of 5 hunks FAILED -- saving rejects to file include/linux/pci.h.rej

I guess because I reworked everything to fit on Greg's tree(s).

fwiw, http://userweb.kernel.org/~akpm/bh.gz (agains -rc9) contains all of
-mm up to and including pci-hotplug-acpi-pci-slot-detection-driver.patch
and is suitable for review/repair/etc.

