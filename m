Return-Path: <linux-kernel-owner+w=401wt.eu-S1423102AbXDXVAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423102AbXDXVAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423114AbXDXVAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:00:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50019
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423102AbXDXVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:00:48 -0400
Date: Tue, 24 Apr 2007 14:00:55 -0700 (PDT)
Message-Id: <20070424.140055.42775489.davem@davemloft.net>
To: ak@suse.de
Cc: ashok.raj@intel.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, anil.s.keshavamurthy@intel.com,
       arjan@linux.intel.com, shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 4/8] Supporting Zero Length Reads in Intel
 IOMMU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200704242128.12057.ak@suse.de>
References: <20070424060259.426374000@intel.com>
	<20070424061037.821838000@intel.com>
	<200704242128.12057.ak@suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Tue, 24 Apr 2007 21:28:11 +0200

> On Tuesday 24 April 2007 08:03:03 Ashok Raj wrote:
> > PCI specs permit zero length reads (ZLR) even if the mapping for that region 
> > is write only. Support for this feature is indicated by the presence of a bit 
> > in the DMAR capability. If a particular DMAR does not support this capability
> > we map write-only regions as read-write.
> > 
> > This option can also provides a workaround for some drivers that request
> > a write-only mapping when they really should request a read-write.
> > (We ran into one such case in eepro100.c in handling rx_ring_dma)
> 
> Better just fix the drivers instead of adding such hacks

I totally agree.

It is a feature when we have a device which can enforce such
permissions correctly and thus trap such bad uses.  If you
paper around it, these things will never get fixed.
