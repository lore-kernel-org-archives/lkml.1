Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbXIJUZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbXIJUZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbXIJUZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:25:47 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:27817 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbXIJUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:25:46 -0400
Date: Mon, 10 Sep 2007 23:25:43 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Paul Mackerras <paulus@samba.org>, akpm@osdl.org, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [RFC][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070910202543.GS4374@rhun.haifa.ibm.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911174231.GC24627@askeshav-devel.jf.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 10:42:31AM -0700, Keshavamurthy, Anil S wrote:

> Yes, I agree that pci_dev->sysdata can;t be removed. Even we (IOMMU)
> were dependent on this field but somehow this field is being
> overwritten to point to pci_bus's->sysdata and hence IOMMU was
> failing. Earlier it was overwritten to NULL and hence we were not
> failing but now it is overwritten to non-NULL and hence we fail.

Do you know which commit caused that change?

> My therory is that we don;t need to copy pci_bus's->sysdata to 
> pci_dev's->sysdata. Below patch solves my problem.
> Any objection to below patch?

I will give it a spin to verify it works for me, but in general I am
wary of making such changes unless we can verify (read: audit) that
they have no adverse side effects *on all architectures*.

Cheers,
Muli

