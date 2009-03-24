Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbZCXStw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbZCXStw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZCXStk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:49:40 -0400
Received: from mail.lang.hm ([64.81.33.126]:46169 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbZCXStj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:49:39 -0400
Date: Tue, 24 Mar 2009 11:49:26 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matt Domsch <Matt_Domsch@dell.com>
cc: netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
In-Reply-To: <20090324154617.GA16332@auslistsprd01.us.dell.com>
Message-ID: <alpine.DEB.1.10.0903241140530.16753@asgard.lang.hm>
References: <20090324154617.GA16332@auslistsprd01.us.dell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, Matt Domsch wrote:

> You may recall http://lkml.org/lkml/2006/9/29/268, wherein I described
> network device enumeration and naming challenges, and several possible
> fixes.  Of these, Fix #1 (fix the PCI device list to be sorted
> breadth-first) has been implemented in the kernel, and Fix #3 (system
> board routing rules) have been implemented on Dell PowerEdge 10G and
> 11G servers (11G begin selling RSN).
>
> However, these have not been completely satisfactory.  In particular,
> it keeps getting harder and harder to route PCI-Express lanes to
> guarantee the same ordering between a depth-first and breadth-first
> walk, and it turns out, that isn't sufficient anyhow.
>
>
> Problem:  Users expect on-motherboard NICs to be named eth0..ethN.  This can be difficult to achieve.

I dispute this statement.

I have several hundred servers that have the on-motherboard NICs as the 
last ones.

anyone who's been making the assumption you describe will have been 
running into problems for many years.

it's just not a valid assumption.

> Ethernet device names are initially assigned by the kernel, and may be
> changed by udev or nameif in userspace.  The initial name assigned by
> the kernel is in monotonically increasing order, starting with eth0.
> In this instance, the enumeration directly leads to an assigned name.
>
> Complications:
>
> 1) Devices are discovered, and presented to the kernel for name
>   assignment, based on several factors:
>
>   a) the kernel hotplug mechanism emits events for udev to catch, to
>
>
>   b) udev may run modprobes in parallel.  It guarantees that the
>
>      To get any consistent ordering now, one of two things must
>      happen:
>
>      i) drivers must be loaded before udev begins loading drivers
>         (either very early in initscripts, or in the inital ramdisk).
>     ii) something must "fix up" the kernel-assigned names after
>         udev's modprobes complete.  udev does this as well.
>
> 2) udev may have rules to change the device names.  This is most often
>   seen in the '70-persistent-net.rules' file.  Here we have
>   additional challenges:
>
>   a) this does not exist the first time devices are discovered; the
>
>   b) it introduces state (MAC addresses) to the system, on a system
>
>   c) udev may not always be able to change a device's name.  If udev
>

not everyone uses udev. I compile the nessasary drivers into the kernel 
and don't need udev to get interfaces.

> 3) End users have the (reasonable?) expectation that NIC ports

as noted above, only some users have this unrealistic expectation.

> 4) When adding a network card to an existing system, what should the
>   ports on the new card be named?  If it is added, they will be named
>   ethN+1... above the existing named cards.  This means a (new)
>   add-in card in PCI slot 3 may have ports named eth5 and eth6, while
>   an add-in card in PCI slot 5 may have ports named eth2 and eth3.
>   This is not intuitive.

this approach causes serious problems in a few cases, including

1. a NIC goes bad and you replace it. now all the configs change

2. you reinstall a box and it's interface names change.

David Lang
