Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZKRV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZKRV7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbZKRV7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:59:35 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:37641 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbZKRV7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:59:35 -0500
Message-ID: <4B046E4C.7040205@simon.arlott.org.uk>
Date: Wed, 18 Nov 2009 21:59:40 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
References: <Pine.LNX.4.44L0.0911181614010.2745-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911181614010.2745-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/11/09 21:28, Alan Stern wrote:
> If you don't have a good kernel to start from then there's nothing to
> search for.  I was assuming that a relatively recent kernel change
> might have caused the slow-down, but if it has been this way for a long
> time then a different approach is needed.

The earliest kernel I've had this happen with is 2.6.28-rc2, when I first
started using it with an OHCI controller.

> There's no particular significance to 256 ms that I know of, although
> if the hardware is malfunctioning it could easily pick such a rate.  
> The page size is significant because that's how the driver and the
> hardware divide up transfers; each Transfer Descriptor refers to at 
> most 4096 bytes of data.
> 
> On Wed, 18 Nov 2009, Simon Arlott wrote:
>> The OHCI code appears to split the data up into 4096 chunks, but even the
>> odd sized transfer of 25280 bytes at the end runs at the same speed:
>> 
>> [ 4774.830569] cxacru: sending fw 0x3 size 0x62c0 to #98668
>> [ 4776.410375] cxacru: sending fw 0x3 size 0x100 to #e0
> 
> Yep.  My intuition says "hardware problem", but there's no hard 
> evidence one way or another.
> 
> What happens with other sorts of devices, such as a USB flash drive?
 
On my desktop, I don't usually use the OHCI controller directly, but
through hubs on EHCI. I do have an USB Audio device which works ok
using OHCI.

The firmware load fails over EHCI (via a hub) despite running even faster:
[89633.219403] cxacru: sending fw 0x3 size 0x8000 to #7000
[89633.220147] cxacru: sending fw 0x3 size 0x8000 to #e000
[89633.220530] cxacru: sending fw 0x3 size 0x8000 to #15000
[89633.220774] cxacru: sending fw 0x3 size 0x8000 to #1c000
[89633.220898] cxacru: sending fw 0x3 size 0x8000 to #23000
[89633.221286] cxacru: sending fw 0x3 size 0x8000 to #2a000

338µs per 32KB... which is 775mbit/s+ and doesn't make sense.

I can write a 10MB file to an USB flash drive over OHCI, and umount+sync
takes around 13 seconds.

-- 
Simon Arlott
