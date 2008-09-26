Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYIZBvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYIZBvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYIZBvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:51:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:48406 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYIZBvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:51:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="384523987"
Date: Thu, 25 Sep 2008 18:50:57 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
cc: Jiri Kosina <jkosina@suse.cz>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       jesse.brandeburg@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: e1000e NVM corruption issue status
In-Reply-To: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick summary of the issue, if you think you have more data, please 
reply.  If you have had this issue, please reply with results of "cat 
/proc/iomem" and "lspci".  It will help us correlate data.

Problem: some users report that with many of the latest beta distros, 
during a reboot when e1000e loads it says "NVM checksum is not valid" and 
the driver fails to load.

Result: At this point it appears that most users can load the e1000e 
driver if they skip the nvm validation error exit.  LAN traffic may or may 
not work at this point.  Some users report they can dump their eeprom 
using ethtool -e and see some varying data, most report the eeprom read 
returns all ff ff ff

NOTE: if you have not had this problem, but wish to continue using e1000e 
I strongly suggest you do a "ethtool -e eth0 > savemyeep.txt"

Many of the reports seem to be related in time to a graphics crash, no one 
has been able to give us more detail about how to reproduce.  We NEED HELP 
reproducing this.  Steps, hints, anything.  We are trying rebooting, 
suspending, opensuse, fedora, ubuntu, and several hardware platforms, etc.

This seems to effect both 32 and 64 bit kernels, but we haven't heard much 
either way.

hardware affected:
laptops and desktops with 82566 or 82567 based LAN parts, which are 
machines with the ICH8 and ICH9 chipsets and a variety of processors.
The machines I know of that have reported the issue include
Lenovo X300
HP 2510p
Intel DP35JO
Lenovo T61 (possibly)
Lenovo X61 (possibly)

Next steps:
We are still trying to reproduce the issue locally, we should have a 
machine here tomorrow that reportedly had the issue with ubuntu.

We have a series of kernel patches that I will reply to this mail with 
that may help users willing to test.

We should have ready (hopefully tomorrow) an app that should be able to 
restore eeproms as long as the driver can still load.

We also have a band-aid patch that should allow "locking" of the NVM area 
to prevent an errant write, we are looking to post that tomorrow.  This 
should prevent the damage but not really find the culprit.

Jesse
