Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbXHCOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbXHCOeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762275AbXHCOeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:34:12 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:59919 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762266AbXHCOeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:34:11 -0400
Date: Fri, 3 Aug 2007 15:33:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, Rogan Dawes <lists@dawes.za.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20070803143338.GA19713@srcf.ucam.org>
References: <20070803140909.GA19245@srcf.ucam.org> <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 10:28:19AM -0400, Alan Stern wrote:
> On Fri, 3 Aug 2007, Matthew Garrett wrote:

> There are two possible solutions, both involving the kernel (since
> userspace can't respond in time).  One is to change the default timeout
> to something larger, or even disable it completely.  Then people would
> need to rely on userspace tools to enable autosuspend on known-good
> devices.  The other possibility is to have a fairly reliable blacklist
> or whitelist and again rely on userspace to manage edge cases.  This is 
> of course more flexible than a blanket default setting, but it's still 
> pretty rigid.  On the other hand, a blacklist can't be changed without 
> rebuilding the kernel whereas the default timeout can be adjusted on 
> the boot command line.

Windows will autosuspend hubs, bluetooth devices, HID devices and CDC 
devices, so I think we're safe suspending those by default. I'm not so 
enthusiastic about the "Increase the timeout case" - it doesn't avoid 
any races, just makes them less likely. USB is likely to get loaded in 
the initramfs, but we may not have a full set of udev rules until the 
root fs is up and that can take an effectively arbitrarily large amount 
of time.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
