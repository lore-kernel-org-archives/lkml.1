Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYHWAWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYHWAWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 20:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYHWAWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 20:22:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYHWAWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 20:22:37 -0400
Date: Fri, 22 Aug 2008 14:22:35 -1000
From: Joshua Hoblitt <j_kernel@hoblitt.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080823002235.GL23377@hoblitt.com>
References: <20080822002952.GG23377@hoblitt.com> <20080822010014.GH23377@hoblitt.com> <20080822011055.GI23377@hoblitt.com> <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com> <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com> <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com> <20080822035024.GB30284@elte.hu> <20080822035609.GD30284@elte.hu> <86802c440808212148k74e56fa2mdb2e329ed4df1271@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808212148k74e56fa2mdb2e329ed4df1271@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've confirmed that the boards in these systems are Tyan Tempest i5400PW
(S5397)s.  We've discovered a workload that will deadlock the system
under both 2.6.24.2 and -tip kernel with the mtrr masking patch.  The
only thing unusual about this workload is that one of the binaries in
it constantly segvs...  Is it possible that these deadlocks (no kernel
oops on console) are caused by MSR setup wierdness or is it likely unrelated?

-J

--
On Thu, Aug 21, 2008 at 09:48:41PM -0700, Yinghai Lu wrote:
> On Thu, Aug 21, 2008 at 8:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> i've tidied up your patch (see the commit below) and have queued it up
> >> in x86/urgent. It seems fairly safe and i guess we can push it to
> >> v2.6.27 if Joshua reports test success. Joshua, could you give it a go
> >> please?
> >
> > or just try the latest tip/master - please check whether you are getting
> > the right amount of RAM out of box plus this warning message:
> >
> >> WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
> >
> 
> according to his dmesg, it works.
> 
> may need to change it to WARN_ON only print one time
> 
> YH
