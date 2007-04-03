Return-Path: <linux-kernel-owner+w=401wt.eu-S1161048AbXDCR6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161048AbXDCR6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161049AbXDCR6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:58:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46670 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161048AbXDCR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:58:29 -0400
Date: Tue, 3 Apr 2007 19:58:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403175827.GA24033@one.firstfloor.org>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403173505.GD23689@one.firstfloor.org> <461292BF.5020803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461292BF.5020803@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:45:35AM -0700, Ulrich Drepper wrote:
> Andi Kleen wrote:
> >>> Topology is dependent on the number of CPUs.
> >> Not all of it.
> > 
> > What is not?
> 
> Memory banks can exist without a CPU present.  The places where you can
> plug in memory don't change and so the memory hierarchy can be described.

There are systems that support node hotplug, like Altix or the larger
IBM or Unisys x86 systems. Basically they are a bunch of
smaller systems connected with cables running a cache coherent network
protocol.  With that memory can appear (and disappear but we don't handle 
that yet) unexpectedly.

That said we might have some idea of that in advance -- it can
be described in ACPI SRAT -- but the trouble is that many quite
ordinary x86 server systems always describe hotplug zones even though
it is unlikely they will ever get any. Trusting that can be quite
inefficient.

> There is an inexpensive solution: finally make the vdso concept a bit
> more flexible.  You could add a vdso call to get the processor count.
> The vdso code itself can use a data page mapped in from the kernel.

The ELF aux vector is exactly that already.

> This page (read-only at userlevel) would contain global information such
> as processor count and topology.

You would still need an event notification mechanism, won't you?
> 
> 
> But we're getting IMO off topic here.  That's a separate and far more
> complicated issue.

Yes I agree. Hotplug is best ignored for now


> Here we now have the concrete issue that determining the CPU count is
> terribly expensive and there is a simple proposal to make it faster by
> keeping /sys/devices/system/cpu/ free from anything but cpu* directories.

The cost will be still large. Accessing sysfs will be never cheap.
For once anything going through the VFS tens to take a two sometimes
three digit number of locks.

If you want it cheap look for some other way.


-Andi
