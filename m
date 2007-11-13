Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXKMAJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXKMAJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXKMAJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:09:07 -0500
Received: from palrel13.hp.com ([156.153.255.238]:49608 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbXKMAJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:09:05 -0500
Date: Mon, 12 Nov 2007 17:08:53 -0700
From: Alex Chiang <achiang@hp.com>
To: gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org
Cc: achiang@hp.com, matthew@wil.cx, richard.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113000853.GA13341@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx,
	richard.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[this patch series touches a few subsystems; hopefully I got all
the right maintainers]

Recently, Matthew Wilcox sent out the following mail about PCI
slots:

  http://marc.info/?l=linux-pci&m=119432330418980&w=2

The following patch series is a rough first cut at implementing
the ideas he outlined, namely, that PCI slots are physical
objects that we care about, independent of their hotplug
capabilities.

We introduce a struct pci_slot as a first-class citizen, and turn
hotplug_slot into a subsidiary structure. A brief glimpse at the
potential for cleanup is given, as we modify the existing hotplug
drivers and remove the multiple get_address() methods. Certainly
more cleanup can be done with this new structure.

Additionally, we introduce an ACPI PCI slot driver, which will
detect all physical PCI slots in the system (as described by
ACPI). De-coupling the notion of a physical slot from its hotplug
capability allows users to understand the physical geography of
their machines, whether their slots are hotpluggable or not.

This patch series builds heavily on Willy's prior work (with a
bit of the typical refresh needed when aiming at the moving
target of the kernel). The ACPI PCI slot driver is new.

I have tested this series on both ia64 (hp rx6600) and x86 (hp
dl380g). On ia64, system firmware provides _SUN methods for the
PCI slots and we get entries in /sys/bus/pci/slots/. On my x86
machine, firmware didn't seem to provide a _SUN, so we don't get
any entries in /sys/bus/pci/slots/, but nothing really bad
happens either. ;)

Comments/feedback are appreciated.

Thanks.

/ac

