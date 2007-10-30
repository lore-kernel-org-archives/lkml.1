Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbXJ3Wmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbXJ3Wmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXJ3Wmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:42:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33976 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbXJ3Wmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:42:37 -0400
Date: Tue, 30 Oct 2007 23:42:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Joerg Roedel <joerg.roedel@amd.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, benjamin.serebrin@amd.com
Subject: Re: Whats the purpose of get_cycles_sync()
Message-ID: <20071030224234.GA19737@one.firstfloor.org>
References: <20071030174452.GA18619@amd.com> <p73sl3s2w29.fsf@bingen.suse.de> <20071030220209.GA21142@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030220209.GA21142@suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 11:02:09PM +0100, Vojtech Pavlik wrote:
> > He can give details on the test.
> > 
> > I suspect the reason was because the CPU reordered the RDTSCs so that
> > a later RDTSC could return a value before an earlier one. This can
> > happen because gettimeofday() is so fast that a tight loop calling it can
> > fit more than one iteration into the CPU's reordering window.
> 
> The K8's still guarantee that subsequent RDTSCs return increasing
> values, even if the processor reorders them.

Ah didn't realize this

> 
> What could have been happening then was that the RDTSC instruction might
> have been reordered by the CPU out of the seqlock, causing trouble in
> the calculation.

Ok anyways it fixed that problem.  So it cannot be taken out.
> 
> Anyway, adding the CPUID didn't solve all the problems we've seen back
> then, and so far none of the approaches for using TSC without acquiring
> a spinlock on multi-socket AMD boxes worked 100% correctly.

The code is not used on multi-core anyways currently (without Jiri's
patch). It should just work correctly on single core.

-Andi
