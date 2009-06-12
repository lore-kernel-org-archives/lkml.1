Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbZFLNOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbZFLNOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZFLNOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:14:23 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:35102 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755558AbZFLNOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:14:22 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 09:14:21 EDT
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i17ch61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL4MQD-01-LYH-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/23] updates for oprofile
Date: Fri, 12 Jun 2009 14:35:17 +0200
Message-ID: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 12 Jun 2009 12:59:05.0217 (UTC) FILETIME=[90E4CF10:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are updates for oprofile, mainly for x86. Most patches
for x86 replace many macro definitions by function calls and implement
internal 64 bit usage for MSR access. The code is now better readable
and maintainable. Future changes can be made easier.

Also, struct op_x86_model_spec has been extended to better describe
the x86 model. This patch series introduces common functions that can
be used by all x86 models. It is a first step to merge similar model
specific code and to get a common code base for all models.

Another change is the rework of arch_perfmon init code. There was
model specific code in nmi_int.c. This code is moved to
op_model_ppro.c by using the init function pointer in struct
op_x86_model_spec.

There are no functional changes in this patch set, it only contains
cleanups and reworks.

The following changes since commit 0886751c5d8b19fcee2e65d34ae21c9111e652a9:
  Robert Richter (1):
        Merge commit 'v2.6.30' into oprofile/master

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git master

-Robert

-----------

Robert Richter (23):
      Revert "oprofile: discover counters for op ppro too"
      x86/oprofile: moving arch_perfmon counter setup to op_x86_model_spec.init
      x86/oprofile: minor style changes in struct op_x86_model_spec
      oprofile: remove irq_flags in struct op_entry
      oprofile: remove obselete include headers
      x86/oprofile: remove #ifdefs in ibs functions
      x86/oprofile: simplify AMD cpu init code
      x86/oprofile: move common macros to op_x86_model.h
      x86/oprofile: remove MSR macros for AMD cpus
      x86/oprofile: remove MSR macros for ppro cpus
      x86/oprofile: remove MSR macros for p4 cpus
      x86/oprofile: fix and cleanup CTRL_SET_* macros
      x86/oprofile: remove unused macros for AMD virtualization profiling
      x86/oprofile: pass the model to setup_ctrs() functions
      x86/oprofile: replace macros to calculate control register
      x86/oprofile: replace CTR_OVERFLOWED macros
      x86/oprofile: replace CTRL_SET_*ACTIVE macros
      x86/oprofile: replace CTR*_IS_RESERVED macros
      x86/oprofile: use 64 bit wrmsr functions
      x86/oprofile: use 64 bit values to save MSR states
      x86/oprofile: remove some local variables in MSR save/restore functions
      x86/oprofile: use 64 bit values in IBS functions
      x86/oprofile: introduce oprofile_add_data64()

 arch/x86/oprofile/nmi_int.c       |   98 +++++++-------
 arch/x86/oprofile/op_model_amd.c  |  267 ++++++++++++++++---------------------
 arch/x86/oprofile/op_model_p4.c   |   60 ++++-----
 arch/x86/oprofile/op_model_ppro.c |   95 ++++++--------
 arch/x86/oprofile/op_x86_model.h  |   47 ++++---
 drivers/oprofile/cpu_buffer.c     |   16 ++-
 include/linux/oprofile.h          |    2 +-
 7 files changed, 281 insertions(+), 304 deletions(-)



