Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbXFSR4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbXFSR4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758585AbXFSRz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:55:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34431 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbXFSRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:55:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
References: <20070605200954.GE12782@tree.beaverton.ibm.com>
	<20070605211451.GG17143@linux-os.sc.intel.com>
	<20070605235707.GB16074@tree.beaverton.ibm.com>
	<20070606013759.GI17143@linux-os.sc.intel.com>
	<20070606185829.GA26062@tree.beaverton.ibm.com>
	<20070606193514.GN17143@linux-os.sc.intel.com>
	<20070606231642.GH13751@tree.beaverton.ibm.com>
	<20070608005726.GO17143@linux-os.sc.intel.com>
	<20070618223819.GD9751@tree.beaverton.ibm.com>
	<20070618235434.GB7160@linux-os.sc.intel.com>
	<20070619005136.GF9751@tree.beaverton.ibm.com>
Date: Tue, 19 Jun 2007 11:54:45 -0600
In-Reply-To: <20070619005136.GF9751@tree.beaverton.ibm.com> (Darrick J. Wong's
	message of "Mon, 18 Jun 2007 17:51:36 -0700")
Message-ID: <m1sl8nn82i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> writes:

> On Mon, Jun 18, 2007 at 04:54:34PM -0700, Siddha, Suresh B wrote:
>
>> > <call to set_affinity>
>> > [  256.298787] irq=4341 affinity=d
>> > <ethernet on irq 4341 stops working>
>> 
>> And just to make sure, at this point, your MSI irq 4341 affinity
>> (/proc/irq/4341/smp_affinity) still points to '2'?
>
> Actually, it's 0xD.  From the kernel's perspective the mask has been
> updated (and I even stuck a printk into set_msi_irq_affinity to verify
> that the writes are happening) but ... the hardware doesn't seem to
> reflect this.  I also tried putting read_msi_msg right afterwards to
> compare contents, though it complained about all the MSIs _except_ for
> 4341.  (Of course, I could just be way off on the effectiveness of
> that.)

The fact that MSI interrupts are having problems is odd.  It is possible
that we still have a bug in there somewhere but msi interrupts should
be safe to migrate outside of irq context (no known hardware bugs).
As we can actually synchronize with the irq source and eliminate all
of the migration races.

The non-msi case requires hitting a hardware race that is rare enough
you should not normally have problems.

Eric
