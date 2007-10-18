Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbXJRRGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbXJRRGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765985AbXJRRGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:06:24 -0400
Received: from rtr.ca ([76.10.145.34]:2396 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765930AbXJRRGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:06:23 -0400
Message-ID: <4717928D.6070703@rtr.ca>
Date: Thu, 18 Oct 2007 13:06:21 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 0/3] Fix two PEIe hotplug issues
References: <4716CB9D.6080503@rtr.ca>	<4716CE79.7040201@rtr.ca> <20071018091347.4b94faf8.kristen.c.accardi@intel.com>
In-Reply-To: <20071018091347.4b94faf8.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Wed, 17 Oct 2007 23:09:45 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Mark Lord wrote:
>>> Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
>>> (and others?) in conjunction with the modparam of pciehp_force=1.
>>
>> To make things simpler for distro people, I'm contemplating another patch
>> in this series, to allow something like:  pciehp_force=2
>>
>> This would then *try* the ACPI BIOS calls, and only fall back to pcie_force=1
>> if the BIOS support fails.  This would be an ideal default for most desktop/notebook
>> distros to consider using.
>>
>> Without this, they don't have any good choice:  use the defaults, and things fail
>> on the most popular brand of machines in the marketplace.  Use pciehp_force=1,
>> and they may break (?) on other brands.
>>
>> So a hybrid of the two seems best.  Pity it couldn't be the default behaviour, though.
>> Or could it?  We're early enough in the 2.6.24 cycle for it..
>>
>> Opinions?
>>
> 
> NAK!  Absolutely no way will I take a patch that does this.  


No big deal.  I personally don't have a distro to maintain,
so no pain for me here.

> I've been actually having philosophical issues with
> even having pciehp_force as a module parameter at all.  As I said before,
> using pciehp_force violates the PCI spec.

No, it just provides a way to use the hardware when the vendor
didn't include BIOS functionality for it.

These notebooks fully support hotplug in the external ExpressCard slot
(which is the *whole point* of an external slot), and according to Dell
they work just fine with that other OS.  I don't use the "other OS" here,
but the hardware also works just fine with Linux now.

I'm guessing they just left out the BIOS functionality because
it was one of the very first machines to market with such slots,
and the BIOS wasn't mature enough.   So they rely upon more easily
updated software drivers instead.  The only gotcha is they do specify
that booting from the slot is not possible (because no BIOS support).

Cheers
