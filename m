Return-Path: <linux-kernel-owner+w=401wt.eu-S1764268AbXKQSaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268AbXKQSaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbXKQS35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:29:57 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:14366 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778AbXKQS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:29:56 -0500
Date: Sat, 17 Nov 2007 11:29:54 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, achiang@hp.com, kristen.c.accardi@intel.com,
       lenb@kernel.org, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071117182954.GA25003@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is v3 of the pci_slot patch series.

The major change is making the ACPI-PCI slot driver a Kconfig
option, as per the recommendations of others (Gary, Kenji-san).
In the process of doing so, it made sense to collapse the former
3/5 and 4/5 patches into a single 3/4 patch. There really wasn't
a reason to introduce a pci_slot patch, and then immediately
follow it with another patch modifying its interface; logically,
the changes should have been in the same patch.

Combining the patches also has the nice side benefit of keeping
the tree fully buildable and bisectable at all stages of series.

I have done quite a bit more testing, and verified that this
series plays nicely with acpiphp during all stages of the series.
Notably, you can modprobe/rmmod acpiphp repeatedly no matter
where you are in the series, and no matter whether you have
CONFIG_ACPI_PCI_SLOT turned on. The correct entries in
/sys/bus/pci/slots/ will appear and disappear, and we correctly
register/deregister ACPI slots with the pci_hp core. 

Of course, if you *do* have the ACPI-PCI slot driver configured,
the slots/ entries in sysfs will be persistent. What you will see
is the hotplug attributes appear/disappear, depending on whether
you have acpiphp loaded or not.

Thanks for your consideration and all the feedback comments.
They're appreciated.

/ac

v2 -> v3:
  Patch 1/4 - no change
  Patch 2/4 - incorporate Eike's comments around snprintf
  Patch 3/4 - Separated slot creation and slot hotplug ability
              into two interfaces. Fixed bugs in pci_destroy_slot(), 
              and now properly calling from pci_hp_deregister.
  Patch 4/4 - Add Kconfig option to driver, allowing users to
              [de]config this driver. If configured, take slightly 
              different code paths in pci_hp_register and pci_hp_deregister.

v1 -> v2:
  Patch 1/5 - reworked to fix stupid compile bug
  Patch 2/5 - incorporate Eike, Linas, and Willy's comments
  Patch 3/5 - no change
  Patch 4/5 - was acpi-pci-slot-driver patch, now modifies
  	      pci_add_hotplug(). I changed the ordering on this so
  	      the tree doesn't break at this point in the series
  Patch 5/5 - now is acpi-pci-slot-driver patch, cleaned up
  	      implementation so our slot detection is a little
  	      better
