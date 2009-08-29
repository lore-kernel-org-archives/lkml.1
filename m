Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbZH2AVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbZH2AVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 20:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZH2AVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 20:21:34 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:36001 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZH2AVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 20:21:34 -0400
Date: Fri, 28 Aug 2009 20:21:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI related patches for Linux-2.6.31-rc8
Message-id: <alpine.LFD.2.00.0908282016330.27023@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.31/acpi-release-20090521-2.6.31-rc8.diff.gz

 drivers/acpi/acpica/exstorob.c      |   12 ++++++++++++
 drivers/acpi/video.c                |    7 +++++--
 drivers/platform/x86/toshiba_acpi.c |    1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

through these commits:

Jiri Slaby (1):
      toshiba_acpi: return on a fail path

Keith Packard (1):
      ACPI: don't free non-existent backlight in acpi video module

Lin Ming (1):
      ACPICA: Windows compatibility fix: same buffer/string store

with this log:

commit e29b3ee3b005897fbdcfdd4b3190776e38739d70
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Aug 6 15:57:54 2009 -0700

    ACPI: don't free non-existent backlight in acpi video module
    
    acpi_video_put_one_device was attempting to remove sysfs entries and
    unregister a backlight device without first checking that said backlight
    device structure had been created.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 82e7784f57a81faf673b09bc468e736d582fe754
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Thu Aug 6 15:57:51 2009 -0700

    toshiba_acpi: return on a fail path
    
    Return from bt_rfkill_poll() when hci_get_radio_state() fails.
    
    value is invalid in that case and should not be assigned to the rfkill
    state.
    
    This also fixes a double unlock bug.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Cc: John W. Linville <linville@tuxdriver.com>
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b0de22bdffa2e9a8e280d769c59f866605268484
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Aug 26 09:01:34 2009 +0800

    ACPICA: Windows compatibility fix: same buffer/string store
    
    Fix a compatibility issue when the same buffer or string is
    stored to itself. This has been seen in the field. Previously,
    ACPICA would zero out the buffer/string. Now, the operation is
    treated as a NOP.
    
    http://bugzilla.acpica.org/show_bug.cgi?id=803
    
    Reported-by: Rezwanul Kabir <Rezwanul_Kabir@Dell.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

thanks,
Len Brown, Intel Open Source Technology Center
