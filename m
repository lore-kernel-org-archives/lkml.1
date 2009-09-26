Return-Path: <linux-kernel-owner+w=401wt.eu-S1750890AbZIZFUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890AbZIZFUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 01:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZIZFUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 01:20:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:41056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZIZFUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 01:20:06 -0400
Date: Sat, 26 Sep 2009 05:19:53 GMT
From: Len Brown <lenb@hera.kernel.org>
Message-Id: <200909260519.n8Q5JrB6016778@hera.kernel.org>
To: torvalds@linux-foundation.org
Subject: [git pull request] ACPI related patches for 2.6.32-rc0 - part 2
Cc: akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 26 Sep 2009 05:20:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This batch includes the small patch to fix the recent acpiphp_ibm oops,
that we caused with the previous batch....

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.31/acpi-release-20090903-2.6.31.diff.gz

 Documentation/laptops/thinkpad-acpi.txt |   48 ++-
 drivers/acpi/bus.c                      |   49 +--
 drivers/acpi/scan.c                     |  705 ++++++++++++-------------------
 drivers/pci/hotplug/acpiphp_ibm.c       |    1 -
 drivers/platform/x86/thinkpad_acpi.c    |  632 +++++++++++++++++++---------
 drivers/pnp/pnpacpi/core.c              |   21 +-
 include/acpi/acpi_bus.h                 |   22 +-
 7 files changed, 768 insertions(+), 710 deletions(-)

through these commits:

Bjorn Helgaas (25):
      ACPICA: fixup after acpi_get_object_info() change
      ACPI: add debug for device addition
      ACPI: remove unused acpi_bus_scan_fixed() argument
      ACPI: remove redundant "handle" and "parent" arguments
      ACPI: save device_type in acpi_device
      ACPI: use device_type rather than comparing HID
      ACPI: remove acpi_device_set_context() "type" argument
      ACPI: remove redundant "type" arguments
      ACPI: remove unnecessary argument checking
      ACPI: add acpi_bus_get_parent() and remove "parent" arguments
      ACPI: convert acpi_bus_scan() to operate on an acpi_handle
      ACPI: enumerate namespace before adding functional fixed hardware devices
      ACPI: identify device tree root by null parent pointer, not ACPI_BUS_TYPE
      ACPI: use acpi_walk_namespace() to enumerate devices
      ACPI: add acpi_bus_get_status_handle()
      ACPI: factor out device type and status checking
      ACPI: handle re-enumeration, when acpi_devices might already exist
      ACPI: fix synthetic HID for \_SB_
      ACPI: use acpi_device_hid() when possible
      ACPI: make sure every acpi_device has an ID
      ACPI: maintain a single list of _HID and _CID IDs
      ACPI: remove acpi_device.flags.compatible_ids
      ACPI: remove acpi_device.flags.hardware_id
      ACPI: remove acpi_device_uid() and related stuff
      ACPI: simplify building device HID/CID list

Henrique de Moraes Holschuh (6):
      thinkpad-acpi: don't leave ERR_PTR() pointers around
      thinkpad-acpi: remove uneeded tp_features.hotkey tests in hotkey_exit
      thinkpad-acpi: drop HKEY event 0x5010
      thinkpad-acpi: hotkey event driver update
      thinkpad-acpi: add internal hotkey event API
      thinkpad-acpi: name event constants

with this log:

commit 2b474ad8473f57c2930b2bda6c397c3aa8d97896
Merge: ea26105 67bcae6
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 26 01:08:55 2009 -0400

    Merge branch 'thinkpad-2.6.32-part2' into release

commit ea2610515755614da76677185349c66880c1e84d
Merge: 6d7f18f 57f3674
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 26 01:08:43 2009 -0400

    Merge branch 'bjorn-HID' into release

