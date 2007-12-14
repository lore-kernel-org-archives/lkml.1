Return-Path: <linux-kernel-owner+w=401wt.eu-S933173AbXLNMxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbXLNMxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbXLNMxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:53:45 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:37934 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbXLNMxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:53:44 -0500
Date: Fri, 14 Dec 2007 09:39:46 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: PCI resource unavailable on mips
Message-ID: <20071214093945.GA25186@linux-mips.org>
References: <1197557806.3370.7.camel@microwave.infinitevideocorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197557806.3370.7.camel@microwave.infinitevideocorporation.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:56:46AM -0500, Jon Dufresne wrote:

> I've done a bit of linux driver development on x86 in the past.
> Currently I am working on my first ever linux driver for a mips box. I
> started by testing the device in an x86 box and got it reasonable stable
> and am now testing it in the mips box. There appears to be a major
> problem, one unlike I have ever seen before.
> 
> My PCI device has three BARS. This can be confirmed by the Technical
> documentation and the x86 code. When the pci device is first probed, I
> run a loop to printk out the bar information, this is just as a sanity
> check. Here is the output on the x86:
> 
> Bar0:PHYS=e0000000 LEN=04000000
> Bar1:PHYS=efa00000 LEN=00200000
> Bar2:PHYS=e8000000 LEN=04000000
> 
> but here is the output on the mips:
> Bar0:PHYS=20000000 LEN=04000000
> Bar1:PHYS=24000000 LEN=00200000
> Bar2:PHYS=00000000 LEN=00000000
> 
> notice, BAR2 has no valid information on the mips. I tried to run
> "pci_enable_device" before printing this information, as suggested by
> LDD but it did not help.

Resources are assigned on bootup by MIPS, not yet by pci_enable_device,
so that was expected.

> Has anyone seen a problem like this before and any idea how I can get
> BAR2 a proper address?
> 
> If I examine the config space directly there is an address in BAR2's
> register, however it isn't in the 0x20000000 range like the other two,
> instead it is 0x1c000000. Also if I do a ``cat /proc/iomem'' I correctly
> see BAR0 and BAR1 in the output, but not BAR2.

Odd.  I knew the resource allocation stuff has it's issues for some
non-trivial configuration but that one is a new one.  Which makes me
wonder if your platform runs the PCI code in probe-only mode where it
will not actually assign resources but only inherit the whole PCI setup
except interrupt routing from the firmware.

What MIPS platform do you use?  I'd like to take a look at its PCI setup
code.

  Ralf
