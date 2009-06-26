Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZFZE2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZFZE2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 00:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZFZE1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 00:27:51 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:57220 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZFZE1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 00:27:50 -0400
Date: Fri, 26 Jun 2009 00:27:02 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI & driver patches for 2.6.31-rc1
Message-id: <alpine.LFD.2.00.0906260025380.20608@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This includes a workaround for a just-merged oops regression --
reducing the bug's severity while we get a proper fix in place.

It also includes some driver-specific patches that were
staged for the merge window, but missed-the bus because
of upstream conflicts with patches from another tree.

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.31/acpi-release-20090521-2.6.31-rc1.diff.gz

 drivers/acpi/pci_root.c             |    2 +-
 drivers/platform/x86/Kconfig        |    2 +
 drivers/platform/x86/eeepc-laptop.c |  346 ++++++++++++++++++++++++-----------
 3 files changed, 239 insertions(+), 111 deletions(-)

through these commits:

Corentin Chary (6):
      eeepc-laptop: Register as a pci-hotplug device
      eeepc-laptop: rfkill refactoring
      eeepc-laptop: right parent device
      eeepc-laptop: makes get_acpi() returns -ENODEV
      eeepc-laptop: get the right value for CMSG
      eeepc-laptop: add rfkill support for the 3G modem in Eee PC 901 Go

Joe Perches (1):
      eeepc-laptop.c: use pr_fmt and pr_<level>

Troy Moure (1):
      ACPI: video: prevent NULL deref in acpi_get_pci_dev()

with this log:

commit 412af97838828bc6d035a1902c8974f944663da6
Author: Troy Moure <twmoure@szypr.net>
Date:   Thu Jun 25 17:05:35 2009 -0600

    ACPI: video: prevent NULL deref in acpi_get_pci_dev()
    
    ref: http://thread.gmane.org/gmane.linux.kernel/857228/focus=857468
    
    When the ACPI video driver initializes, it does a namespace walk
    looking for for supported devices. When we find an appropriate
    handle, we walk up the ACPI tree looking for a PCI root bus, and
    then walk back down the PCI bus, assuming that every device
    inbetween is a P2P bridge.
    
    This assumption is not correct, and is reported broken on at
    least:
    
    	Dell Latitude E6400
    	ThinkPad X61
    	Dell XPS M1330
    
    Add a NULL deref check to prevent boot panics.
    
    Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
    Signed-off-by: Troy Moure <twmoure@szypr.net>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3cd530b5aaffd27b231f9717730f2f6684c00bda
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Jun 25 13:25:42 2009 +0200

    eeepc-laptop: add rfkill support for the 3G modem in Eee PC 901 Go
    
    Signed-off-by: Janne Grunau <j@jannau.net>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dbfa3ba90dfe353a56e107cff5bce9fb7976f06f
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Jun 25 13:25:41 2009 +0200

    eeepc-laptop: get the right value for CMSG
    
    CMSG is an ACPI method used to find features available on
    an Eee PC. But some features are never repported, even if present.
    
    If the getter of a feature is present, this patch will set
    the corresponding bit in cmsg.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f36509e7248631671d02f48d1a88f56cdeb54ed8
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Jun 25 13:25:40 2009 +0200

    eeepc-laptop: makes get_acpi() returns -ENODEV
    
    If there is there is no getter defined, get_acpi()
    will return -ENODEV.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1ddec2f9435e77b4d3f50eced68c4c942f2bcd4b
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Jun 25 13:25:39 2009 +0200

    eeepc-laptop: right parent device
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7de39389d8f61aa517ce2a8b4d925acc62696ae5
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Jun 25 13:25:38 2009 +0200

    eeepc-laptop: rfkill refactoring
    
    Refactor rfkill code, because we'll add another
    rfkill for wwan3g later.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 19b532892834b7f1c04b2940ac73177dc566fed5
Author: Joe Perches <joe@perches.com>
Date:   Thu Jun 25 13:25:37 2009 +0200

    eeepc-laptop.c: use pr_fmt and pr_<level>
    
    Convert the unusual printk(EEEPC_<level> uses to
    the more standard pr_fmt and pr_<level>(.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b121bc262fa03c94e653b2d44356c2f86c1bcdc
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Thu Jun 25 13:25:36 2009 +0200

    eeepc-laptop: Register as a pci-hotplug device
    
    The eee contains a logically (but not physically) hotpluggable PCIe slot.
    Currently this is handled by adding or removing the PCI device in response
    to rfkill events, but if a user has forced pciehp to bind to it (with the
    force=1 argument) then both drivers will try to handle the event and
    hilarity (in the form of oopses) will ensue. This can be avoided by having
    eee-laptop register the slot as a hotplug slot. Only one of pciehp and
    eee-laptop will successfully register this, avoiding the problem.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Tested-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
