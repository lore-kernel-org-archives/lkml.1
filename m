Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbXHCBsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbXHCBsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 21:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbXHCBsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 21:48:06 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:34789 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbXHCBsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 21:48:05 -0400
Date: Fri, 3 Aug 2007 02:47:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20070803014756.GA10392@srcf.ucam.org>
References: <20070802235613.GA9487@srcf.ucam.org> <20070803011505.GA32589@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803011505.GA32589@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] USB: Only enable autosuspend by default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 06:15:05PM -0700, Greg KH wrote:

> Well, if you do this, then you can pretty much delete the whole quirk
> table we have, right?

At the moment, yes.

> And personally, I want to do better than Windows XP when it comes to
> power management.  This patch is only going to suspend a very tiny
> subset of devices, including a whole bunch of ones that do not even have
> drivers in Linux, causing our power footprint to be bigger than needed.

I agree. I'd much rather see us suspending devices whenever possible - 
it's just that I have concerns over the scalability of the blacklist, 
given the number of devices that seem to have issues.

> Also, we have udev rules for SANE that disables their autosuspend
> settings, which handles the majority of the devices we have seen with
> problems.

Several printers seem to have the issue as well, and the blacklist seems 
to contain some odd miscellaneous devices like the Blackberry. The main 
concern I have is that kernel developers just don't tend to be the sort 
of people that use webcams, printers or scanners, so we're relying on 
normal users to go to the effort of reporting that their device has 
stopped working.

> So I really don't want to accept this patch.  But, what problems are you
> seeing with our current suspend logic that you feel we need to be this
> harsh?

It's definitely a brute force approach, but it's one that means that we 
get the low hanging fruit (ie, pretty much anything that's likely to be 
plugged into a laptop) while massively reducing the probability of 
breaking anyone's system. Saving some power is a nice win, but breaking 
someone's printer is a pretty big loss.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
