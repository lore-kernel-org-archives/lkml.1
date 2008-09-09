Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYIIFcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYIIFcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 01:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYIIFcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 01:32:22 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18616 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYIIFcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:32:21 -0400
Subject: Re: [PATCH] PCI Hotplug: fakephp: fix deadlock... again
From: Andrew Patterson <andrew.patterson@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Chiang <achiang@hp.com>,
       "Zhao, Yu" <yu.zhao@intel.com>, Greg KH <gregkh@suse.de>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080909042703.GS2772@parisc-linux.org>
References: <20080821201918.GA24411@ldl.fc.hp.com>
	 <20080902000951.GM1239@parisc-linux.org>
	 <20080902001905.GB14492@ldl.fc.hp.com>
	 <200809082112.30457.jbarnes@virtuousgeek.org>
	 <20080909042703.GS2772@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 05:32:18 +0000
Message-Id: <1220938338.6586.10.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 22:27 -0600, Matthew Wilcox wrote:
> On Mon, Sep 08, 2008 at 09:12:29PM -0700, Jesse Barnes wrote:
> > I don't have a preference here; whatever is most useful for people is probably 
> > what we should go for.  Zhao?
> 
> I think we have two distinct groups of users; those who find emulating
> slot hotplug useful, and those who want to hot-remove pci functions.
> Maybe hot-removing a pci function should not be part of the pci hotplug
> core per se -- obviously it would share much code -- but being able
> to hot-remove a function is a fundamentally different thing from being
> able to hot-remove a slot.  For example, hot-removing a function from a
> device that is in a real hotplug slot should be possible, but it wouldn't
> involve the driver for that hotplug slot.
> 
> So maybe what we want is a /sys/bus/pci/devices/dddd:bb:dd.f/remove file
> that does just that.
> 

of something like "disable", so we can enable it again?

> Oh, and we also want a way to hot-add functions, not necessarily even
> ones that have been removed from the machine after it was booted, but
> those that show up after the machine has booted.  For example, one of
> my former colleagues had a laptop which would remove the wireless pci
> device from the bus if the rfkill switch was enabled.  I remember there
> was a hack to load a module that called some pci bus rescan functionality.
> I didn't look into it in much detail.
> 
> I don't have a firm idea about an interface for this.  SCSI handles it by
> writing scsi-add-single-device H C T L to /proc/scsi/scsi.  Maybe we want
> a /sys/bus/pci/scan or /sys/bus/pci/devices/scan file that we can echo
> "0000:01:02.3" to scan just that function, or "0000:01:02" to scan the
> device.
> 

I like this idea. Even perhaps add a recursive scan to rescan behind a
bridge?

-- 
Andrew Patterson
Hewlett-Packard

