Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYG0Tnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYG0Tnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbYG0Tnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:43:45 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:29485 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751006AbYG0Tno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:43:44 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=fGO4tVQLAAAA:8 a=e5mUnYsNAAAA:8 a=J7Emv_Ib2ZDzVmxTqGEA:9 a=on3AerLtWeNTlSql8qsA:7 a=SsADE4CtVzHiFqjzNvszvVpON6kA:4 a=RsnuHwBzcWYA:10 a=Nc4zK0GYoJ8A:10
Message-ID: <488CCFEE.5040304@shaw.ca>
Date: Sun, 27 Jul 2008 13:43:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Nikos Chantziaras <realnc@arcor.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: do_IRQ: 0.83/0.84 No irq handler for vector
References: <fa.dCDqP8nkXgM8NhJMm3I+bMK+//w@ifi.uio.no> <fa.7GQkKKWUwuudcm81hY5cYLJkEY4@ifi.uio.no>
In-Reply-To: <fa.7GQkKKWUwuudcm81hY5cYLJkEY4@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikos Chantziaras wrote:
> Nikos Chantziaras wrote:
>> Kernel 2.6.26 (on x86-64) gives "do_IRQ: 0.83 No irq handler for 
>> vector" (and "do_IRQ: 0.83", but less often) warnings periodically.
> 
> I changed the kernel config:
> 
>   - CONFIG_PCI_MSI=y
>   + # CONFIG_PCI_MSI is not set
> 
> In other words I disabled Message Signaled Interrupt support.  Now 
> instead of "do_IRQ: 0.83 No irq handler for vector" I get:
> 
>   +------ PCI-Express Device Error ------+
>   Error Severity          : Uncorrected (Non-Fatal)
>   PCIE Bus Error type     : Transaction Layer
>   Flow Control Protocol   : First
>   Receiver ID             : 0010
>   VendorID=1106h, DeviceID=a208h, Bus=00h, Device=02h, Function=00h
>   Broadcast error_detected message
>   Broadcast mmio_enabled message
>   Broadcast resume message
>   AER driver successfully recovered
> 
> (Repeated as many times as the "do_IRQ" message previously.)
> 
> In case someone needs it, this is my complete dmesg:
> 
>   http://realnc.pastebin.com/d6534029
> 
> and this is the kernel configuration: 
> http://bugs.freedesktop.org/attachment.cgi?id=17912

My guess is some device is that some device is generating MSI interrupts 
without any handler being registered for it, and with MSI support 
disabled it now generates a master abort instead. Most likely whatever 
device is connected to the Bus=00h, Device=02h, Function=00h bridge. Can 
you post "lspci -vv" output?
