Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbXIVCHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbXIVCHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 22:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbXIVCHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 22:07:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:43013 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbXIVCHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 22:07:01 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.23-rc7
Date: Fri, 21 Sep 2007 22:06:45 -0400
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212206.45559.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Before 2.6.23, please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This restores some dmesg to what folks had in 2.6.22,
and prevents a possible system hang on video switching.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.23/acpi-release-20070126-2.6.23-rc7.diff.gz

 drivers/acpi/sleep/Makefile   |    2 
 drivers/acpi/sleep/main.c     |   57 ++++++++++++++++++++--
 drivers/acpi/sleep/poweroff.c |   75 ------------------------------
 drivers/acpi/video.c          |    3 -
 4 files changed, 53 insertions(+), 84 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPI: suspend: consolidate handling of Sx states.

Frans Pop (1):
      ACPI: suspend: consolidate handling of Sx states addendum

Maik Broemme (1):
      ACPI: video: remove dmesg spam

Zhang Rui (1):
      ACPI: video: _DOS=0 by default to prevent hotkey hang

with this log:

commit e5c86b5d4a517d10db89456426590ecba1597f1f
Merge: 19adc6b... 5a50fe7...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Sep 21 21:55:34 2007 -0400

    Pull suspend.now into release branch

commit 19adc6ba6c6a23e07617fe791db40c1b0668d123
Merge: 335fb8f... 7f10cc4...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Sep 21 21:55:29 2007 -0400

    Pull now into release branch

commit 5a50fe709d527f31169263e36601dd83446d5744
Author: Frans Pop <elendil@planet.nl>
Date:   Thu Sep 20 22:27:44 2007 +0200

    ACPI: suspend: consolidate handling of Sx states addendum
    
    Make the S0 state be always reported as supported
    
    Signed-off: Frans Pop <elendil@planet.nl>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f216cc3748a3a22c2b99390fddcdafa0583791a2
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Sep 20 21:32:35 2007 +0400

    ACPI: suspend: consolidate handling of Sx states.
    
    Recent changes to sleep initialization in ACPI dropped reporting of supported Sx
    states above S3. Fix that and also move S5 init into same file as other Sx.
    The only functional change is adding printk() for S4 and S5 cases.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f10cc4e838c2b2d7272031954c56c407569d497
Author: Maik Broemme <mbroemme@plusserver.de>
Date:   Fri Sep 14 22:12:34 2007 +0200

    ACPI: video: remove dmesg spam
    
    i am actually heavily using the ACPI video extension for my Thinkpad X61
    Tablet. I have bound the input events triggered by the brightness
    up/down keys to a simple
    
    echo <value> > /sys/class/backlight/acpi_video1/brightness
    
    but everytime the event is triggered and acpi_video_device_lcd_set_level()
    is called i got a notificication in my kernel log like:
    
    set_level status: 0
    set_level status: 0
    set_level status: 0
    set_level status: 0
    ...
    
    Signed-off-by: Maik Broemme <mbroemme@plusserver.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a21101c46ca5b4320e31408853cdcbf7cb1ce4ed
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Sep 14 11:46:22 2007 +0800

    ACPI: video: _DOS=0 by default to prevent hotkey hang
    
    In the past, the Linux/ACPI video driver invoked _DOS
    (Display Output Switch) with the parameter 1
    to tell the BIOS to switch the video output display for us.
    
    But this conflicts with Linux native graphics drivers,
    and can cause all sorts of issues, including hanging the system.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=6001
    
    Here we change the Linux default to evaluate _DOS=0,
    which tells the BIOS to simply send us a hotkey event
    and not touch the graphics hardware.
    
    The acpi video driver sends the display switch hotkey
    event up through the intput layer, and X can interpret
    that and use its native graphics driver to switch the display.
    
    For the case where Linux has no native graphics driver running,
    or the graphics driver doesn't know how to switch video and
    the BIOS (safely) does, the previous behaviour can be restored with:
    
    # echo 1 > /proc/acpi/video/*/DOS
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
