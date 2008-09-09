Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYIIE13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYIIE13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYIIE1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:27:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53421 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYIIE1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:27:20 -0400
Date: Mon, 8 Sep 2008 22:27:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Chiang <achiang@hp.com>, "Zhao, Yu" <yu.zhao@intel.com>,
       Greg KH <gregkh@suse.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI Hotplug: fakephp: fix deadlock... again
Message-ID: <20080909042703.GS2772@parisc-linux.org>
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080902000951.GM1239@parisc-linux.org> <20080902001905.GB14492@ldl.fc.hp.com> <200809082112.30457.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809082112.30457.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 09:12:29PM -0700, Jesse Barnes wrote:
> I don't have a preference here; whatever is most useful for people is probably 
> what we should go for.  Zhao?

I think we have two distinct groups of users; those who find emulating
slot hotplug useful, and those who want to hot-remove pci functions.
Maybe hot-removing a pci function should not be part of the pci hotplug
core per se -- obviously it would share much code -- but being able
to hot-remove a function is a fundamentally different thing from being
able to hot-remove a slot.  For example, hot-removing a function from a
device that is in a real hotplug slot should be possible, but it wouldn't
involve the driver for that hotplug slot.

So maybe what we want is a /sys/bus/pci/devices/dddd:bb:dd.f/remove file
that does just that.

Oh, and we also want a way to hot-add functions, not necessarily even
ones that have been removed from the machine after it was booted, but
those that show up after the machine has booted.  For example, one of
my former colleagues had a laptop which would remove the wireless pci
device from the bus if the rfkill switch was enabled.  I remember there
was a hack to load a module that called some pci bus rescan functionality.
I didn't look into it in much detail.

I don't have a firm idea about an interface for this.  SCSI handles it by
writing scsi-add-single-device H C T L to /proc/scsi/scsi.  Maybe we want
a /sys/bus/pci/scan or /sys/bus/pci/devices/scan file that we can echo
"0000:01:02.3" to scan just that function, or "0000:01:02" to scan the
device.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
