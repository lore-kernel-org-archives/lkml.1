Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYI2SWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYI2SWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYI2SWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:22:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:46121 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYI2SWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,333,1220252400"; 
   d="scan'208";a="341864584"
Date: Mon, 29 Sep 2008 11:22:38 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
cc: Karsten Keil <kkeil@suse.de>, Jiri Kosina <jkosina@suse.cz>,
       chris.jones@canonical.com, tim.gardner@canonical.com,
       agospoda@redhat.com, arjan@linux.jf.intel.com,
       "Graham, David" <david.graham@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>
Subject: e1000e NVM corruption issue status (updated 29-Sept-2008)
Message-ID: <Pine.WNT.4.63.0809291024410.2188@jbrandeb-desk.amr.corp.intel.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my latest information regarding this bug.

Problem: some users report that with many of the latest beta distros, 
during a reboot when e1000e loads it says "NVM checksum is not valid" and 
the driver fails to load.

updated hardware affected list:
laptops and desktops with 82566 or 82567 based LAN parts, which are 
machines with the ICH8, ICH9, ICH10R chipsets and a variety of processors. 
The machines I know of that have reported the issue include

Lenovo X300
HP 2510p
Intel DP35JO
Lenovo T61 (possibly)
Lenovo X61 (possibly)
Intel DG45ID

We received a system that had been corrupted and are doing forensics on it 
before we start running tries at a reproduction.

Many other systems are currently attempting reproduction here at Intel, 
but we don't have a solid repro here yet.

Novell's SuSE engineers report they have reproduced on at least one 
machine by repeatedly running the install of SuSE beta 1 through stage 2 
install, then rebooting.

Intel's current efforts include:
a) reproduction
b) patch set to prevent corruption of gigabit region in flash by setting 
   protection registers
c) patch to set_memory_ro our memory mapped flash configuration registers
d) debug patches for e1000e, including loading the driver even if 
   checksum fails.
e) patch to allow e1000e to restore the nvm's gigabit region from a 
   previously saved image.

Bandaiding over this image with patches b) c) *might* prevent any more 
corruptions but won't probably find the bug.

Also of note, a patch was posted from Tim Gardner to iounmap the BAR1 of 
e1000e devices when it is not in use but we believe that patch to be 
functionally the same (but not as useful) as the patch c) above.

Jesse
