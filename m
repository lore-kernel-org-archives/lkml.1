Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXDWWuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXDWWuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbXDWWuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:50:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:45675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbXDWWuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:50:11 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 00/25] xen: Xen implementation for paravirt_ops
Date: Tue, 24 Apr 2007 00:50:06 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
References: <20070423215638.563901986@goop.org>
In-Reply-To: <20070423215638.563901986@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704240050.06615.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 23:56:38 Jeremy Fitzhardinge wrote:
> Hi Andi,
> 
> It applies to 2.6.21-rc7 + your patches + the last batch of pv_ops
> patches 

I got most of those except for the broken sched_clock change.

> I posted. 

How much testing outside Jeremylabs has it gotten? Some beta
testing before merging would be good, otherwise we'll just have
a flood of fixes shortly when it is exposed to users.

> This patch generally restricts itself to Xen-specific parts of the tree,
> though it does make a few small changes elsewhere.

The general problem is that it is much more than just an architecture update.

> These patches include:
>  - some helper routines for allocating address space and walking pagetables

Needs review from mm people.

>  - Xen interface header files
>  - Core Xen implementation
>  - Efficient late-pinning/early-unpinning pagetable handling 

The number of new paravirt hooks makes me thing of renaming it to
everything_ops @|

>  - Virtualized time, including stolen time

Can you let it be reviewed by the time people? (Thomas, Ingo, John, Roman etc.)

>  - SMP support
>  - Preemption support
>  - Batched pagetable updates

>  - Xen console, based on hvc console
>  - Xenbus

That one would need to be reviewed first. It's so much code that I can't
do it all myself.

>  - Netfront, the paravirtualized network device

That one should go through the network device maintainer/netdev.

>  - Blockfront, the paravirtualized block device

And that needs a block device review and whoever maintains that (Jens?) 

-Andi
