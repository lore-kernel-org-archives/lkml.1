Return-Path: <linux-kernel-owner+w=401wt.eu-S1751379AbZKYGNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbZKYGNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZKYGNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:13:53 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:40382 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZKYGNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:13:52 -0500
Date: Wed, 25 Nov 2009 01:13:57 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI & driver patches for 2.6.32-rc8
Message-id: <alpine.LFD.2.00.0911250112170.4058@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

A pair of regression fixes, a few bug fixes, and workarounds.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.32/acpi-release-20090903-2.6.32-rc8.diff.gz

 drivers/acpi/acpica/acpredef.h       |    5 +++--
 drivers/acpi/blacklist.c             |   17 +++++++++++++++++
 drivers/acpi/sleep.c                 |    8 ++++++++
 drivers/platform/x86/acerhdf.c       |   12 ++++++------
 drivers/platform/x86/thinkpad_acpi.c |   26 +++++++++++++++++++-------
 5 files changed, 53 insertions(+), 15 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPICA: Silence the warning about _BIF returning the buffer

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: fix detection of old ThinkPads

Jerone Young (1):
      ACPI: Add Thinkpad T400, T500 to OSI(Linux) white-list

Len Brown (1):
      ACPI: DMI init_set_sci_en_on_resume for HP-Compaq C700

Peter Feuerer (1):
      acerhdf: return temperature in milidegree instead of degree

Roel Kluin (1):
      thinkpad-acpi: fix sign of ERESTARTSYS return

with this log:

commit c4f7bc86279269d0e9520ded0617c609fd5e573a
Merge: 6444179 7005291
Author: Len Brown <len.brown@intel.com>
Date:   Wed Nov 25 01:01:29 2009 -0500

    Merge branch 'misc-2.6.32' into release

commit 7005291706341a11c094f39a756a01c9e649e5f9
Author: Peter Feuerer <peter@piie.net>
Date:   Tue Nov 17 14:07:21 2009 -0800

    acerhdf: return temperature in milidegree instead of degree
    
    Return temperature in milidegree instead of degree, as sysfs-api requires
    the temperature in milidegree.
    
    Signed-off-by: Peter Feuerer <peter@piie.net>
    Tested-by: Borislav Petkov <petkovbb@gmail.com>
    Cc: Andreas Mohr <andi@lisas.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 644417958b0bbb1dbf79003fc14e6ccf1271b9ad
Merge: a425776 275014a
Author: Len Brown <len.brown@intel.com>
Date:   Wed Nov 25 00:43:08 2009 -0500

    Merge branch 'thinkpad-2.6.32' into release

commit 275014ae46871ce0ab08550fc4040f12b685813a
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Nov 17 14:07:22 2009 -0800

    thinkpad-acpi: fix detection of old ThinkPads
    
    There is a problem in the quirk tables used by tpacpi_is_fw_known() and
    tpacpi_check_outdated_fw(), which causes outdated BIOSes that are lacking
    the EC firmware ID DMI field to never match.
    
    This breaks module loading on, e.g.  a T23 with outdated BIOS, and the
    module will refuse to load unless the "force_load=1" parameter is given.
    
    Fix the quirk tables so that they can also match the outdated BIOSes,
    which in turn will both fix the module loading, and also warn the user
    that he is using outdated firmware and should upgrade.
    
    This fixes a serious regression, introduced by commit
    e675abafcc0df38125e6e94a9ba91c92fe774f52, "thinkpad-acpi: be more strict
    when detecting a ThinkPad".
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14597
    
    Reported-by: Paul Kimoto <kimoto@lightlink.com>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Tested-by: Paul Kimoto <kimoto@lightlink.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 80a8d1228e90349b4514e8c925c061fa5cbcea75
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Fri Nov 20 19:48:23 2009 +0100

    thinkpad-acpi: fix sign of ERESTARTSYS return
    
    The returned error should be negative
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Cc: <stable@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4257763de8cfac0d72503a10c69f7f07ae727a9
Merge: 87c687b d0b3b11
Author: Len Brown <len.brown@intel.com>
Date:   Wed Nov 25 00:04:48 2009 -0500

    Merge branch 'bugzilla-14379' into release

commit 8b1edc57a617d00845806ca1fce1799c08d50920
Author: Jerone Young <jerone.young@canonical.com>
Date:   Thu Aug 27 00:04:44 2009 -0500

    ACPI: Add Thinkpad T400, T500 to OSI(Linux) white-list
    
    acpi_osi=Linux helps the mute button work properly by sending Linux
    a mute key press.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13934
    
    Signed-off-by: Jerone Young <jerone.young@canonical.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0b3b119f4d9460f3947334cf384ae69c5417360
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Nov 24 21:34:35 2009 -0500

    ACPICA: Silence the warning about _BIF returning the buffer
    
    _BIF was returning buffer instead of a string since day 1 of ACPI.
    Adding a warning for that is noble, but people don't like
    when someone cries wolf in a production system.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=14379
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 87c687be055e67bc04189ce476690be73d16063e
Author: Len Brown <len.brown@intel.com>
Date:   Mon Nov 23 11:44:12 2009 -0500

    ACPI: DMI init_set_sci_en_on_resume for HP-Compaq C700
    
    ...else ACPI thermal controls fail after resume.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13745
    
    Signed-off-by: Len Brown <len.brown@intel.com>
