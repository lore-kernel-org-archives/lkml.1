Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbZCIN0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbZCIN0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZCIN03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:26:29 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35581 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751223AbZCIN01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:26:27 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>
Cc: rtc-linux@googlegroups.com, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Dann Frazier <dannf@dannf.org>
Subject: [PATCH 0/7] Generic RTC class driver
Date: Mon,  9 Mar 2009 14:26:16 +0100
Message-Id: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


        Hi Alessandro et al,

This patch series:
  1. Adds the missing module alias to rtc-parisc (which is a bugfix), and
     performs a few cleanups,
  2. Moves the platform device creation out of rtc-ppc and into arch-specific
     code (which is also a bugfix),
  3. Consolidates rtc-parisc and rtc-ppc into rtc-generic (which is a cleanup),
  4. Hooks up rtc-generic on m68k (it's been using [sg]et_rtc_time() since
     ages),
  5. Makes rtc-generic dependent on PARISC, PPC, and M68K (the existing
     [sg]et_rtc_time() users):
       a. without introducing ARCH_HAS_GENERIC_RTC,
       b. with a big fat warning in the Kconfig comment discouraging people
          from relaxing the dependencies.
  6. Converts the PS3 RTC support into a separate driver, called rtc-ps3
     (as a bonus ;-)

To reduce code churn, the order and number of the actual patches slightly
differs:
  [1] parisc: rtc: get_rtc_time() returns unsigned int
  [2] parisc: rtc: platform_driver_probe() fixups
  [3] parisc: rtc: Add missing module alias
  [4] parisc: rtc: Rename rtc-parisc to rtc-generic
  [5] m68k: Hook up rtc-generic
  [6] powerpc: Hook up rtc-generic, and kill rtc-ppc
  [7] powerpc/ps3: Add rtc-ps3

 a/drivers/rtc/rtc-parisc.c              |   85 -------------------------
 b/arch/m68k/include/asm/rtc.h           |    7 +-
 b/arch/m68k/kernel/time.c               |   18 +++++
 b/arch/parisc/Kconfig                   |    2 
 b/arch/parisc/kernel/time.c             |    6 -
 b/arch/powerpc/include/asm/ps3.h        |    3 
 b/arch/powerpc/kernel/time.c            |   16 ++++
 b/arch/powerpc/platforms/ps3/os-area.c  |    2 
 b/arch/powerpc/platforms/ps3/platform.h |    2 
 b/arch/powerpc/platforms/ps3/setup.c    |    2 
 b/arch/powerpc/platforms/ps3/time.c     |   26 +++----
 b/drivers/rtc/Kconfig                   |   10 +--
 b/drivers/rtc/Makefile                  |    2 
 b/drivers/rtc/rtc-generic.c             |   84 +++++++++++++++++++++++++
 b/drivers/rtc/rtc-parisc.c              |    5 -
 b/drivers/rtc/rtc-ps3.c                 |  106 +++++++++++++++++++++++++++++++-
 drivers/rtc/Kconfig                     |   22 +++---
 drivers/rtc/Makefile                    |    2 
 drivers/rtc/rtc-parisc.c                |    6 -
 drivers/rtc/rtc-ppc.c                   |   70 ---------------------
 20 files changed, 271 insertions(+), 205 deletions(-)

These patches are relative to the "rtc-parisc" branch of Kyle's PA-RISC git
repository, which already contains some cleanups for the rtc-parisc driver by
Dann, which already have been ack'ed by Alessandro:

http://git.kernel.org/?p=linux/kernel/git/kyle/parisc-2.6.git;a=shortlog;h=rtc-parisc

Paul: Feel free to add your SuperH support.

I suppose the easiest way for this to go in is through Kyle's PA-RISC tree, as
he already has the preceding patches? Can I have your acks, please?

Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
