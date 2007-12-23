Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbXLWBe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbXLWBe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXLWBeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:34:19 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35898 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbXLWBeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:34:18 -0500
Message-ID: <476DBB18.1090407@garzik.org>
Date: Sat, 22 Dec 2007 20:34:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, torvalds@linux-foundation.org
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org>
In-Reply-To: <20071222064719.73fdd9a4@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 22 Dec 2007 09:20:06 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Arjan van de Ven wrote:
>>> Hi,
>>>
>>> Linus really wants the extended (4Kb) PCI configuration space
>>> (using MCFG acpi table etc) to be opt-in, since there's many issues
>>> with it and most drivers don't even use/need it. The idea behind
>>> opt-in is that if you don't use it, you don't get to suffer the
>>> bugs...
>>>
>>> Booted on my 64 bit test machine; sadly it has a defunct BIOS that
>>> doesn't have a working MCFG.
>>>
>>>
>>> From: Arjan van de Ven <arjan@linux.intel.com>
>>> Subject: Make MMCONFIG space a driver opt-in
>>>
>>> There are many issues with using the extended PCI configuration
>>> space (CPU, Chipset and most of all BIOS bugs). This while the vast
>>> majority of drivers and devices don't even use/need to use the
>>> memory mapped access methods since they don't use the config space
>>> beyond the traditional 256 bytes.
>>>
>>> This patch makes accessing the extended config space a driver
>>> choice, via the
>>>
>>> pci_enable_ext_config(pdev)
>> Yuck.  And, Linus is just being silly.  Wait a year then turn on 
>> MMCONFIG :)  It took PCI MSI a while to mature, but is finally
>> getting there.
>>
> 
> Do you hate the name or the concept? I'm certainly open for a better name.... 

Many problems:

* even if driver not loaded, you might need to access extended capabilities

* kernel hacker (me!) might request user to dump PCI config space to see 
what changes, after various experiments.  we need to see that extended 
space, if it exists, even if driver not loaded.

* this "mixed config access" model is new to Linux, after always having 
config access type be a global system attribute.  It introduces new 
complexity and new inconsistency all over the place.

* hardware makers will not test this weird "mixed access" model.

You thought mmconfig was poorly tested?  Well, why the hell choose 
something with even less testing behind it (and future likelihood of nil 
testing).

Always-off is better than mixed access.

	Jeff


