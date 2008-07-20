Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYGTJBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYGTJBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYGTJBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:01:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50598 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYGTJBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:01:10 -0400
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
	trace_hardirqs_on_caller
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
       kexec <kexec@lists.infradead.org>
In-Reply-To: <19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	 <200807190928.33978.m.kozlowski@tuxland.pl>
	 <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
	 <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
	 <20080719221723.GB5578@suse.de>
	 <19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com>
	 <19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com>
	 <20080719225817.GA6264@suse.de>
	 <19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 02:01:02 -0700
Message-Id: <1216544462.9311.20.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-20 at 01:11 +0200, Vegard Nossum wrote:
> Maybe the firmware memmap code can simply run a little later in the
> boot sequence?

Heh, I'm catching up on this thread...

It is possible that it could run later.  But, I do know that there are
at least a couple of these tables (on various arches) that we toss out
of memory or become unavailable later in boot.  

I do this this:

    sysfs: add /sys/firmware/memmap

is really being done at the wrong level.  I don't, for instance, see
*any* reference to memory hotplug in these patches.  That's because
they're done against firmware structures, and memory hotplug doesn't
update firmware structures on the two architectures that I can remember
(ppc64 and x86).

In other words, kexec using this probably won't work on a memory hotplug
machine.

Secondly, why don't we just modify the
existing /sys/devices/system/memory things to properly export what exec
needs?  They're already cross-platform *and* they're updated with memory
hotplug events.  

-- Dave

