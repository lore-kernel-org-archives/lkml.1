Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZHNWWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZHNWWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZHNWWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:22:02 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49005 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbZHNWWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:22:01 -0400
Date: Fri, 14 Aug 2009 23:21:57 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Message-ID: <20090814222157.GA20015@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0908141032070.2987-100000@iolanthe.rowland.org> <200908142205.20093.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908142205.20093.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 10:05:19PM +0200, Rafael J. Wysocki wrote:

> Well, sometimes the user may want a device to be power managed at run time
> and not to be able to wake up the system from sleep states.  For example,
> I'd like the USB controller in my box to be suspended at run time whenever it's
> not used, but surely I wouldn't like it to do system-wide wakeup, because it
> does that when I move the mouse which is a cordless one.  Simply turning the
> mouse on causes the system to wake up. :-)

Right, so clearly my code is broken right now.

> Why don't we add a flag indicating whether or not the device is allowed to
> be power managed at run time, something like runtime_forbidden, that the
> user space will be able to set through sysfs?

I think even having a runtime_wakeup flag (which defaults to on) would 
be sufficient. If the worst case is scenario is that we have to resume 
devices in order to apply the correct policy when going into a 
systemwide suspend state, I think that's acceptable.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
