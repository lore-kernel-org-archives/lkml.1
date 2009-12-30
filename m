Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZL3X50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZL3X50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZL3X5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:57:22 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:53919 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZL3X5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:57:17 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_MXM2MBSg0RC9q0Y1ZL2MDg)"
Date: Wed, 30 Dec 2009 18:57:08 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI & driver patches for 2.6.33-rc2
Message-id: <alpine.LFD.2.00.0912301843470.17125@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_MXM2MBSg0RC9q0Y1ZL2MDg)
Content-type: TEXT/PLAIN; charset=ISO-8859-2
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

5 thinkpad sound tweaks
4 needed error checks
3 regression bug fixes
2 debugging bootparams
and a BIOS workaround in a pear tree.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.33/acpi-release-20091214-2.6.33-rc2.diff.gz

 Documentation/kernel-parameters.txt     |    5 ++-
 Documentation/laptops/thinkpad-acpi.txt |   58 ++++++++++++++++++++++++++----
 arch/x86/kernel/acpi/sleep.c            |    2 +
 drivers/acpi/sleep.c                    |   29 +++++++++------
 drivers/acpi/video.c                    |    8 ++++-
 drivers/char/ipmi/ipmi_si_intf.c        |    4 +-
 drivers/platform/x86/Kconfig            |   28 ++++++++++++++
 drivers/platform/x86/dell-wmi.c         |   18 ++++++---
 drivers/platform/x86/hp-wmi.c           |    9 ++++-
 drivers/platform/x86/msi-wmi.c          |    9 ++++-
 drivers/platform/x86/thinkpad_acpi.c    |   59 +++++++++++++++++++++++-------
 drivers/platform/x86/wmi.c              |   36 +++++++++++++++++--
 include/linux/acpi.h                    |    1 +
 13 files changed, 214 insertions(+), 52 deletions(-)

through these commits:

Carlos Corbacho (1):
      ACPI: WMI: Survive BIOS with duplicate GUIDs

Dmitry Torokhov (1):
      dell-wmi - fix condition to abort driver loading

Henrique de Moraes Holschuh (5):
      thinkpad-acpi: don't take the first ALSA slot by default
      thinkpad-acpi: don't fail to load the entire module due to ALSA problems
      thinkpad-acpi: make volume subdriver optional
      thinkpad-acpi: update volume subdriver documentation
      thinkpad-acpi: improve Kconfig help text

Ingo Molnar (1):
      ACPI: fix ACPI=n allmodconfig build

Len Brown (3):
      dell-wmi: sys_init_module: 'dell_wmi'->init suspiciously returned 21, it should
      ACPI: hp-wmi, msi-wmi: clarify that wmi_install_notify_handler() returns an acpi_status
      dell-wmi, hp-wmi, msi-wmi: check wmi_get_event_data() return value

Paul Rolland (1):
      wmi: check find_guid() return value to prevent oops

Zhang Rui (3):
      ACPI video: no warning message if "acpi_backlight=vendor" is used
      ACPI video: correct error-handling code
      ACPI: introduce kernel parameter acpi_sleep=sci_force_enable

with this log:

commit 1201b2a9bec0413188ada1443ece1a52da6dbff4
Merge: cccc67a d7f0eea
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 30 18:32:32 2009 -0500

    Merge branch 'resume-sci-force-bootparam' into release

commit d7f0eea9e431e1b8b0742a74db1a9490730b2a25
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Dec 30 15:36:42 2009 +0800

    ACPI: introduce kernel parameter acpi_sleep=sci_force_enable
    
    Introduce kernel parameter acpi_sleep=sci_force_enable
    
    some laptop requires SCI_EN being set directly on resume,
    or else they hung somewhere in the resume code path.
    
    We already have a blacklist for these laptops but we still need
    this option, especially when debugging some suspend/resume problems,
    in case there are systems that need this workaround and are not yet
    in the blacklist.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cccc67a4cf52a952e6371ac75510994e0bddec96
Merge: b943aa8 e01ce79
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 30 02:51:38 2009 -0500

    Merge branch 'video-error-case' into release

