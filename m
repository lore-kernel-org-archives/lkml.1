Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXHEGC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXHEGC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 02:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXHEGCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 02:02:49 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:5601 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbXHEGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 02:02:48 -0400
Date: Sun, 5 Aug 2007 09:02:41 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-ID: <20070805060241.GA15693@rhun.haifa.ibm.com>
References: <46B3A7BB.9000102@redhat.com> <20070803155035.1fb11c9a.akpm@linux-foundation.org> <200708041130.42038.ak@suse.de> <20070804093222.f0d7f3c7.akpm@linux-foundation.org> <86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com> <20070804111532.1d3936fa.akpm@linux-foundation.org> <86802c440708041202s4d165e6co701fe1c1e5c1a5ca@mail.gmail.com> <20070804225222.67fd9448.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804225222.67fd9448.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 10:52:22PM -0700, Andrew Morton wrote:
> On Sat, 4 Aug 2007 12:02:35 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> 
> > On 8/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Sat, 4 Aug 2007 10:45:31 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> > >
> > > > Andrew,
> > > >
> > > > still need
> > x86_64-get-mp_bus_to_node-as-early-v2.patch is already in the -mm
> > 
> > it fixs
> > pirq_peer_trick(void) in irq.c
> > pcibios_fixup_peer_bridges in legacy.c
> > 
> > by allocate sd.
> > 
> 
> I don't understand you much, sorry.  Are you saying that
> x86_64-get-mp_bus_to_node-as-early-v2.patch should be merged in
> 2.6.23?

If I may try to elaborate, yhlu is pointing out that the ->sysdata
conversion missed a couple of spots in i386 where we need to allocate
a pci_sysdata object as well. Unfortunately I don't think
x86_64-get-mp_bus_to_node-as-early-v2 is a suitable fix as it does a
whole bunch of other stuff too. I am now preparing a minimal patch
(based on x86_64-get-mp_bus_to_node-as-early-v2) that only takes care
of the missing ->sysdata bits. If that patch cures the original bug
and doesn't cause any more regressions, it's definitely 2.6.23
material.

Cheers,
Muli