commit 57f3674f5e9c7b1102ae62fc2920d2fa09fce1ea
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 13:35:40 2009 -0600

    ACPI: simplify building device HID/CID list
    
    Minor code cleanup, no functional change.  Instead of remembering
    what HIDs & CIDs to add later, just add them immediately.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6622d8cee73a26bce958484065c8f0e704911a62
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 13:35:35 2009 -0600

    ACPI: remove acpi_device_uid() and related stuff
    
    Nobody uses acpi_device_uid(), so this patch removes it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1131b938f0757350f569f8ad5bee737cd02b8e58
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 13:35:29 2009 -0600

    ACPI: remove acpi_device.flags.hardware_id
    
    Every acpi_device has at least one ID (if there's no _HID or _CID, we
    give it a synthetic or default ID).  So there's no longer a need to
    check whether an ID exists; we can just use it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2972f87508a21db7584d11fdb5c97cb7101a788
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 13:35:24 2009 -0600

    ACPI: remove acpi_device.flags.compatible_ids
    
    We now keep a single list of IDs that includes both the _HID and any
    _CIDs.  We no longer need to keep track of whether the device has a _CID.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f47fa6c2ff15f5e59cdbb350f86faef6829294a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 13:35:19 2009 -0600

    ACPI: maintain a single list of _HID and _CID IDs
    
    There's no need to treat _HID and _CID differently.  Keeping them in
    a single list makes code that uses the IDs a little simpler because it
    can just traverse the list rather than checking "do we have a HID?",
    "do we have any CIDs?"
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reviewed-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b1fbfb2ae8f2f0e04219218da6f52f7313466899
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 13:35:14 2009 -0600

    ACPI: make sure every acpi_device has an ID
    
    This makes sure every acpi_device has at least one ID.  If we build an
    acpi_device for a namespace node with no _HID or _CID, we sometimes
    synthesize an ID like "LNXCPU" or "LNXVIDEO".  If we don't even have
    that, give it a default "device" ID.
    
    Note that this means things like:
        /sys/devices/LNXSYSTM:00/LNXSYBUS:00/HWP0001:00/HWP0002:04/device:00
    (a PCI slot SxFy device) will have "hid" and "modprobe" entries, where
    they didn't before.  These aren't very useful (a HID of "device" doesn't
    tell you what *kind* of device it is, so it doesn't help find a driver),
    but I don't think they're harmful.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ea8d82fd316208bd0ffe6f64823d04bcb8c57158
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 13:35:09 2009 -0600

    ACPI: use acpi_device_hid() when possible
    
    Use acpi_device_hid() rather than accessing acpi_device.pnp.hardware_id
    directly.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 78b8e141f8458ba0b8ac53c45bc327112c53887e
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 13:35:04 2009 -0600

    ACPI: fix synthetic HID for \_SB_
    
    This makes \_SB_ show up as /sys/devices/LNXSYSTM:00/LNXSYBUS:00
    rather than "device:00".  This has been broken for a loooong time
    (at least since 2.6.13) because device->parent is an acpi_device
    pointer, not a handle.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e3b87f8a9d5a61f6367c66d1bb0a4e19d251194d
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:30:11 2009 +0000

    ACPI: handle re-enumeration, when acpi_devices might already exist
    
    acpi_bus_scan() traverses the namespace to enumerate devices and uses
    acpi_add_single_object() to create acpi_devices.  When the platform
    notifies us of a hot-plug event, we need to traverse part of the namespace
    again to figure out what appeared or disappeared.  (We don't yet call
    acpi_bus_scan() during hot-plug, but I plan to do that in the future.)
    
    This patch makes acpi_add_single_object() notice when we already have
    an acpi_device, so we don't need to make a new one.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 778cbc1d3abd434b6d882714630235e3711bb15b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:30:06 2009 +0000

    ACPI: factor out device type and status checking
    
    This patch adds acpi_bus_type_and_status(), which determines the type
    of the object and whether we want to build an acpi_device for it.  If
    it is acpi_device-worthy, it returns the type and the device's current
    status.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 402ac53614bce0c273c73a80339556bf56dd3d39
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:30:01 2009 +0000

    ACPI: add acpi_bus_get_status_handle()
    
    Add acpi_bus_get_status_handle() so we can get the status of a namespace
    object before building a struct acpi_device.
    
    This removes a use of "device->flags.dynamic_status", a cached indicator of
    whether _STA exists.  It seems simpler and more reliable to just evaluate
    _STA and catch AE_NOT_FOUND errors.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 51a85faf2d4ffecd8384b3f501f9f7ee2b05ee53
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:56 2009 +0000

    ACPI: use acpi_walk_namespace() to enumerate devices
    
    acpi_bus_scan() currently walks the namespace manually.  This patch changes
    it to use acpi_walk_namespace() instead.
    
    Besides removing some complicated code, this means we take advantage of the
    namespace locking done by acpi_walk_namespace().  The locking isn't so
    important at boot-time, but I hope to eventually use this same path to
    handle hot-addition of devices, when it will be important.
    
    Note that acpi_walk_namespace() does not actually visit the starting node
    first, so we need to do that by hand first.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 859ac9a4be0c753cece0e30a2e4a65fd2cdcaeee
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:50 2009 +0000

    ACPI: identify device tree root by null parent pointer, not ACPI_BUS_TYPE
    
    We can identify the root of the ACPI device tree by the fact that it
    has no parent.  This is simpler than passing around ACPI_BUS_TYPE_SYSTEM
    and will help remove special treatment of the device tree root.
    
    Currently, we add the root by hand with ACPI_BUS_TYPE_SYSTEM.  If we
    traverse the tree treating the root as just another device and use
    acpi_get_type(), the root shows up as ACPI_TYPE_DEVICE.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit adc08e2035f1859d4b129f42b2c2305ef090d226
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:45 2009 +0000

    ACPI: enumerate namespace before adding functional fixed hardware devices
    
    This patch changes the order so we enumerate in the "root, namespace,
    functional fixed" order instead of the "root, functional fixed, namespace"
    order.  When I change acpi_bus_scan() to use acpi_walk_namespace(), it
    will use the former order, so this patch isolates the order change for
    bisectability.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8e029bf0a611ea3995bd1fae0285cbaf6eed7f16
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:40 2009 +0000

    ACPI: convert acpi_bus_scan() to operate on an acpi_handle
    
    This patch changes acpi_bus_scan() to take an acpi_handle rather than an
    acpi_device pointer.  I plan to use acpi_bus_scan() in the hotplug path,
    and I'd rather not assume that notifications only go to nodes that already
    have acpi_devices.
    
    This will also help remove the special case for adding the root node.  We
    currently add the root by hand before acpi_bus_scan(), but using a handle
    here means we can start the acpi_bus_scan() directly with the root even
    though it doesn't have an acpi_device yet.
    
    Note that acpi_bus_scan() currently adds and/or starts the *children* of
    its device argument.  It doesn't do anything with the device itself.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5c478f499c9e6a3ac542c940f7b434686f4967a5
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:35 2009 +0000

    ACPI: add acpi_bus_get_parent() and remove "parent" arguments
    
    This patch adds acpi_bus_get_parent(), which ascends the namespace until
    it finds a parent with an acpi_device.
    
    Then we use acpi_bus_get_parent() in acpi_add_single_object(), so callers
    don't have to figure out or keep track of the parent acpi_device.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 77c24888b7693eecee904308e0ee51f7f1f564df
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:30 2009 +0000

    ACPI: remove unnecessary argument checking
    
    acpi_add_single_object() is static, and all callers supply a valid "child"
    argument, so we don't need to check it.  This patch also remove some
    unnecessary initializations.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c7bcb4e98aca348f6f8ab432496ff35ba7a49a1d
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:25 2009 +0000

    ACPI: remove redundant "type" arguments
    
    We now save the ACPI bus "device_type" in the acpi_device structure, so
    we don't need to pass it around explicitly anymore.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bc3b07726aa288e2a5e60d9a1dd8188b3faa7385
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:20 2009 +0000

    ACPI: remove acpi_device_set_context() "type" argument
    
    We only pass the "type" to acpi_device_set_context() so we know whether
    the device has a handle to which we can attach the acpi_device pointer.
    But it's safer to just check for the handle directly, since it's in the
    acpi_device already.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ccba2a36d74a9da815e597ac727cfd096fa8e750
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:15 2009 +0000

    ACPI: use device_type rather than comparing HID
    
    Check the acpi_device device_type rather than the HID.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit caaa6efb3d82d0102db9e7094ca5773c46e6780c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:10 2009 +0000

    ACPI: save device_type in acpi_device
    
    Most uses of the ACPI bus device_type (ACPI_BUS_TYPE_DEVICE,
    ACPI_BUS_TYPE_POWER, etc) are during device initialization, but
    we do need it later for notify handler installation, since that
    is different for fixed hardware devices vs. namespace devices.
    
    This patch saves the device_type in the acpi_device structure,
    so we can check that rather than comparing against the _HID string.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66b7ed40aaf153d634aabff409a0dda675f37f45
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:29:05 2009 +0000

    ACPI: remove redundant "handle" and "parent" arguments
    
    In several cases, functions take handle and parent device pointers in
    addition to acpi_device pointers.  But the acpi_device structure contains
    both the handle and the parent pointer, so it's pointless and error-prone
    to pass them all.  This patch removes the unnecessary "handle" and "parent"
    arguments.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e8b945c9c155d06e1d1ea594f8e18e01aa36f612
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:28:59 2009 +0000

    ACPI: remove unused acpi_bus_scan_fixed() argument
    
    We never use the "root" argument, so just remove it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 29aaefa68f933110e577fbf3ca360c88331e5ff5
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:28:54 2009 +0000

    ACPI: add debug for device addition
    
    Add debug output for adding an ACPI device.  Enable this with
    "acpi.debug_layer=0x00010000" (ACPI_BUS_COMPONENT).
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b24715027aab5e586c4ab1d035f3e543307dea69
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Sep 21 19:28:49 2009 +0000

    ACPICA: fixup after acpi_get_object_info() change
    
    Commit 15b8dd53f5ffa changed info->hardware_id from a static array to
    a pointer.  If hardware_id is non-NULL, it points to a NULL-terminated
    string, so we don't need to terminate it explicitly.  However, it may
    be NULL; in that case, we *can't* add a NULL terminator.
    
    This causes a NULL pointer dereference oops for devices without _HID.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    CC: Lin Ming <ming.m.lin@intel.com>
    CC: Bob Moore <robert.moore@intel.com>
    CC: Gary Hade <garyhade@us.ibm.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 67bcae6ee8e111f3343bc89345883024ba230a3b
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 20 14:09:27 2009 -0300

    thinkpad-acpi: name event constants
    
    Reduce the number of magic numbers in the driver... note that they
    were all explained and documented already.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8b468c0c85f41c4c55227c17271b4187d8911fb0
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 20 14:09:26 2009 -0300

    thinkpad-acpi: add internal hotkey event API
    
    Add an internal API to the driver, to allow subdrivers to request and
    receive HKEY 0x1000 events.  This API will be used by the backlight
    (brightness up/down) and upcoming ALSA mixer (volume up/down/mute)
    subdrivers.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0d922e3b84dc4923fc67901580a3c166006fba7a
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 20 14:09:25 2009 -0300

    thinkpad-acpi: hotkey event driver update
    
    Update the HKEY event driver to:
    
    1. Handle better the second-gen firmware, which has no HKEY mask
       support but does report FN+F3, FN+F4 and FN+F12 without the need
       for NVRAM polling.
    
       a) always make the mask-related attributes available in sysfs;
       b) use DMI quirks to detect the second-gen firmware;
       c) properly report that FN+F3, FN+F4 and FN+F12 are enabled,
          and available even on mask-less second-gen firmware;
    
    2. Decouple the issuing of hotkey events towards userspace from
       their reception from the firmware.  ALSA mixer and brightness
       event reporting support will need this feature.
    
    3. Clean up the mess in the hotkey driver a great deal.  It is
       still very convoluted, and wants a full refactoring into a
       proper event API interface, but that is not going to happen
       today.
    
    4. Fully reset firmware interface on resume (restore hotkey
       mask and status).
    
    5. Stop losing polled events for no good reason when changing the
       mask and poll frequencies.  We will still lose them when the
       hotkey_source_mask is changed, as well as any that happened
       between driver suspend and driver resume.
    
    The hotkey subdriver now has the notion of user-space-visible hotkey
    event mask, as well as of the set of "hotkey" events the driver needs
    (because brightness/volume change reports are not just keypress
    reports in most ThinkPad models).
    
    With this rewrite, the ABI level is bumped to 0x020500 should
    userspace need to know it is dealing with the updated hotkey
    subdriver.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 176dd98523fee4836210bc0834c8e3e6a93247bf
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 20 14:09:24 2009 -0300

    thinkpad-acpi: drop HKEY event 0x5010
    
    HKEY event 0x5010 is useless to us: old ThinkPads don't issue it.  Newer
    ThinkPads won't issue it anymore.  And all ThinkPads issue 0x1010 and
    0x1011 events.
    
    Just silently drop it instead of sending it to userspace.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4be73005e4dcf111fa88f7265ed147e2de38b075
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 20 14:09:23 2009 -0300

    thinkpad-acpi: remove uneeded tp_features.hotkey tests in hotkey_exit
    
    hotkey_exit() is only called if hotkey_init() finished sucessfully, or
    by direct calls inside hotkey_init().  The tp_features.hotkey test is
    always true, and just adds to the confusion, remove it.  Also, avoid
    calling hotkey_mask_set() when it won't do anything useful.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 435c47e20bc212d0fa6652ac93fae8eaee7b9b34
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Sep 20 14:09:22 2009 -0300

    thinkpad-acpi: don't leave ERR_PTR() pointers around
    
    backlight_device_register returns ERR_PTR() in case of problems, and
    the current code would leave that ERR_PTR in ibm_backlight_device.
    
    The current code paths won't touch it in that situation, but that could
    change.  Make sure to set ibm_backlight_device to NULL in the error
    path.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>
