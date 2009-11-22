Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZKVK6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZKVK6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 05:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZKVK6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 05:58:48 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:35358 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbZKVK6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 05:58:47 -0500
Message-ID: <4B09196D.7040107@simon.arlott.org.uk>
Date: Sun, 22 Nov 2009 10:58:53 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
References: <Pine.LNX.4.44L0.0911181711500.2745-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911181711500.2745-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/11/09 22:25, Alan Stern wrote:
> On Wed, 18 Nov 2009, Simon Arlott wrote:
>> > What happens with other sorts of devices, such as a USB flash drive?
>>  
>> I can write a 10MB file to an USB flash drive over OHCI, and umount+sync
>> takes around 13 seconds.
> 
> Yes, that's about right.  It leads me to wonder if something funny is
> going on with the device, or least with the firmware-loading part of
> it.  Odd that it works differently with UHCI and OHCI, though.  There
> shouldn't be any differences visible to the device.  You don't have
> anything else attached to the same bus, do you?

Yes, but not in use and I could disconnect everything to test it.

core/hcd.c has an interesting comment in usb_hcd_check_unlink_urb():
        /* The USB 2.0 spec says 256 ms.  This is close enough and won't
         * exceed that limit if HZ is 100. The math is more clunky than
         * maybe expected, this is to make sure that all timers for USB devices
         * fire at the same time to give the CPU a break inbetween */

I'll try increasing the frequency of this timer too.

-- 
Simon Arlott
