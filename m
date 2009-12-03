Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZLCXqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZLCXqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZLCXqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:46:07 -0500
Received: from claw.goop.org ([74.207.240.146]:44399 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbZLCXqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:46:06 -0500
Message-ID: <4B184DC3.5020509@goop.org>
Date: Thu, 03 Dec 2009 15:46:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>
Subject: [GIT PULL] Xen bugfixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this set of bugfixes, mostly to do with Xen domain 
save/restore.  They're all stable material as well.

(Note, if you pull quickly from git.kernel.org, you may pick up some 
more changes that I rolled back pending maintainer approval; pulling 
from master might be safer.)

Thanks,
     J

The following changes since commit 82d6469916c6fcfa345636a49004c9d1753905d1:
   Jeremy Fitzhardinge (1):
         xen: mask extended topology info in cpuid

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix

Ian Campbell (8):
       xen: re-register runstate area earlier on resume.
       xen: correctly restore pfn_to_mfn_list_list after resume
       xen: register timer interrupt with IRQF_TIMER
       xen: register runstate on secondary CPUs
       xen: call clock resume notifier on all CPUs
       xen: don't leak IRQs over suspend/resume.
       xen: improve error handling in do_suspend.
       xen: explicitly create/destroy stop_machine workqueues outside suspend/resume region.

Jeremy Fitzhardinge (5):
       xen/xenbus: make DEVICE_ATTR()s static
       xen: restore runstate_info even if !have_vcpu_info_placement
       xen: register runstate info for boot CPU early
       xen: don't call dpm_resume_noirq() with interrupts disabled.
       xen: use iret for return from 64b kernel to 32b usermode

Paolo Bonzini (3):
       xen: fix is_disconnected_device/exists_disconnected_device
       xen: improvement to wait_for_devices()
       xen: wait up to 5 minutes for device connetion

  arch/x86/xen/enlighten.c          |   27 ++++++++++----------
  arch/x86/xen/mmu.c                |    2 +-
  arch/x86/xen/smp.c                |    1 +
  arch/x86/xen/suspend.c            |   17 ++++++++++++-
  arch/x86/xen/time.c               |    7 ++---
  arch/x86/xen/xen-asm_64.S         |    4 +-
  arch/x86/xen/xen-ops.h            |    2 +
  drivers/xen/events.c              |    3 ++
  drivers/xen/manage.c              |   37 ++++++++++++++++++----------
  drivers/xen/xenbus/xenbus_probe.c |   48 ++++++++++++++++++++++++------------
  10 files changed, 98 insertions(+), 50 deletions(-)


