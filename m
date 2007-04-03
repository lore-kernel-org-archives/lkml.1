Return-Path: <linux-kernel-owner+w=401wt.eu-S1946005AbXDCWKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946005AbXDCWKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946006AbXDCWKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:10:39 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946005AbXDCWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:10:37 -0400
Message-ID: <4612D0CA.3070209@zytor.com>
Date: Tue, 03 Apr 2007 15:10:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Andi Kleen <ak@suse.de>,
       Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <4612B303.5000109@zytor.com> <4612C077.60502@goop.org> <200704032351.17823.arnd@arndb.de>
In-Reply-To: <200704032351.17823.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> One interesting aspect of the PS3 hypervisor is that some of the
> low-speed interfaces are implemented as a virtual UART, meaning
> something that only has read and write operations and uses an
> interrupt for flow control. The implementation in 
> drivers/ps3/vuart.c is probably more complex than what we want
> as a generic transport mechanism, but simply having a bidirectional
> data stream sounds like an ideal abstraction for the "simple"
> case. Some more or less obvious users of this include:
> 
> - console
> - additional tty
> - random
> - slow network (using ppp)
> - printer
> - watchdog
> - hid (e.g. mouse)
> - system management (like ps3)
> - fast network (in combination with
>   shared memory segment)
> 
> The transport can be hypervisor specific, e.g. there could be
> a virtual PCI serial port on kvm, an hcall interface on the ps3
> and a virtual CTC on s390 (kidding), while all of them can have
> the same kind of hardware _behind_ the serial connection.
> 

Note that at least for PIO-based devices, there is nothing that says you 
can't implement PCI over another transport, if you wish.  It's really 
just a very simple RPC protocol.

DMA is trickier, as it makes the data appear into the address space of 
the guest in a way that is both device- and host-dependent (in the 
presence of PCI domains, IOMMU etc.)  There may be reason to avoid DMA 
for that reason.

	-hpa
