Return-Path: <linux-kernel-owner+w=401wt.eu-S1763506AbXIKU74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763506AbXIKU74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934028AbXIKU7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:59:42 -0400
Received: from ozlabs.org ([203.10.76.45]:54869 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934019AbXIKU7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:59:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
Date: Wed, 12 Sep 2007 05:48:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: akpm@osdl.org, Greg KH <greg@kroah.com>, muli@il.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [patch][Intel-IOMMU] Fix for IOMMU early crash
In-Reply-To: <20070912192854.GA32610@askeshav-devel.jf.intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com>
	<18148.12140.21118.252581@cargo.ozlabs.ibm.com>
	<20070911174231.GC24627@askeshav-devel.jf.intel.com>
	<20070912192854.GA32610@askeshav-devel.jf.intel.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keshavamurthy, Anil S writes:

> Subject: Fix IOMMU early crash
> 
> This patch avoids copying pci_bus's->sysdata to
> pci_dev's->sysdata as one can easily obtain
> the same through pci_dev->bus->sysdata.

At the moment this will cause ppc64 to crash, since we rely on
pci_dev->sysdata pointing to some node in the firmware device tree,
either the device's node or the node for a parent bus.

We could change the ppc64 code to use pci_dev->bus->sysdata in the
case when pci_dev->sysdata is NULL, which would fix the problem.  I
think that change should be incorporated as part of this patch so that
we don't break git bisection.

In other words I don't want to see this patch applied as it stands.

Paul.
