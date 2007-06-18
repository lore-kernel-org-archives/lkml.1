Return-Path: <linux-kernel-owner+w=401wt.eu-S1764276AbXFRX65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764276AbXFRX65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXFRX6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:58:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:13316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXFRX6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,436,1175497200"; 
   d="scan'208";a="97815927"
Date: Mon, 18 Jun 2007 16:54:34 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070618235434.GB7160@linux-os.sc.intel.com>
References: <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com> <20070605235707.GB16074@tree.beaverton.ibm.com> <20070606013759.GI17143@linux-os.sc.intel.com> <20070606185829.GA26062@tree.beaverton.ibm.com> <20070606193514.GN17143@linux-os.sc.intel.com> <20070606231642.GH13751@tree.beaverton.ibm.com> <20070608005726.GO17143@linux-os.sc.intel.com> <20070618223819.GD9751@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618223819.GD9751@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 03:38:20PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 07, 2007 at 05:57:26PM -0700, Siddha, Suresh B wrote:
> 
> > As you have the failing system, you need to do more detective work and
> > help me out. Can you try this debug patch and send across the dmesg after the
> > bug happens and also can you try different compiler to see if something
> > changes..
> 
> Hrm, I just updated to -rc5.  Interrupts being handled by the IOAPIC
> don't suffer from this problem, but MSI interrupts are still affected.
> I added a few printks to the kernel to figure out what IRQ affinity
> masks were being passed around and saw this:
> 
> [  256.298773] Breaking affinity for irq 4341
> [  256.298774] irq=4341 affinity=2 mask=d
> <call to set_affinity>
> [  256.298787] irq=4341 affinity=d
> <ethernet on irq 4341 stops working>

And just to make sure, at this point, your MSI irq 4341 affinity
(/proc/irq/4341/smp_affinity) still points to '2'?

> I'll keep digging, but at least it appears that the problem has been
> shrunk down to something the MSI code.

thanks,
suresh
