Return-Path: <linux-kernel-owner+w=401wt.eu-S966213AbXDDAxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966213AbXDDAxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966214AbXDDAxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:53:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36449 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966213AbXDDAxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:53:13 -0400
Message-ID: <4612F6E9.7040003@zytor.com>
Date: Tue, 03 Apr 2007 17:52:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com, virtualization@lists.linux-foundation.org
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704032351.17823.arnd@arndb.de>	<4612D0CA.3070209@zytor.com> <200704040049.13118.arnd@arndb.de>
In-Reply-To: <200704040049.13118.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 04 April 2007, H. Peter Anvin wrote:
>> Note that at least for PIO-based devices, there is nothing that says you 
>> can't implement PCI over another transport, if you wish.  It's really 
>> just a very simple RPC protocol.
> 
> The PIO aspect of PCI is simple, yes, except on architectures that don't
> have the concept of PIO or even uncached memory, but even that can
> be done by defining readl/writel/inl/outl/... as hcalls.
> 
> The tricky part about PCI is the device probing, everything about config
> space accesses, interrupt swizzling, bus/device/function numbers and
> base address registers becomes a pointless excercise when the other side
> is just faking it.

Configuration space access is platform-dependent.  It's only defined to 
work in a specific way on x86 platforms.

"Interrupt swizzling" is really totally independent of PCI.  ALL PCI 
really provides is up to four interrupts per device (not counting 
MSI/MSI-X) and an 8-bit writable field which the platform can choose to 
use to hold interrupt information.  That's all.  The rest is all 
platform information.

PCI enumeration is hardly complex.  Most of the stuff that doesn't apply 
to you you can generally ignore, as is done by other busses like 
HyperTransport when they emulate PCI.

That being said, on platforms which are PCI-centric, such as x86, this 
of course makes it a lot easier to produce virtual devices which work 
across hypervisors, since the device model, of *any* operating system is 
set up to handle them.

	-hpa
