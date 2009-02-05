Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbZBEQx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbZBEQx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZBEQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:53:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:24489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZBEQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fq3HhXFxj/6Z+q5aNeeASZ29cO83LrC082ZYQho/0PVxFbE6LYH4nHpDndWKGXZDSP
         wIR8aQgXEvZ+4VpkBHRupcHHeddIqrHf+feSopiEa9v35XJL39NlN2LKqR1YK/JEPuTz
         Cbg8fqhUVMootVs+8Khyv5ocM+RnaYd0LFioQ=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Matt Reimer <mreimer@vpop.net>
Subject: [PATCH 0/6] fix PASIC3/DS1WM, use MFD core
Date: Thu,  5 Feb 2009 17:53:34 +0100
Message-Id: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following patches turn DS1WM into an MFD cell driver, make PASIC3 use 
the MFD core functions to register it and remove the generic clock API
code from DS1WM as MFDs currently can't register their clocks with it.
With those applied, 1-Wire is finally in a working state on magician.

Patch #2 depends on #1, patch #4 depends on #3 and patch #6 depends on #5.
Therefor I propose that this whole patchset be queued in the mfd tree.
If so, #4 could be merged into #2. But it won't hurt to just leave out 
#3 and #4 for now and apply them as cleanups later.

Philipp Zabel (6):
      mfd: DS1WM: convert to use MFD core
      mfd: PASIC3: convert to use MFD core
      pxa/magician: remove deprecated .bus_shift from PASIC3 platform_data
      mfd: PASIC3: remove unused bus_shift field
      mfd: DS1WM: remove clock handling
      mfd: PASIC3: supply clock_rate to DS1WM via driver_data

 arch/arm/mach-pxa/magician.c   |    1 -
 drivers/mfd/Kconfig            |    1 +
 drivers/mfd/htc-pasic3.c       |  169 ++++++++++++++++------------------------
 drivers/w1/masters/ds1wm.c     |   53 ++++++-------
 include/linux/ds1wm.h          |   12 ---
 include/linux/mfd/ds1wm.h      |    6 ++
 include/linux/mfd/htc-pasic3.h |    1 -
 7 files changed, 100 insertions(+), 143 deletions(-)
 delete mode 100644 include/linux/ds1wm.h
 create mode 100644 include/linux/mfd/ds1wm.h
