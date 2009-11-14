Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZKOHNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZKOHNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZKOHNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:13:45 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40952 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZKOHNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:13:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=qTuv/UZdA6i1HpeaVoDWo49R9Y8+S/4CIZjxR+Lfk0MwqwrZZ+zTYssjreaPfDbYDk
         YCjaDAGDj7vXtYWPf2VZazsADF05s/F1zYKQoC/n0K4KZxMTsLnMFdTrHGcvaeBnq//L
         gjX6tFdcw9Hus7J93mCYQGsB71T/Ab8T6vtpE=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 00/12] introduce skip_spaces(), reducing code size plus some clean-ups
Date: Sat, 14 Nov 2009 05:11:48 -0200
Message-Id: <cover.1258181836.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reduces lib/lib.a code size by 482 bytes on my Core 2 with gcc 4.4.1
even considering that it exports a newly defined function skip_spaces()
to drivers:
   text    data     bss     dec     hex filename
  64867     840     592   66299   102fb (TOTALS-lib.a-BEFORE)
  64641     584     592   65817   10119 (TOTALS-lib.a-AFTER)
and implements some code tidy up.

Besides reducing lib.a size, it converts many in-tree drivers to use the
newly defined function, which makes another small reduction on kernel size
overall when those drivers are used.

Changelog:
   v5: addressed comments and feedback from many people: Jan Engelhardt,
James Bottomley, Rusty Russell, Alan Cox, Henrique de Moraes Holschuh,
Theodore Tso and Julia Lawall (thanks!)
   v4: converted drivers over newly defined skip_spaces() function
   v3: improved comments on patch 5/7 and factorize a switch statement on 6/7
as per suggestions from Ingo and Frederic (thanks!)
   v2: addressed feedback from Frederic Weisbecker review (thanks!)
and split into separate patches
   v1: original submission

André Goddard Rosa (12):
  vsprintf: factorize "(null)" string
  vsprintf: pre-calculate final string length for later use
  vsprintf: give it some care to please checkpatch.pl
  vsprintf: use TOLOWER whenever possible
  vsprintf: reduce code size by avoiding extra check
  vsprintf: move local vars to block local vars and remove unneeded
    ones
  vsprintf: factor out skip_space code in a separate function
  vsprintf: reuse almost identical simple_strtoulX() functions
  ctype: constify read-only _ctype string
  string: factorize skip_spaces and export it to be generally available
  string: on strstrip(), first remove leading spaces before running
    over str
  tree-wide: convert open calls to remove spaces to skip_spaces() lib
    function

 arch/s390/kernel/debug.c              |    3 +-
 arch/um/drivers/mconsole_kern.c       |   16 +-
 arch/x86/kernel/cpu/mtrr/if.c         |   11 +-
 drivers/leds/led-class.c              |    2 +-
 drivers/leds/ledtrig-timer.c          |    4 +-
 drivers/md/dm-table.c                 |    6 +-
 drivers/md/md.c                       |    4 +-
 drivers/parisc/pdc_stable.c           |    9 +-
 drivers/platform/x86/thinkpad_acpi.c  |    7 +-
 drivers/pnp/interface.c               |   36 +---
 drivers/s390/block/dasd_proc.c        |    5 +-
 drivers/video/backlight/lcd.c         |    4 +-
 drivers/video/display/display-sysfs.c |    2 +-
 drivers/video/output.c                |    2 +-
 fs/cachefiles/daemon.c                |    4 +-
 fs/ext4/super.c                       |    7 +-
 include/linux/ctype.h                 |    3 +-
 include/linux/string.h                |    1 +
 kernel/params.c                       |    8 +-
 lib/argv_split.c                      |   13 +-
 lib/ctype.c                           |   50 +++---
 lib/dynamic_debug.c                   |    4 +-
 lib/string.c                          |   19 ++-
 lib/vsprintf.c                        |  337 ++++++++++++++++-----------------
 net/irda/irnet/irnet.h                |    1 +
 net/irda/irnet/irnet_ppp.c            |    8 +-
 net/netfilter/xt_recent.c             |    3 +-
 sound/pci/hda/hda_hwdep.c             |    7 +-
 28 files changed, 264 insertions(+), 312 deletions(-)

