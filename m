Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbZJCFkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbZJCFkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 01:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZJCFkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 01:40:19 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:49420 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZJCFkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 01:40:17 -0400
Date: Sat, 03 Oct 2009 01:40:18 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI patches for 2.6.32-rc1
Message-id: <alpine.LFD.2.00.0910030135090.25240@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

The sony-laptop update is some driver-specific patches I failed to get in 
during the merge window.  Then there are a couple of 2.6.31-rc1 regression 
fixes, Some EC bug-fixes/workarounds, etc.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.32/acpi-release-20090903-2.6.32-rc2.diff.gz

 drivers/acpi/dock.c                |   16 ++--
 drivers/acpi/ec.c                  |   56 +++++++++++++---
 drivers/acpi/proc.c                |    2 +
 drivers/acpi/processor_core.c      |    7 --
 drivers/acpi/scan.c                |    7 +--
 drivers/platform/x86/sony-laptop.c |  127 +++++++++++++++---------------------
 6 files changed, 112 insertions(+), 103 deletions(-)

through these commits:

Alan Jenkins (1):
      sony-laptop: Don't unregister the SPIC driver if it wasn't registered

Alex Chiang (1):
      ACPI: dock: fix "sibiling" typo

Alexey Starikovskiy (3):
      ACPI: EC: Restart command even if no interrupts from EC
      ACPI: EC: Rewrite DMI checks
      ACPI: EC: Don't parse DSDT for EC early init on Compal

Arjan van de Ven (1):
      ACPI: Fix bound checks for copy_from_user in the acpi /proc code

Bjorn Helgaas (1):
      ACPI: fix bus scanning memory leaks

Mattia Dongili (3):
      sony-laptop: remove device_ctrl and the SPIC mini drivers
      sony-laptop: SPIC unset IRQF_SHARED, set IRQF_DISABLED
      sony-laptop: remove _INI call at init time

Roland Dreier (1):
      ACPI: kill overly verbose "throttling states" log messages

with this log:

commit c7db7ba5fc84e76044f403efbbba3af5fb01d19b
Merge: 3934092 50d716e
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 3 01:31:37 2009 -0400

    Merge branch 'misc' into release

commit 3934092591c65270fd0d37e2b7288df188dd0bea
Merge: 6effe5f 478fa03
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 3 01:31:34 2009 -0400

    Merge branch 'bugzilla-14081' into release

commit 478fa03b32f1b3320aebc482b1685272e17a4762
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Oct 2 20:21:40 2009 +0400

    ACPI: EC: Don't parse DSDT for EC early init on Compal
    
    Compal DSDT breaks if scanned early, while we need early scan
    for almost all ASUS machines. Safest workaround seems to be to
    continue do an early scan for all machines, but this Compal model.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14086
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0adf3c746a73684b3f8c2821a584e1db998f61e9
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Oct 2 20:21:33 2009 +0400

    ACPI: EC: Rewrite DMI checks
    
    Use dmi_check_system() for DMI matching.
    Don't use string "Notebook" for matching MSI hardware.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14081
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50d716e477a456f6ef8ef05f06a34f3d96b66e80
Author: Alex Chiang <achiang@hp.com>
Date:   Thu Oct 1 11:59:23 2009 -0600

    ACPI: dock: fix "sibiling" typo
    
    Crossword clues as haikus:
    
    	Snakes from the same brood
    	fighting Jackson on a plane?
    	sibilant siblings
    
    I guess Will Shortz's job is still secure.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 53412c5b1225db77f7ac04b6a5351e60ea2a280f
Author: Roland Dreier <rdreier@cisco.com>
Date:   Wed Sep 30 13:58:03 2009 -0700

    ACPI: kill overly verbose "throttling states" log messages
    
    I was recently lucky enough to get a 64-CPU system.  The processors
    actually have T-states, so my kernel log ends up with 64 lines like:
    
        ACPI: Processor [CPU0] (supports xx throttling states)
    
    This is pretty useless clutter because
    
     - this info is already available after boot from
       /proc/acpi/processor/CPUnn/throttling
    
     - there's also an ACPI_DEBUG_PRINT() in processor_throttling.c that
       gives the same info on boot for anyone who *really* cares.
    
    So just delete the code that prints the throttling states in
    processor_core.c.
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d9f65018065ee1b161a85f54132193f248a45439
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Sat Sep 26 20:50:25 2009 +0200

    ACPI: Fix bound checks for copy_from_user in the acpi /proc code
    
    The ACPI /proc write() code takes an unsigned length argument like any write()
    function, but then assigned it to a *signed* integer called "len".
    Only after this is a sanity check for len done to make it not larger than 4.
    
    Due to the type change a len < 0 is in principle also possible; this patch
    adds a check for this.
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6effe5f5773a12f0b1f2c1e1aea9dcf0ee96e7e6
Merge: 5e6f972 e12ac3d a83893ae
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 2 11:27:57 2009 -0400

    Merge branches 'sony-laptop', 'bugzilla-14247' and 'bugzilla-14271' into release

