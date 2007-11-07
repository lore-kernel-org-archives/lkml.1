Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbXKGTSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbXKGTSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXKGTSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:18:43 -0500
Received: from rtr.ca ([76.10.145.34]:4823 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbXKGTSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:18:43 -0500
Message-ID: <47320F92.3060108@rtr.ca>
Date: Wed, 07 Nov 2007 14:18:42 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: irq 21: nobody cared 2.6.24-rc1
References: <200710251045.37040.bonganilinux@mweb.co.za> <20071101133238.16bb9a3f.akpm@linux-foundation.org> <200711020133.28907.bonganilinux@mweb.co.za>
In-Reply-To: <200711020133.28907.bonganilinux@mweb.co.za>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bongani Hlope wrote:
> On Thursday 01 November 2007 22:32:38 Andrew Morton wrote:
>> On Thu, 25 Oct 2007 10:45:36 +0200
>>
>> Bongani Hlope <bonganilinux@mweb.co.za> wrote:
>>> Booting with irqpoll works
>>>
>>> ls /proc/irq/21/ (with irqpoll)
>>> ehci_hcd:usb1/  smp_affinity  uhci_hcd:usb2/  uhci_hcd:usb3/ 
>>> uhci_hcd:usb4/
>>>
>>>  Disabling IRQ #21
>> Was any earlier kernel version OK?  2.6.23?
> 
> Yes the 2.6.23 kernel works fine. This seems to happen when I boot the 
> 2.6.24-rc1 kernel with an iPod attached (hope this helps), but the 2.6.23 
> kernel doesn't experience this problem.
..

Something in 2.6.24-rc* seems to be a lot more fussy about this kind
of situation than in 2.6.23.   I have a driver (sata_qstor) that manages
a piece of hardware that unfortunately generates spurious interrupts
regularly.

With 2.6.23, it was only rarely bad enough to cause the "Disabling IRQ #nn"
event to occur.  But in 2.6.24-rc*, it happens almost immediately now
(so, yes, I've gone and put a workaround into the driver for it).

Something's different.
