Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYJBASq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYJBASq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJBASc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:18:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:3768 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYJBASb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:18:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,346,1220252400"; 
   d="scan'208";a="622433232"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH 2.6.27-rc8 0/1] e1000e nvm fix
To: torvalds@linux-foundation.org, jeff@garzik.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       arjan@linux.intel.com
Date: Wed, 01 Oct 2008 17:18:30 -0700
Message-ID: <20081002001830.5951.3123.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2008 00:18:30.0679 (UTC) FILETIME=[66142A70:01C92424]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please apply to 2.6.27

This is related to regression bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=11382

This patch is meant to prevent all future corruptions of the
e1000e NVM (non volatile memory) after the driver is loaded.  The
registers stay locked until the machine is power cycled.

This should allow us to move forward with debugging without
allowing any other bad element or the e1000e driver, to write to
the NVM area unexpectedly.

Currently we (Intel Ethernet) are reproducing the issue on
multiple machines in house, we are working on the issue with the
other core Linux teams here at Intel and within the community. No
resolution yet but we are much closer now.

Later we will post patches to help users who have had this
problem restore their eeprom from either a saved image from
ethtool -e or from another identical system.

There is a set of patches to help clean up the driver's use of
the hardware/software semaphore, but those are un-necessary to be
immediately applied once we're locking the NVM.  We will push
those for inclusion within the merge window for 2.6.28.

---

Bruce Allan (1):
      e1000e: write protect ICHx NVM to prevent malicious write/erase


 drivers/net/e1000e/e1000.h   |    2 +
 drivers/net/e1000e/ethtool.c |    3 ++
 drivers/net/e1000e/ich8lan.c |   58 ++++++++++++++++++++++++++++++++++++++++++
 drivers/net/e1000e/netdev.c  |   10 +++++--
 drivers/net/e1000e/param.c   |   30 ++++++++++++++++++++++
 5 files changed, 100 insertions(+), 3 deletions(-)

--
Jesse Brandeburg
