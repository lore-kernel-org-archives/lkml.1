Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbXHCBMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbXHCBMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 21:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXHCBMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 21:12:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbXHCBMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 21:12:30 -0400
Date: Thu, 2 Aug 2007 18:15:05 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-usb-devel@lists.sourceforge.net, amitk@ubuntu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Only enable autosuspend by default on certain
	device classes
Message-ID: <20070803011505.GA32589@suse.de>
References: <20070802235613.GA9487@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802235613.GA9487@srcf.ucam.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 12:56:13AM +0100, Matthew Garrett wrote:
> We're seeing a large number of problems with devices not appreciating 
> USB autosuspend, especially printers and scanners. According to 
> http://www.microsoft.com/whdc/system/bus/USB/USBFAQ_intro.mspx only a 
> subset of drivers support it in Windows XP, meaning that most devices 
> are probably untested in this situation. This patch alters the behaviour 
> to match that of Windows. Userspace can still whitelist devices as 
> appropriate, and the set of classes supporting autosuspend probably 
> covers pretty much every driver likely to be found on any portable 
> device.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

Well, if you do this, then you can pretty much delete the whole quirk
table we have, right?

And personally, I want to do better than Windows XP when it comes to
power management.  This patch is only going to suspend a very tiny
subset of devices, including a whole bunch of ones that do not even have
drivers in Linux, causing our power footprint to be bigger than needed.

Also, we have udev rules for SANE that disables their autosuspend
settings, which handles the majority of the devices we have seen with
problems.

So I really don't want to accept this patch.  But, what problems are you
seeing with our current suspend logic that you feel we need to be this
harsh?

thanks,

greg k-h
