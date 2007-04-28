Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXD1PFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXD1PFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXD1PFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:05:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:34805 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbXD1PFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:05:45 -0400
Date: Sat, 28 Apr 2007 17:06:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Vincent ETIENNE <ve@vetienne.net>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Paul Walmsley <paul@booyaka.com>, linux-usb-devel@lists.sourceforge.net
Subject: Re: USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
In-Reply-To: <200704280921.19265.ve@vetienne.net>
Message-ID: <Pine.LNX.4.64.0704281702480.7370@jikos.suse.cz>
References: <200704262058.33087.ve@vetienne.net> <20070427211836.GC5917@kroah.com>
 <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz> <200704280921.19265.ve@vetienne.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Vincent ETIENNE wrote:

> > I now don't immediately see how this could happen - the vendor ID 
> > seems to be propagated properly from hid_probe() (nothing has been 
> > changed in this codepath), so this would mean that hid_probe() has 
> > been passed usb_interface for which 
> > le16_to_cpu(interface_to_usbdev(intf).dev->descriptor.idVendor) is 
> > equal to zero ...  and this definitely shouldn't happen for any sane 
> > device (could the original poster please verify with lsusb, just to be 
> > 100% sure?).
> You could download the result of lsusb -vvv from 
> http://mail1.vetienne.net/linux/lsusb.log

Hi Vincent,

thanks for the report. It's pretty awesome though - all the USB devices 
seem to have vendor and product id set to 0x0000. Greg, have you ever met 
this? 

linux-usb-devel added to CC (full thread here: 
http://lkml.org/lkml/2007/4/27/496)

So this definitely isn't a HID-specific problem, something is confusing 
the USB VID/PIDs.

-- 
Jiri Kosina
SUSE Labs
