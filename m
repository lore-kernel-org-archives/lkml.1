Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYA0Xjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYA0Xjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYA0Xjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:39:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35062 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYA0Xjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:39:36 -0500
Date: Sun, 27 Jan 2008 15:37:51 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PATCH] driver core fixes against 2.6.24
Message-ID: <20080127233751.GA4524@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's 5 patches against your current git tree that fix all of the
reported breakages due to the driver core patch merge.

They fix the following issues:
  - build breakage with CONFIG_BLOCK=n
  - strange traceback messages when loading a module that is already
    built into the kernel.
  - ppc vio code build warning and link error fix.
  - oops fix for mce_amd_64 when running on some variants of multi-core
    AMD boxes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 arch/powerpc/kernel/vio.c               |   13 +++-------
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    3 +-
 drivers/base/bus.c                      |   41 ++++++++++++++++++++++---------
 drivers/base/class.c                    |    2 +-
 drivers/base/core.c                     |   30 ++++++++++++++--------
 include/linux/device.h                  |    3 ++
 kernel/module.c                         |   10 +++++++
 7 files changed, 68 insertions(+), 34 deletions(-)

---------------

Greg Kroah-Hartman (4):
      Driver core: Fix up build when CONFIG_BLOCK=N
      x86: fix runtime error in arch/x86/kernel/cpu/mcheck/mce_amd_64.c
      Module: check to see if we have a built in module with the same name
      Driver core: add bus_find_device_by_name function

Paul Mackerras (1):
      PPC: Fix powerpc vio_find_name to not use devices_subsys

