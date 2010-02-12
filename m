Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab0BLWjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:39:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:44554 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab0BLWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:39:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu
Subject: [PATCH 0/7] kms + kgdb & kdb proposed merge for 2.6.34
Date: Fri, 12 Feb 2010 16:36:21 -0600
Message-Id: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 12 Feb 2010 22:39:22.0924 (UTC) FILETIME=[391206C0:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch set 2 of 3 - The kdb / kgdb merge

This patch set stacks on top of the kgdb / kdb patches and focuses on
further extending kdb to accommodate atomic kernel mode setting (kms).

At the moment only the Intel i915 class video devices are supported,
but the API is generic and would allow for other kms based drivers to
enable atomic mode setting.

The final patch in the series would be omitted from any pull request
as it is still a work in progress, showing the remaining points that do
not have a safe mechanism to work atomically to change the display
context in order to view the kernel debugger shell.  At least it
provides a nice proof of concept.

You can find the development branch for this here:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=kms-merge

Thanks,
Jason.

---
Jason Wessel (6):
      kgdboc,debug_core: Add call backs to allow kernel mode switching
      kms,kdb: Force unblank a console device
      i915: when kgdb is active display compression should be off
      drm_fb_helper: Preserve capability to use atomic kms
      kgdb,docs: Update the kgdb docs to include kms
      RFC,HACK,EXPERIMENTAL,drm,i915 - atomic mutex HACKS

Jesse Barnes (1):
      drm: add KGDB/KDB support Add support for KDB entry/exit.

 Documentation/DocBook/kgdb.tmpl      |   82 ++++++++++++++++++++++---
 Documentation/kernel-parameters.txt  |    9 ++-
 drivers/gpu/drm/drm_fb_helper.c      |   93 +++++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_display.c |  114 ++++++++++++++++++++++++++++++++--
 drivers/serial/kgdboc.c              |   27 ++++++++
 drivers/video/console/fbcon.c        |    7 ++
 include/drm/drm_crtc_helper.h        |    2 +
 include/drm/drm_fb_helper.h          |    4 +
 include/linux/kgdb.h                 |   38 +++++++++++
 kernel/debug/Makefile                |    1 +
 kernel/debug/debug_core.c            |   23 +++++++
 kernel/debug/kms_hooks.c             |   62 ++++++++++++++++++
 12 files changed, 438 insertions(+), 24 deletions(-)
 create mode 100644 kernel/debug/kms_hooks.c
