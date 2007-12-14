Return-Path: <linux-kernel-owner+w=401wt.eu-S1764417AbXLNGai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764417AbXLNGai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762199AbXLNG1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:27:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:45687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762165AbXLNG06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:26:58 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: [GIT PATCH] ACPI patches for 2.6.24-rc5
Date: Fri, 14 Dec 2007 01:26:11 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712140126.12182.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc5.diff.gz

 drivers/acpi/battery.c       |    2 +-
 drivers/acpi/numa.c          |    4 ++--
 drivers/acpi/video.c         |    4 ++--
 drivers/misc/thinkpad_acpi.c |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

through these commits:

Andrey Borzenkov (1):
      ACPI: battery: fix ACPI battery technology reporting

Henrique de Moraes Holschuh (1):
      ACPI: thinkpad-acpi: fix lenovo keymap for brightness

Jan Beulich (1):
      ACPI: fix modpost warnings

William Lee Irwin III (1):
      ACPI: video_device_list corruption

with this log:

commit d020c36685a35f66be89700e911c7d77a67bdc43
Merge: 6790acb... ad40e68...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 13 22:16:14 2007 -0500

    Pull battery-2.6.24 into release branch

commit 6790acb14d264d874ff8cbae1a72e72883ec3678
Merge: ffada89... 56a185b...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 13 22:12:38 2007 -0500

    Pull thinkpad-2.6.24 into release branch

commit 56a185b43be05e48da7428e6a1d3e2585b232b1d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Dec 13 12:14:09 2007 -0200

    ACPI: thinkpad-acpi: fix lenovo keymap for brightness
    
    Starting in 2.6.23...
    
    Several reports from X60 users complained that the default Lenovo keymap
    issuing EV_KEY KEY_BRIGHTNESS_UP/DOWN input events caused major issues when
    the proper brightness support through ACPI video.c was loaded.
    
    Therefore, remove the generation of these events by default, which is the
    right thing for T60, X60, R60, T61, X61 and R61 with their latest BIOSes.
    
    Distros that want to misuse these events into OSD reporting (which requires
    an ugly hack from hell in HAL) are welcome to set up the key map they need
    through HAL.  That way, we don't break everyone else's systems.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ffada8913e39e6fd35e95d7040ccac57b45812c9
Author: Jan Beulich <jbeulich@novell.com>
Date:   Thu Dec 13 08:32:26 2007 +0000

    ACPI: fix modpost warnings
    
    for sn2_defconfig:
    
    WARNING: vmlinux.o(.text+0x4b8601): Section mismatch: reference to .init.data:node_to_pxm_map (between '__acpi_map_pxm_to_node' and 'acpi_get_pxm')
    WARNING: vmlinux.o(.text+0x4b8741): Section mismatch: reference to .init.data:pxm_to_node_map (between 'acpi_map_pxm_to_node' and 'acpi_get_node')
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 98934def70b48dac74fac3738b78ab2d1a28edda
Author: William Lee Irwin III <wli@holomorphy.com>
Date:   Wed Dec 12 03:56:55 2007 -0800

    ACPI: video_device_list corruption
    
    The ->cap fields of struct acpi_video_device and struct acpi_video_bus
    are 1B each, not 4B. The oversized memset()'s corrupted the subsequent
    list_head fields. This resulted in silent corruption without
    CONFIG_DEBUG_LIST and BUG's with it. This patch uses sizeof() to pass
    the proper bounds to the memset() calls and thereby correct the bugs.
    
    Signed-off-by: William Irwin <wli@holomorphy.com>
    Acked-by: Mikael Pettersson <mikpe@it.uu.se>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad40e68bf5c54831cd6b2199fd24d616bac179f7
Author: Andrey Borzenkov <arvidjaar@mail.ru>
Date:   Sat Nov 10 20:02:49 2007 +0300

    ACPI: battery: fix ACPI battery technology reporting
    
    At least some systems report technology information with trailing spaces:
    
    {pts/1}% cat -E /var/tmp/bat/2.6.23 | grep type
    battery type:            Li-ION  $
    
    Use strncasecmp to compare model string to skip trailing part
    
    Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
