Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZKVRQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZKVRQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZKVRQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:16:31 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:40289 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbZKVRQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:16:30 -0500
Message-ID: <4B0971F2.8020702@simon.arlott.org.uk>
Date: Sun, 22 Nov 2009 17:16:34 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
References: <Pine.LNX.4.44L0.0911221108150.27423-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911221108150.27423-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/09 16:14, Alan Stern wrote:
> On Sun, 22 Nov 2009, Simon Arlott wrote:
>> On 18/11/09 22:25, Alan Stern wrote:
>> > On Wed, 18 Nov 2009, Simon Arlott wrote:
>> >> > What happens with other sorts of devices, such as a USB flash drive?
>> >>  
>> >> I can write a 10MB file to an USB flash drive over OHCI, and umount+sync
>> >> takes around 13 seconds.
>> > 
>> > Yes, that's about right.  It leads me to wonder if something funny is
>> > going on with the device, or least with the firmware-loading part of
>> > it.  Odd that it works differently with UHCI and OHCI, though.  There
>> > shouldn't be any differences visible to the device.  You don't have
>> > anything else attached to the same bus, do you?
>> 
>> Yes, but not in use and I could disconnect everything to test it.
>> 
>> core/hcd.c has an interesting comment in usb_hcd_check_unlink_urb():
> 
> You mean usb_hcd_poll_rh_status().

Yes... misplaced paste from my other email.

>>         /* The USB 2.0 spec says 256 ms.  This is close enough and won't
>>          * exceed that limit if HZ is 100. The math is more clunky than
>>          * maybe expected, this is to make sure that all timers for USB devices
>>          * fire at the same time to give the CPU a break inbetween */
>> 
>> I'll try increasing the frequency of this timer too.
> 
> It shouldn't make any difference; that timer is used with OHCI only in 
> exceptional circumstances (like immediately after a device is plugged 
> in or unplugged), not during normal operation.  But maybe something 
> strange is going on.  You could add a printk in ohci_hub_status_data(), 
> which is the routine that timer ends up calling.

I've tried sending 64 and 2048 bytes at a time, with the same speed
(4ms and 128ms), so that time is just a coincidence.

Submitting it all as multiple asynchronous URBs in one go doesn't help
either. I've been trying to get EHCI working too (via two different
high speed hubs) but that's not working even if I add long delays.

-- 
Simon Arlott
