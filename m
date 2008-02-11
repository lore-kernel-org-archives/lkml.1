Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYBKCxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYBKCxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 21:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYBKCxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 21:53:40 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39802 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYBKCxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 21:53:39 -0500
Date: Sun, 10 Feb 2008 20:53:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
In-reply-to: <86802c440802101749h5af30b4dm1836f881a898652e@mail.gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Message-id: <47AFB8AD.3010904@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <20080129025615.GC20198@parisc-linux.org>
 <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>
 <47AB299D.4000500@redhat.com> <20080209124138.GA28967@parisc-linux.org>
 <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
 <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org>
 <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
 <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org>
 <20080210204556.GG5299@parisc-linux.org>
 <86802c440802101749h5af30b4dm1836f881a898652e@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Feb 10, 2008 12:45 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>> On Sun, Feb 10, 2008 at 12:24:18PM -0800, Linus Torvalds wrote:
>>> On Sun, 10 Feb 2008, Yinghai Lu wrote:
>>>>> I suggest Ivan's patch be merged ASAP as it actually fixes bugs.
>>>>> This patch is just cleanup (and takes care of some future concerns).
>>>> your patch and Ivan's patch should be merged in one...
>>> I really don't care whether they get merges as one or separately, but I
>>> think it should be merged _now_ (-rc1 is already delayed), and I'd like to
>>> see the final versions of both. Does anybody have them in a final
>>> agreed-upon format (preferably with that oddness in quirk_intel_irqbalance
>>> also fixed?)
>> I just looked at fixing that -- the reason seems to be that we don't
>> actually have the struct pci_dev at that point.  I can fix it, but I
>> think it's actually buggy.  I want to look at some chipset docs to
>> confirm that though.
>>
>> I've attached the two patches that I believe are the ones we want.  We
>> can (and should) fix quirk_intel_irqbalance separately.
> 
> Andrew,
> 
> those two patch just got into linus 2.6.25-rc1.
> 
> I assume that you will drop
> gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch in
> -mm.
> 
> please check some updated patches in -mm that could be affected. hope
> it could save you some time
> 
> x86-validate-against-acpi-motherboard-resources.patch
> x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
> x86-mmconf-enable-mcfg-early.patch
> x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch

I don't think any of these patches are affected. They all affect whether 
to use MMCONFIG globally or not, regardless of whether not particular 
accesses will use it.
