Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYIZCBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYIZCBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYIZCBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:01:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:7079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbYIZCBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:01:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="384525853"
Date: Thu, 25 Sep 2008 19:01:21 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have a series of kernel patches that I will reply to this mail with 
> that may help users willing to test.

this is the current set of patches that I have to help us debug
and/or fix e1000e issues found during this debug effort for
the corrupt NVM.  the "drop stats lock" - "reset swflag" patches allow 
Thomas' patch for a mutex in the SWFLAG acquire function to run without 
any errors.

the patches are not probably production quality, but seem to work
for myself and thomas on at least a couple of machines.

The non-debug aspects of the patches will likely be pushed later.

At this point I do not believe any of these patches will fix the
NVM corruption issue, but will add to the ability of any tester
to help find the issue, and reduce the chance that it is any issue we 
(now) know about.

---

Bruce Allan (2):
      e1000e: Use set_memory_ro()/set_memory_rw() to protect flash memory
      Export set_memory_ro() and set_memory_rw() calls. Soon to be used

Jesse Brandeburg (7):
      e1000e: dump eeprom to dmesg for ich8/9
      e1000e: allow bad checksum
      update version
      e1000e: drop stats lock
      e1000e: fix lockdep issues
      e1000e: do not ever sleep in interrupt context
      e1000e: reset swflag after resetting hardware

Thomas Gleixner (1):
      e1000e: debug contention on NVM SWFLAG


 arch/x86/mm/pageattr.c       |    2 +
 drivers/net/e1000e/e1000.h   |    4 +
 drivers/net/e1000e/ethtool.c |    6 +-
 drivers/net/e1000e/hw.h      |    1 
 drivers/net/e1000e/ich8lan.c |   36 ++++++++++
 drivers/net/e1000e/netdev.c  |  158 ++++++++++++++++++++++++++++--------------
 6 files changed, 153 insertions(+), 54 deletions(-)

