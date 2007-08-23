Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbXHWBQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbXHWBQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 21:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXHWBQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 21:16:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36357 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960AbXHWBQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 21:16:09 -0400
Date: Wed, 22 Aug 2007 18:16:06 -0700
From: Jeremy Higdon <jeremy@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-ia64@vger.kernel.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Message-ID: <20070823011606.GL89849@sgi.com>
References: <20070822172541.GA8058@bingen.suse.de> <46CC811C.9010600@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2D39@scsmsx411.amr.corp.intel.com> <46CCB79E.7070109@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2F6A@scsmsx411.amr.corp.intel.com> <20070822231111.GD89849@sgi.com> <617E1C2C70743745A92448908E030B2A023B2FD5@scsmsx411.amr.corp.intel.com> <20070822235445.GG89849@sgi.com> <617E1C2C70743745A92448908E030B2A023B307D@scsmsx411.amr.corp.intel.com> <20070823010948.GK89849@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823010948.GK89849@sgi.com>
User-Agent: Mutt/1.4.1i
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 06:09:48PM -0700, Jeremy Higdon wrote:
> > I traced the pci_alloc_consistent calls from PrimeIocFifos on my
> > system.  There are two calls for each ioc.  The first is for
> > 266368 bytes, the second for 16320 bytes.
> > 
> > I wonder why Kamalesh's system wants the slightly different
> > amount (263200 bytes) from what my system asks for?
> > 
> > It also looks to be a little unfriendly to swiotlb to ask for
> > more than 256K at a time (see IO_TLB_SEGSIZE) in swiotlb.c
> > 
> > -Tony
> 
> I believe those would vary a bit based on the exact firmware
> rev and perhaps nvram settings.  Also driver settings, but
> those are presumably the same.

> ioc0: LSI53C1030 C0: Capabilities={Initiator}                 | ioc0: LSI53C1030 B2: Capabilities={Initiator}
> scsi0 : ioc0: LSI53C1030 C0, FwRev=01032821h, Ports=1, MaxQ=2 | scsi0 : ioc0: LSI53C1030 B2, FwRev=01030a00h, Ports=1, MaxQ=2
> ioc1: LSI53C1030 C0: Capabilities={Initiator}                 | ioc1: LSI53C1030 B2: Capabilities={Initiator}
> scsi1 : ioc1: LSI53C1030 C0, FwRev=01032821h, Ports=1, MaxQ=2 | scsi1 : ioc1: LSI53C1030 B2, FwRev=01030a00h, Ports=1, MaxQ=2
> ioc2: LSI53C1030 C0: Capabilities={Initiator}                 | ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) ->


Actually, you can see that you have a different chip rev level and different
firmware revs, so that's probably why the requested sizes are a little
different.

Compare /proc/mpt/ioc0/info if you're curious.  There's probably a small
difference.

jeremy
