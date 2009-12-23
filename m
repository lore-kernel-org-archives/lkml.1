Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZLWPJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZLWPJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbZLWPJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:09:30 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39235 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZLWPJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:09:29 -0500
Message-ID: <4B3232A1.8050505@codemonkey.ws>
Date: Wed, 23 Dec 2009 09:09:21 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> 	<4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> 	<4B3103B4.4070708@gmail.com> <f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com>
In-Reply-To: <f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 12:15 AM, Kyle Moffett wrote:
> This is actually something that is of particular interest to me.  I
> have a few prototype boards right now with programmable PCI-E
> host/device links on them; one of my long-term plans is to finagle
> vbus into providing multiple "virtual" devices across that single
> PCI-E interface.
>
> Specifically, I want to be able to provide virtual NIC(s), serial
> ports and serial consoles, virtual block storage, and possibly other
> kinds of interfaces.  My big problem with existing virtio right now
> (although I would be happy to be proven wrong) is that it seems to
> need some sort of out-of-band communication channel for setting up
> devices, not to mention it seems to need one PCI device per virtual
> device.

We've been thinking about doing a virtio-over-IP mechanism such that you 
could remote the entire virtio bus to a separate physical machine. 
virtio-over-IB is probably more interesting since you can make use of 
RDMA. virtio-over-PCI-e would work just as well.

virtio is a layered architecture.  Device enumeration/discovery sits at 
a lower level than the actual device ABIs.  The device ABIs are 
implemented on top of a bulk data transfer API.  The reason for this 
layering is so that we can reuse PCI as an enumeration/discovery 
mechanism.  This tremendenously simplifies porting drivers to other OSes 
and let's us use PCI hotplug automatically.  We get integration into all 
the fancy userspace hotplug support for free.

But both virtio-lguest and virtio-s390 use in-band enumeration and 
discovery since they do not have support for PCI on either platform.

Regards,

Anthony Liguori
