Return-Path: <linux-kernel-owner+w=401wt.eu-S1763883AbYBBPin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763883AbYBBPin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbYBBPif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:38:35 -0500
Received: from lixom.net ([66.141.50.11]:38363 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYBBPif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:38:35 -0500
Date: Sat, 2 Feb 2008 09:39:08 -0600
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, git-commits-head@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] Fix fallout from PCI: PCIE ASPM support
Message-ID: <20080202153908.GA16753@lixom.net>
References: <200802020506.m1256gXG027547@hera.kernel.org> <20080202052628.GB14936@lixom.net> <47A406B9.5070609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A406B9.5070609@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 09:59:21PM -0800, H. Peter Anvin wrote:
> Olof Johansson wrote:
>> On Sat, Feb 02, 2008 at 05:06:42AM +0000, Linux Kernel Mailing List wrote:
>>
>>>     PCI: PCIE ASPM support
>>
>> This one broke almost all defconfigs on powerpc, since they enable
>> CONFIG_EXPERIMENTAL and CONFIG_PCI, and this option defaults to y.
>>
>> Make it default to 'n' like most other options, and make it depend on
>> ACPI. Take out the unneccessary default 'n' from the debug option as well.
>>
>
> Is this actually ACPI-dependent?

It shouldn't be, but it seems like it's currently entangled a bit with
the acpi include files. OSC_ACTIVE_STATE_PWR_SUPPORT comes from
linux/pci-acpi.h.

I can't include acpi/acpi_bus.h though, since that ends up pulling in
asm/ files that don't exist on powerpc.

So if the probing is fixed, no, it's not ACPI-dependent. Seems like
something that's just as well to mask behind it until someone's actually
used and tested it on a non-ACPI platform though, no?

I would experiment with it but I believe our firmware turns off empty
links before the kernel is booted, we don't support hotplug at this time.


-Olof

