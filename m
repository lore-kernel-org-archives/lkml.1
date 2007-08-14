Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbXHNQPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbXHNQPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbXHNQPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:15:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbXHNQPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:15:01 -0400
Message-ID: <46C1D4D8.2080202@redhat.com>
Date: Tue, 14 Aug 2007 12:14:16 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Michael Mauch <michael.mauch@gmx.de>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: Serial ports rearranged in 2.6.22?
References: <20070810213925.GB10855@elmicha> <200708131534.15235.bjorn.helgaas@hp.com> <20070813222800.GB25159@elmicha> <200708131633.56908.bjorn.helgaas@hp.com>
In-Reply-To: <200708131633.56908.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2007 06:33 PM, Bjorn Helgaas wrote:
> On Monday 13 August 2007 04:28:00 pm Michael Mauch wrote:
>> Bjorn Helgaas wrote:
>>
>>> On Saturday 11 August 2007 09:49:25 am Michael Mauch wrote:
>>>> Yinghai Lu wrote:
>>>>
>>>>> On 8/10/07, Michael Mauch <michael.mauch@gmx.de> wrote:
>>>>>> With 2.6.22 I get the names <-> ports/irqs the other way around:
>>>>>>
>>>>>> 00:08: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
>>>>>> 00:09: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
>>>>>> ...
>>>>> http://lkml.org/lkml/2007/7/25/455
>>>> Thanks - I applied that patch and the names are back to normal again:
>>>>
>>>> 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>>>> 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
>>> Just FYI, the patch Yinghai mentioned above was experimental, and
>>> we decided it was the wrong solution.
>>>
>>> For 2.6.22, the easiest workaround is to boot with the 
>>> "legacy_serial.force" option.
>> Ah, ok, and load the legacy_serial module. Going from built-in serial to
>> modules I was already challenged to find serial_core, 8250, 8250_pnp
>> and/or 8250_pci (the help in "make menuconfig" does not seem to show the
>> help that is written in the Kconfig file for 8250_pnp and 8250_pci).
> 
> Yes, I messed up the legacy_serial module stuff.
> 
>>> For 2.6.23, we reverted my patch that caused the names to be swapped:
>>>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=57d4810ea0d9ca58a7bcc1336607f0cede0a2abf
>> Thanks for the information - I wondered how you decided. 
>>
>> What about 2.6.22.x? Or should the distro kernels use that revert patch
>> for their stable 2.6.22 kernels?
> 
> I would not recommend the experimental patch (http://lkml.org/lkml/2007/7/25/455).
> Using the revert patch is probably safest, since it also avoids
> the module load issues.
> 

Should that be submitted for 2.6.22-stable?