commit a83893ae903ba908b1139fd8455ac93c4e5a2dff
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Oct 2 11:03:12 2009 -0400

    ACPI: fix bus scanning memory leaks
    
    Free an acpi_get_object_info() buffer when we're finished.  Skip the
    acpi_get_name() altogether -- it was only used for a printk that was
    really just for debug anyway.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14271
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reported-and-tested-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e12ac3d018dd8f20a075f5520209862969146fa6
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Oct 2 02:53:15 2009 +0400

    ACPI: EC: Restart command even if no interrupts from EC
    
    EC may forget a command without sending any "reset" interrupt,
    thus we need to lessen the requirement for transaction restart.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=14247
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5e6f9725ace758c11895969d8b8175290b0cbc39
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Wed Sep 16 00:05:32 2009 +0900

    sony-laptop: Don't unregister the SPIC driver if it wasn't registered
    
    This fixes a warning when the module is unloaded on machines without SPIC.
    
    ------------[ cut here ]------------
    WARNING: at drivers/base/driver.c:261 driver_unregister+0x6e/0x80()
    Hardware name: OEM
    Unexpected driver unregister!
    Modules linked in: sony_laptop(-) rfkill af_packet i915
     drm i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect binfmt_misc
     ipv6 kvm_intel kvm acpi_cpufreq cpufreq_userspace cpufreq_powersave
     cpufreq_stats acpi_pad ac video output battery pci_slot sbs sbshc
     container iptable_filter ip_tables x_tables ext2 fuse
     snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
     snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi_event
     snd_seq snd_timer snd_seq_device snd fan sg serio_raw sr_mod cdrom
     soundcore button thermal processor thermal_sys floppy snd_page_alloc
     pcspkr intel_agp evdev [last unloaded: asus_atk0110]
    Pid: 8136, comm: modprobe Not tainted 2.6.31-rc8debug #50
    Call Trace:
    [<ffffffff8121ec7e>] ? driver_unregister+0x6e/0x80
    [<ffffffff81047577>] warn_slowpath_common+0x87/0xb0
    [<ffffffff81047624>] warn_slowpath_fmt+0x64/0x70
    [<ffffffff8119a360>] ? kobject_release+0x0/0x1f0
    [<ffffffff8119a267>] ? kobject_put+0x27/0x60
    [<ffffffff8121d346>] ? bus_put+0x16/0x20
    [<ffffffff8121d406>] ? bus_remove_driver+0xb6/0xf0
    [<ffffffff8121ec7e>] driver_unregister+0x6e/0x80
    [<ffffffff811cab50>] acpi_bus_unregister_driver+0x10/0x12
    [<ffffffffa035e86c>] sony_laptop_exit+0x2c/0x2e [sony_laptop]
    [<ffffffff8107ddc6>] sys_delete_module+0x176/0x230
    [<ffffffff8107186d>] ? trace_hardirqs_on_caller+0x14d/0x1a0
    [<ffffffff81350a04>] ? trace_hardirqs_on_thunk+0x3a/0x3f
    [<ffffffff8100bdab>] system_call_fastpath+0x16/0x1b
    ---[ end trace f638b6a59b19703e ]---
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 922553f20b6ff03d2f08229e6e4556843ae874da
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Sep 16 00:05:31 2009 +0900

    sony-laptop: remove _INI call at init time
    
    This is unnecessary as OSPM is supposed to call the method already when
    the device is discovered.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d1e0de92d6c706cc68627c884b2d58d3db707804
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Sep 16 00:05:30 2009 +0900

    sony-laptop: SPIC unset IRQF_SHARED, set IRQF_DISABLED
    
    The SPIC irq is not really shareable, the IO port cannot be cleared and
    always returns some data so there is no real way to understand if the irq
    is for us or not. Moreover the _PRS acpi method says the irq is not
    shareable.
    In addition to this, in some cases, an additional write to the IO port has
    to be performed in order to properly decode the event received from the
    device. This generates another interrupt which may overlap with the
    previous one. In the future this is going to be important for properly
    decoding events.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 31df7144da55aad9b453f36291b9fd9b19b1eb6a
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Sep 16 00:05:29 2009 +0900

    sony-laptop: remove device_ctrl and the SPIC mini drivers
    
    Having separate drivers for SPIC showed to be useless, only type3 has a
    slightly different behaviour than the others and there seem to be no real
    conflict between them.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>
