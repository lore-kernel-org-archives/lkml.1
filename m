Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZKRV2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZKRV2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZKRV2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:28:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38635 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757354AbZKRV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:28:43 -0500
Date: Wed, 18 Nov 2009 16:28:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
In-Reply-To: <4B0452D1.2050805@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0911181614010.2745-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Simon Arlott wrote:

> > You may have to do a bisection search to find the answer.
> 
> With what? I can't really bisect "the UHCI code" and "the OHCI code"...
> 
> I have no good kernel to work with unless I start trying really old kernels,
> but there's no reason why those should work either. I'm hoping someone
> recognises the significance of the transfer speed.

If you don't have a good kernel to start from then there's nothing to
search for.  I was assuming that a relatively recent kernel change
might have caused the slow-down, but if it has been this way for a long
time then a different approach is needed.

There's no particular significance to 256 ms that I know of, although
if the hardware is malfunctioning it could easily pick such a rate.  
The page size is significant because that's how the driver and the
hardware divide up transfers; each Transfer Descriptor refers to at 
most 4096 bytes of data.

> The OHCI code appears to split the data up into 4096 chunks, but even the
> odd sized transfer of 25280 bytes at the end runs at the same speed:
> 
> [ 4774.830569] cxacru: sending fw 0x3 size 0x62c0 to #98668
> [ 4776.410375] cxacru: sending fw 0x3 size 0x100 to #e0

Yep.  My intuition says "hardware problem", but there's no hard 
evidence one way or another.

What happens with other sorts of devices, such as a USB flash drive?

Alan Stern

