Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbYG0UUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbYG0UUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbYG0UUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:20:05 -0400
Received: from main.gmane.org ([80.91.229.2]:59418 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686AbYG0UUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:20:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: do_IRQ: 0.83/0.84 No irq handler for vector
Date: Sun, 27 Jul 2008 23:19:43 +0300
Message-ID: <g6il94$8a1$1@ger.gmane.org>
References: <fa.dCDqP8nkXgM8NhJMm3I+bMK+//w@ifi.uio.no> <fa.7GQkKKWUwuudcm81hY5cYLJkEY4@ifi.uio.no> <488CCFEE.5040304@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-57559.home.otenet.gr
User-Agent: Thunderbird 2.0.0.14 (X11/20080715)
In-Reply-To: <488CCFEE.5040304@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Nikos Chantziaras wrote:
>> Nikos Chantziaras wrote:
>>> Kernel 2.6.26 (on x86-64) gives "do_IRQ: 0.83 No irq handler for 
>>> vector" (and "do_IRQ: 0.83", but less often) warnings periodically.
>>
>> I changed the kernel config:
>>
>>   - CONFIG_PCI_MSI=y
>>   + # CONFIG_PCI_MSI is not set
>>
>> In other words I disabled Message Signaled Interrupt support.  Now 
>> instead of "do_IRQ: 0.83 No irq handler for vector" I get:
>>
>>   +------ PCI-Express Device Error ------+
>>   Error Severity          : Uncorrected (Non-Fatal)
>>   PCIE Bus Error type     : Transaction Layer
>>   Flow Control Protocol   : First
>>   Receiver ID             : 0010
>>   VendorID=1106h, DeviceID=a208h, Bus=00h, Device=02h, Function=00h
>>   Broadcast error_detected message
>>   Broadcast mmio_enabled message
>>   Broadcast resume message
>>   AER driver successfully recovered
>>
>> (Repeated as many times as the "do_IRQ" message previously.)
>>
>> In case someone needs it, this is my complete dmesg:
>>
>>   http://realnc.pastebin.com/d6534029
>>
>> and this is the kernel configuration: 
>> http://bugs.freedesktop.org/attachment.cgi?id=17912
> 
> My guess is some device is that some device is generating MSI interrupts 
> without any handler being registered for it, and with MSI support 
> disabled it now generates a master abort instead. Most likely whatever 
> device is connected to the Bus=00h, Device=02h, Function=00h bridge. Can 
> you post "lspci -vv" output?

The device in question is my graphics card (an AMD/ATI Radeon X1950XT 
PCI-e):

02:00.0 VGA compatible controller: ATI Technologies Inc R580 [Radeon 
X1900] (prog-if 00 [VGA controller])
02:00.1 Display controller: ATI Technologies Inc Unknown device 7264

02:00.1 should be the card's second head I guess?

Here's the complete lspci -vv: http://realnc.pastebin.com/m6ac97572