commit b943aa83f8038959999a6b12e469a875ab245a36
Merge: ea840aa 28c32e9
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 30 02:51:31 2009 -0500

    Merge branch 'bugzilla-13671' into release

commit ea840aa2d01cf107b331d04ddea46efaee583a83
Merge: 1ae22af 6e5b08e
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 30 02:51:05 2009 -0500

    Merge branch 'thinkpad' into release

commit 1ae22af7d750fbf665b7651fcbd3c15cc2d3793b
Merge: 27d0567 d1f9e49
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 30 02:51:01 2009 -0500

    Merge branch 'wmi' into release

commit d1f9e4970742bb1e22d07b01bd44f9c357d25c42
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Dec 26 19:14:59 2009 +0000

    ACPI: WMI: Survive BIOS with duplicate GUIDs
    
    It would appear that in BIOS's with nVidia hooks, the GUID
    05901221-D566-11D1-B2F0-00A0C9062910 is duplicated. For now, the simplest
    solution is to just ignore any duplicate GUIDs. These particular hooks are not
    currently supported/ used in the kernel, so whoever does that can figure out
    what the 'right' solution should be (if there's a better one).
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14846
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
    Reported-by: Oldøich Jedlièka <oldium.pro@seznam.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a9568f536754623738110a314ff33286cdbb17d
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Fri Dec 25 11:49:35 2009 -0800

    dell-wmi - fix condition to abort driver loading
    
    From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    
    The commit 1fdd407f4e3f2ecb453954cbebb6c22491c61853 incorrectly made driver
    abort loading when known GUID is present when it should have done exactly
    the opposite.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c03b26a5a5597a59b2e247d005d5901430109a8a
Author: Paul Rolland <rol@as2917.net>
Date:   Wed Dec 30 01:07:40 2009 -0500

    wmi: check find_guid() return value to prevent oops
    
    Signed-off-by: Paul Rolland <rol@as2917.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fda11e61ff8a4e3a8ebbd434e46560b67cc0ca9d
Author: Len Brown <len.brown@intel.com>
Date:   Sat Dec 26 23:02:24 2009 -0500

    dell-wmi, hp-wmi, msi-wmi: check wmi_get_event_data() return value
    
    When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
    the caller must kfree the returned buffer if AE_OK is returned.
    
    The callers of wmi_get_event_data() pass ACPI_ALLOCATE_BUFFER,
    and thus must check its return value before accessing
    or kfree() on the buffer.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f27725756be8a2c2dc65eaf70d0b52807aa2f113
Author: Len Brown <len.brown@intel.com>
Date:   Sat Dec 26 22:04:03 2009 -0500

    ACPI: hp-wmi, msi-wmi: clarify that wmi_install_notify_handler() returns an acpi_status
    
    Emphasize that that wmi_install_notify_handler() returns an acpi_status
    rather than -errno by by testing ACPI_SUCCESS(), ACPI_FAILURE().
    
    No functional change in this patch, but this confusion caused a bug in dell-wmi.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit abb631bfe271a9102fb5b05419272b7aec37a974
Author: Len Brown <len.brown@intel.com>
Date:   Sat Dec 26 21:51:38 2009 -0500

    dell-wmi: sys_init_module: 'dell_wmi'->init suspiciously returned 21, it should
    follow 0/-E convention
    
    wmi_install_notify_handler() returns an acpi_error,
    but dell_wmi_init() needs return a -errno style error.
    
    Tested-by: Paul Rolland <rol@as2917.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e01ce79b7f6ebc5b57128ee058811aa8f9059319
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Jul 29 08:53:29 2009 +0800

    ACPI video: correct error-handling code
    
    backlight_device_register may return an ERR_PTR
    value rather than a valid pointer.
    
    Problem found by Julia Lawall, properly fixed by Zhang Rui.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 28c32e99bdf5ab838e7179c1aaca5a35a07f2a2b
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jul 13 10:33:24 2009 +0800

    ACPI video: no warning message if "acpi_backlight=vendor" is used
    
    AML code always sends notifications to ACPI video device,
    even if we disable the ACPI backlight control by using
    boot option "acpi_backlight=vendor".
    
    In this case we should not print any warning message.
    http://bugzilla.kernel.org/show_bug.cgi?id=13671#c14
    
    Sigend-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 27d0567ab635bc2af11be48f91c8d5a7a2dca2e4
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Dec 17 08:50:25 2009 +0100

    ACPI: fix ACPI=n allmodconfig build
    
    Today's -tip failed to build because commit
    9e368fa011d4e0aa050db348d69514900520e40b ("ipmi: add PNP discovery (ACPI
    namespace via PNPACPI)") from today's upstream kernel causes the following
    build failure on x86, for CONFIG_ACPI=n && CONFIG_IPMI_SI=y:
    
     drivers/char/ipmi/ipmi_si_intf.c:3208: error: 'ipmi_pnp_driver' undeclared (first use in this function)
     drivers/char/ipmi/ipmi_si_intf.c:3208: error: (Each undeclared identifier is reported only once
     drivers/char/ipmi/ipmi_si_intf.c:3208: error: for each function it appears in.)
     drivers/char/ipmi/ipmi_si_intf.c:3334: error: 'ipmi_pnp_driver' undeclared (first use in this function)
    
    The reason is that the ipmi_pnp_driver depends on ACPI facilities and is only
    made available under ACPI - while the registration and unregistration is made
    dependent on CONFIG_PNP:
    
     #ifdef CONFIG_PNP
     	pnp_register_driver(&ipmi_pnp_driver);
     #endif
    
    The solution is to only register this driver under ACPI. (Also, the CONFIG_PNP
    dependency is not needed because pnp_register_driver() is stubbed out in the
    !CONFIG_PNP case.)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Acked-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6e5b08ee941af38cfc6456158e7e04c1bc49306f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Dec 26 22:52:17 2009 -0200

    thinkpad-acpi: improve Kconfig help text
    
    Document that rfkill and ALSA functionality exists, but requires the
    subsystems to be available, and not modular if thinkpad-acpi is not
    modular.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 169220f88f0f26f4450ac0bc8ff0f807b453ec58
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Dec 26 22:52:16 2009 -0200

    thinkpad-acpi: update volume subdriver documentation
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff850c339a1a6a7724537160c73cdc09a483fc5d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Dec 26 22:52:15 2009 -0200

    thinkpad-acpi: make volume subdriver optional
    
    Allow the user to choose through Kconfig if the Console Audio Control
    interface (aka "volume subdriver") should be available or not.
    
    This not only saves some memory, but also allows the thinkpad-acpi
    driver to be built-in even if ALSA is modular when the console audio
    control interface is not wanted.
    
    This change fixes a build problem that is causing some annoyances, in
    a way that doesn't disable the entire driver on kernels without ALSA
    support.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Amerigo Wang <amwang@redhat.com>
    Cc: Helight Xu <helight.xu@gmail.com>
    Cc: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 74c75c1848b618f6717c1be887ad539ffac2e96d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Dec 26 22:52:14 2009 -0200

    thinkpad-acpi: don't fail to load the entire module due to ALSA problems
    
    If we cannot create the ALSA mixer, it is a good reason to fail to
    load the volume subdriver, and not to fail to load the entire module.
    
    While at it, add more debugging messages, as the error paths are being
    used a lot more than I'd expect, and it is failing to set up the ALSA
    mixer on a number of ThinkPads.
    
    Reported-by: Peter Jordan <usernetwork@gmx.info>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ead510cebcdf41c92fce2a909f342255b028a33d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Dec 26 22:52:13 2009 -0200

    thinkpad-acpi: don't take the first ALSA slot by default
    
    We don't want to be the first soundcard.  We don't want to shift other
    soundcards out of the way either, even if they load much later.
    
    Ask ALSA to (by default) load us in one of the last three slots.  This
    can be overriden at will using the "index" parameter.
    
    Reported-by: Whoopie <whoopie79@gmx.net>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_MXM2MBSg0RC9q0Y1ZL2MDg)--
