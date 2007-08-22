Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbXHVXLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbXHVXLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762710AbXHVXLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:11:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60137 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762291AbXHVXLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:11:15 -0400
Date: Wed, 22 Aug 2007 16:11:11 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-ia64@vger.kernel.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Message-ID: <20070822231111.GD89849@sgi.com>
References: <46CC48FD.4000607@linux.vnet.ibm.com> <20070822091959.aa38fd3e.akpm@linux-foundation.org> <20070822172541.GA8058@bingen.suse.de> <46CC811C.9010600@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2D39@scsmsx411.amr.corp.intel.com> <46CCB79E.7070109@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2F6A@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A023B2F6A@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 03:56:57PM -0700, Luck, Tony wrote:
> [ 20.903201] [<a0000001003aaa50>] swiotlb_full+0x50/0x120
> [ 20.903202] sp=e00000014322fac0 bsp=e000000143229120
> [ 20.916902] [<a0000001003aac40>] swiotlb_map_single+0x120/0x1c0
> [ 20.916904] sp=e00000014322fac0 bsp=e0000001432290d8
> [ 20.931215] [<a0000001003ab630>] swiotlb_alloc_coherent+0x150/0x240
> [ 20.931217] sp=e00000014322fac0 bsp=e000000143229090
> [ 20.945923] [<a000000100550860>] PrimeIocFifos+0x4c0/0xb20
> [ 20.945925] sp=e00000014322fac0 bsp=e000000143229010
> [ 20.959812] [<a000000100556a80>] mpt_do_ioc_recovery+0xd60/0x28e0
> [ 20.959814] sp=e00000014322faf0 bsp=e000000143228f30
> [ 20.974310] [<a00000010055c8f0>] mpt_attach+0x830/0x20e0
> 
> 
> Hmmm!  So you were in the mpt/fusion driver when you ran out
> of SWIOTLB space.  That's an area where we both have the same
> hardware ... and since it booted for me, it means that the
> driver isn't totally broken.
> 
> I'm totally ignorant of what goes on inside this driver though.
> You have more "ioc's" than I do.  I only see messages from mpt
> bringing up ioc0 & ioc1.  Your boot_log also has ioc2 (which is
> where you crash).  Here's the sdiff(1) output comparing the MPT
> part of your boot log with my successful boot of the same kernel
> and config (your log is the one on the left).  Maybe some MPT/Fusion
> expert can spot something important in this bit?

The more ioc's you have, the more space you will use.

jeremy
