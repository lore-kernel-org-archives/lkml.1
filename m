Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZKRWZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZKRWZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZKRWZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:25:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37592 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752049AbZKRWZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:25:32 -0500
Date: Wed, 18 Nov 2009 17:25:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
In-Reply-To: <4B046E4C.7040205@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0911181711500.2745-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Simon Arlott wrote:

> > What happens with other sorts of devices, such as a USB flash drive?
>  
> On my desktop, I don't usually use the OHCI controller directly, but
> through hubs on EHCI. I do have an USB Audio device which works ok
> using OHCI.
> 
> The firmware load fails over EHCI (via a hub) despite running even faster:
> [89633.219403] cxacru: sending fw 0x3 size 0x8000 to #7000
> [89633.220147] cxacru: sending fw 0x3 size 0x8000 to #e000
> [89633.220530] cxacru: sending fw 0x3 size 0x8000 to #15000
> [89633.220774] cxacru: sending fw 0x3 size 0x8000 to #1c000
> [89633.220898] cxacru: sending fw 0x3 size 0x8000 to #23000
> [89633.221286] cxacru: sending fw 0x3 size 0x8000 to #2a000
> 
> 338µs per 32KB... which is 775mbit/s+ and doesn't make sense

It sure doesn't.  EHCI can't send bulk data faster than 52 KB/ms, which
is 615 us per 32 KB.  I wonder if the time values above are correct.

> I can write a 10MB file to an USB flash drive over OHCI, and umount+sync
> takes around 13 seconds.

Yes, that's about right.  It leads me to wonder if something funny is
going on with the device, or least with the firmware-loading part of
it.  Odd that it works differently with UHCI and OHCI, though.  There
shouldn't be any differences visible to the device.  You don't have
anything else attached to the same bus, do you?

Alan Stern

