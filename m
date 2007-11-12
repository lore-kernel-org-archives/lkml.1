Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXKLJye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXKLJye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 04:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbXKLJy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 04:54:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:10293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407AbXKLJy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 04:54:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,404,1188802800"; 
   d="scan'208";a="201529488"
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1194860728.7179.6.camel@twins>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>
	 <1194860728.7179.6.camel@twins>
Content-Type: text/plain; charset=utf-8
Date: Mon, 12 Nov 2007 17:51:52 +0800
Message-Id: <1194861112.20251.124.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-12 at 10:45 +0100, Peter Zijlstra wrote:
> On Mon, 2007-11-12 at 10:14 +0800, Zhang, Yanmin wrote:
> 
> > > Subject: mm: speed up writeback ramp-up on clean systems
> >
> > I tested kernel 2.6.23, 2,6,24-rc2, 2.6.24-rc2_peter(2.6.24-rc2+this patch).
> > 
> > 1) Compare among first/second/following running
> > 2.6.23: second run of iozone will get about 28% improvement than first run.
> > 	Following run is very stable like 2nd run.
> > 2.6.24-rc2: second run of iozone will get about 170% improvement than first run. 3rd run
> > 	will get about 80% improvement than 2nd. Following run is very stable like 3rd run.
> > 2.6.24-rc2_peter: second run of iozone will get about 14% improvement than first run. Following
> > 	run is mostly stable like 2nd run.
> > So the new patch really improves the first run result. Comparing wiht 2.6.24-rc2, 2.6.24-rc2_peter
> > has 330% improvement on the first run.
> > 
> > 2) Compare among different kernels(based on the stable highest result):
> > 2.6.24-rc2 has about 50% regression than 2.6.23.
> > 2.6.24-rc2_peter has the same result like 2.6.24-rc2.
> >
> > From this point of view, above patch has no improvement. :)
> 
> Drad, still good test results though.
> 
> Could you describe you system in detail, that is, you have 8GB of memory
> and 8 cpus (2*quad?).
Yes.

>  How many disks does it have
1 machine uses 1 AHCI SATA. Other machines use hardware raid0.

>  and are those
> aggregated using md or dm?
No.

>  What filesystem do you use?
Ext3.

I got the regression on my a couple of machines. Pls. try command
#iozone -i 0 -r 4k -s 512m

-yanmin
