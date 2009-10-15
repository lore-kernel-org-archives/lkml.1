Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbZJOFDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbZJOFDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 01:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZJOFDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 01:03:45 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:53809 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZJOFDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 01:03:44 -0400
Date: Thu, 15 Oct 2009 01:02:58 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI & platform driver related patches for
 2.6.32-rc4
Message-id: <alpine.LFD.2.00.0910150101030.16172@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
A regression fix from Rafael, plus some other misc fixes.

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.32/acpi-release-20090903-2.6.32-rc4.diff.gz

 drivers/acpi/Kconfig                  |    4 ++--
 drivers/acpi/ac.c                     |    1 +
 drivers/acpi/button.c                 |    3 +++
 drivers/acpi/pci_root.c               |   11 +++++++++++
 drivers/acpi/video.c                  |    7 ++++++-
 drivers/acpi/video_detect.c           |    2 +-
 drivers/platform/x86/eeepc-laptop.c   |   31 +++++++++++++++++++++----------
 drivers/platform/x86/fujitsu-laptop.c |    2 +-
 8 files changed, 46 insertions(+), 15 deletions(-)

through these commits:

Darren Salt (1):
      eeepc-laptop: Prevent a panic when disabling RT2860 wireless when associated

Jesse Barnes (1):
      ACPI button: don't try to use a non-existent lid device

Jiri Slaby (1):
      ACPI: Kconfig, fix proc aggregator text

Jonathan Woithe (1):
      fujitsu-laptop: address missed led-class ifdef fixup

Mark Langsdorf (1):
      ACPI: add AC/DC notifier

Rafael J. Wysocki (1):
      ACPI / PCI: Fix NULL pointer dereference in acpi_get_pci_dev() (rev. 2)

Rakib Mullick (1):
      eeepc-laptop: Properly annote eeepc_enable_camera().

Stefan Bader (1):
      ACPI: video: Loosen strictness of video bus detection code

with this log:

commit d59733c1e56784a99381799021c4f9698f3e6379
Merge: 4697fd6 2c907b7
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 15 00:47:13 2009 -0400

    Merge branch 'misc' into release

commit 4697fd6f6a6277b33093fc807786f16cabe30b31
Merge: fee807e 3a1151e
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 15 00:46:57 2009 -0400

    Merge branch 'launchpad-333386' into release

commit fee807e8ffef7a0cdec3ff2d7156844c7d987d2f
Merge: f63a904 b56ab33
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 15 00:46:46 2009 -0400

    Merge branch 'eeepc-laptop' into release

commit f63a904891de9da7828b3eb6c99c45a26ec5b475
Merge: a3ccf63 497fb54
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 15 00:45:37 2009 -0400

    Merge branch 'bugzilla-14129' into release

commit 2c907b72db4dd4e8af6dccb6e0ac122d78627b8d
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Oct 7 14:39:46 2009 -0700

    ACPI button: don't try to use a non-existent lid device
    
    If a call comes in to check the lid state but there's no lid device
    present, we should return -ENODEV.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
Author: Stefan Bader <stefan.bader@canonical.com>
Date:   Fri Aug 21 11:03:05 2009 +0200

    ACPI: video: Loosen strictness of video bus detection code
    
    BugLink: http://bugs.launchpad.net/bugs/333386
    
    Currently a video bus device must (beside other criteria) define _DOD and
    _DOS methods to be considered a video device.
    Some broken BIOSes prevented working backlight control by only defining both
    for one (non-existing bus) and only _DOD for the rest. With this patch in
    place the other bus definitions were considered too and backlight control
    started to work again.
    
    Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b56ab33d68638e6aafdbfc694025e8354a628f49
Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date:   Tue Oct 13 00:13:33 2009 +0200

    eeepc-laptop: Prevent a panic when disabling RT2860 wireless when associated
    
    This works around what I think is actually a bug in rt2860sta which is
    triggered when the hardware "disappears" from beneath the driver, i.e. when
    wireless is toggled off via ACPI. It does so by ensuring that the rfkill
    soft-block flag is set before the hardware is disabled.
    
    I do not know whether this patch is required if rt2800pci is in use instead
    of rt2860sta; at the time of submission of this patch, I've not been able to
    test this.
    
    (Ref. http://bugzilla.kernel.org/show_bug.cgi?id=13390)
    
    Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dcb73eed70575c68f1389f7fac7cbd0feaeb50f3
Author: Rakib Mullick <rakib.mullick@gmail.com>
Date:   Tue Oct 13 00:13:32 2009 +0200

    eeepc-laptop: Properly annote eeepc_enable_camera().
    
    Currently the annotation for function eeepc_enable_camera() is
    __init, and refers to a
    function eeepc_hotk_add() which is non-init. Use __devinit for both
    functions which is
    more appropriate and fixes a section mismatch warning.
    
     We were warned by the following warning:
    
      LD      drivers/platform/x86/built-in.o
    WARNING: drivers/platform/x86/built-in.o(.text+0x12e1): Section
    mismatch in reference from the function eeepc_hotk_add() to the
    function .init.text:eeepc_enable_camera()
    The function eeepc_hotk_add() references
    the function __init eeepc_enable_camera().
    This is often because eeepc_hotk_add lacks a __init
    annotation or the annotation of eeepc_enable_camera is wrong.
    
    Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 497fb54f578efd2b479727bc88d5ef942c0a1e2d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Oct 13 01:01:57 2009 +0200

    ACPI / PCI: Fix NULL pointer dereference in acpi_get_pci_dev() (rev. 2)
    
    acpi_get_pci_dev() may be called for a non-PCI device, in which case
    it should return NULL.  However, it assumes that every handle it
    finds in the ACPI CA name space, between given device handle and the
    PCI root bridge handle, corresponds to a PCI-to-PCI bridge with an
    existing secondary bus.  For this reason, when it finds a struct
    pci_dev object corresponding to one of them, it doesn't check if
    its 'subordinate' field is a valid pointer.  This obviously leads to
    a NULL pointer dereference if acpi_get_pci_dev() is called for a
    non-PCI device with a PCI parent which is not a bridge.
    
    To fix this issue make acpi_get_pci_dev() check if pdev->subordinate
    is not NULL for every device it finds on the path between the root
    bridge and the device it's supposed to get to and return NULL if the
    "target" device cannot be found.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14129
    (worked in 2.6.30, regression in 2.6.31)
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-by: Danny Feng <dfeng@redhat.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    Tested-by: chepioq <chepioq@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2906206350b7e13e2047467cc29a0a2d78d71cb2
Author: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Date:   Thu Oct 8 13:19:12 2009 +0930

    fujitsu-laptop: address missed led-class ifdef fixup
    
    A follow-up 2.6.32-rc1's
    
    1e384cb0f9a940f2a431d1708f963987e61d71e3
    "fujitsu-laptop: support led-class as module"
    
    It's a trivial fix for one of the CONFIG_LEDS_CLASS ifdefs
    which was somehow missed in the original patch.
    
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c4c4e2a58996d774429ded2fe386e88b47a10e98
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Fri Oct 9 15:53:24 2009 +0200

    ACPI: Kconfig, fix proc aggregator text
    
    Fix two typos in the Kconfig text about ACPI_PROCESSOR_AGGREGATOR.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 68b92b567c0c5e6f4d0b264d438f97ee5ccbdccc
Author: Mark Langsdorf <mark.langsdorf@amd.com>
Date:   Tue Aug 11 15:15:42 2009 -0500

    ACPI: add AC/DC notifier
    
    Add an ACPI event notifier for AC/DC connect/disconnect events.
    
    Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
