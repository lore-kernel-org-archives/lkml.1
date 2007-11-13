Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbXKMV6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbXKMV6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbXKMV6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:58:34 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:58548 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762712AbXKMV6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:58:33 -0500
Date: Tue, 13 Nov 2007 14:58:30 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Alex Chiang <achiang@hp.com>, Greg KH <greg@kroah.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113215830.GM17785@parisc-linux.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113202424.GE8421@austin.ibm.com> <20071113205939.GC22812@ldl.fc.hp.com> <20071113214121.GC8509@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113214121.GC8509@austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 03:41:21PM -0600, Linas Vepstas wrote:
> /sys/bus/pci/slots
> /sys/bus/pci/slots/control
> /sys/bus/pci/slots/control/remove_slot
> /sys/bus/pci/slots/control/add_slot
> /sys/bus/pci/slots/0001:00:02.0
> /sys/bus/pci/slots/0001:00:02.0/phy_location

Ugh.  Almost two years ago, paulus promised me he was going to fix the
slot name for rpaphp.  Guess he didn't.

This is one of the hateful things about the current design -- hotplug
drivers do too much.  Instead of being just the interface between the
Linux PCI code and the hardware, they create sysfs directories, add files,
and generally have far too much freedom.

We have four different schemes currently for naming in slots/,
1. slot number.  Used by cpqphp, ibmphp, acpiphp, pciehp, shpc.
2. domain:bus:dev:fn.  Used by fakephp.
3a. domain:bus:dev.  Used by rpaphp and sgihp.
3b. Except that rpaphp uses phy_location to present the information that
should be in the name and sgihp uses path.

... I've forgotten what cpci uses.  And yenta doesn't use it.

How is anyone supposed to write sane managability tools in the presence
of such anarchy?

> ~ # cat /sys/bus/pci/slots/0000:00:02.2/phy_location
> U787A.001.DNZ00Z5-P1-C2

Right.  This should look like:

# cat /sys/bus/pci/slots/U787A.001.DNZ00Z5-P1-C2/address
0000:00:02

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
