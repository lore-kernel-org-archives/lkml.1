Return-Path: <linux-kernel-owner+w=401wt.eu-S935732AbYBUXro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935732AbYBUXro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbYBUXrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:47:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48833 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948AbYBUXrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:47:13 -0500
Date: Thu, 21 Feb 2008 15:46:49 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       kay.sievers@vrfy.org, Michael_E_Brown@dell.com, rdreier@cisco.com,
       htejun@gmail.com
Subject: [GIT PATCH] driver core fixes against 2.6.25-rc2 git
Message-ID: <20080221234649.GB7128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few driver core fixes against your current git tree that fix some
more problems that have cropped up:
	- shutdown problem due to logic problem with cpufreq usage of
	  kobjects.
	- build fix for powerpc due to previous kobject changes.
	- runtime errors when CONFIG_SYSFS=n
	- UIO code now works properly from my previous messups
	- proper encoding of the ja_JP stable_kernel_rules.txt file
	- updates to the stable_kernel_rules.txt file
	- mark ide=reverse as obsolete in preparation of 2.6.26 (Bart
	  wanted this to go in through my tree as I have the .26 patches
	  pending.)
	- other minor fixes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/ja_JP/stable_kernel_rules.txt |  106 +++++++++++++-------------
 Documentation/stable_kernel_rules.txt       |    7 +-
 Documentation/vm/slabinfo.c                 |    2 +-
 arch/powerpc/platforms/pseries/power.c      |    2 +-
 drivers/base/bus.c                          |    9 +-
 drivers/base/driver.c                       |    3 +
 drivers/base/power/main.c                   |    2 +-
 drivers/cpufreq/cpufreq.c                   |    8 --
 drivers/ide/ide.c                           |    2 +-
 drivers/uio/uio.c                           |   54 +++++++++----
 kernel/module.c                             |    7 +-
 11 files changed, 109 insertions(+), 93 deletions(-)

---------------

Balaji Rao (1):
      cpufreq: fix kobject reference count handling

Bartlomiej Zolnierkiewicz (1):
      ide: mark "ide=reverse" option as obsolete

Brandon Philips (1):
      UIO: fix Greg's stupid changes

Christoph Lameter (1):
      slabinfo: fall back from /sys/kernel/slab to /sys/slab

Cornelia Huck (1):
      Driver core: Fix error handling in bus_add_driver().

Kay Sievers (1):
      modules: do not try to add sysfs attributes if !CONFIG_SYSFS

Rafael J. Wysocki (1):
      PM: Remove unbalanced mutex_unlock() from dpm_resume()

Randy Dunlap (1):
      driver-core: fix kernel-doc function parameters

Stefan Richter (1):
      stable_kernel_rules: fix must already be in mainline

Stephen Rothwell (1):
      POWERPC: fix typo in pseries/power.c

Tsugikazu Shibata (1):
      Fix broken utf-8 encodings in ja_JP translation of stable_kernel_rules.txt

