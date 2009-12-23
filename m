Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZLWGPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZLWGPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 01:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZLWGPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 01:15:51 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56877 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbZLWGPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 01:15:50 -0500
MIME-Version: 1.0
In-Reply-To: <4B3103B4.4070708@gmail.com>
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> 
	<4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> 
	<4B3103B4.4070708@gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 23 Dec 2009 01:15:30 -0500
Message-ID: <f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 12:36, Gregory Haskins
<gregory.haskins@gmail.com> wrote:
> On 12/22/09 2:57 AM, Ingo Molnar wrote:
>> * Gregory Haskins <gregory.haskins@gmail.com> wrote:
>>> Actually, these patches have nothing to do with the KVM folks. [...]
>>
>> That claim is curious to me - the AlacrityVM host
>
> It's quite simple, really.  These drivers support accessing vbus, and
> vbus is hypervisor agnostic.  In fact, vbus isn't necessarily even
> hypervisor related.  It may be used anywhere where a Linux kernel is the
> "io backend", which includes hypervisors like AlacrityVM, but also
> userspace apps, and interconnected physical systems as well.
>
> The vbus-core on the backend, and the drivers on the frontend operate
> completely independent of the underlying hypervisor.  A glue piece
> called a "connector" ties them together, and any "hypervisor" specific
> details are encapsulated in the connector module.  In this case, the
> connector surfaces to the guest side as a pci-bridge, so even that is
> not hypervisor specific per se.  It will work with any pci-bridge that
> exposes a compatible ABI, which conceivably could be actual hardware.

This is actually something that is of particular interest to me.  I
have a few prototype boards right now with programmable PCI-E
host/device links on them; one of my long-term plans is to finagle
vbus into providing multiple "virtual" devices across that single
PCI-E interface.

Specifically, I want to be able to provide virtual NIC(s), serial
ports and serial consoles, virtual block storage, and possibly other
kinds of interfaces.  My big problem with existing virtio right now
(although I would be happy to be proven wrong) is that it seems to
need some sort of out-of-band communication channel for setting up
devices, not to mention it seems to need one PCI device per virtual
device.

So I would love to be able to port something like vbus to my nify PCI
hardware and write some backend drivers... then my PCI-E connected
systems would dynamically provide a list of highly-efficient "virtual"
devices to each other, with only one 4-lane PCI-E bus.

Cheers,
Kyle Moffett
