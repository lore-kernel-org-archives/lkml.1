Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbYBSUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbYBSUgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYBSUgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:36:00 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:20803 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYBSUf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:35:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=drlUsXWZG0X98gSl1lv+xP9afmeDJjGoqMf60E3xFx8spQm+ZA+JV0upUCptJLp6uqKngIPg0y5rPyYMJp7q7K9rlS+ywf3sB/XLxKWjfjTsRTyrwuUGKLAf6nNIRQCUd2gyGWlaDii0X89/PFNJRw3o31tyom2nevCBCN2awUs=
Message-ID: <47BB3DA1.8040001@gmail.com>
Date: Tue, 19 Feb 2008 15:35:45 -0500
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly resolved
References: <Pine.LNX.4.44L0.0802162210110.13745-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802162210110.13745-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/2008 10:35 PM, Alan Stern wrote:

> On Sat, 16 Feb 2008, Andrew Buehler wrote:

>> Until this thread, I was not even aware that ACPI was related to
>> USB; I had largely conflated it with a similar acronym which I
>> think is related to power management and which I can suddenly not
>> even find in my kernel config. I will, however, look into
>> linux-acpi.
> 
> ACPI isn't directly related to USB; rather it has to do with
> transferring information between the OS and the
> BIOS/vendor-specific-hardware. Power management is example where such
> a transfer is needed. In your case, the relevant information is
> which IRQ is connected to which motherboard device. If you don't have
> ACPI enabled in your configuration, then perhaps that's the problem
> -- try enabling it.

Apparently it was the problem; enabling ACPI has fixed not only the USB
problem but also the network problem (somewhat miraculously, since I'm
quite certain that I had ACPI enabled in a 2.6.23.x kernel where the
network did not work despite an apparently matching driver).

I feel somewhat foolish for having reported a regression over what turns
out to have been a simple misconfiguration, but I still do think it's
somewhat misleading at best for something so potentially important to
completely non-power-related things to be buried under the heading of
power management... I would suggest moving it somewhere else in the
config and the dependencies, except that I have neither a suggestion for
a possible place nor any idea of how much actual work that would
involve.



With those two problems out of the way, what is left is the hard-drive
issue, and that is also halfway fixed by enabling ACPI. Specifically, it
is "fixed" in that the kernel sees the hard drive and I can mount it,
but it is not fixed in that the program we need to use in this
environment does not see the drive.

I have a config from a boot disc running 2.6.5 (that's not a typo) under
which the program in question *does* see the drive, but there are
massive differences between that config and the one I am using now, and
narrowing the critical difference down is likely to be somewhat
difficult - particularly since some of the "differences" are merely
renamed config symbols (i.e. the CONFIG_SCSI_SATA_*->CONFIG_SATA_*
switchover), and I have limited ability to tell which without intensive
investigation. Are there any established techniques for simplifying this
kind of comparison?

-- 
    Andrew Buehler
