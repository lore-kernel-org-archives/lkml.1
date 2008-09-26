Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYIZCNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYIZCNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYIZCNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:13:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:11818 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbYIZCNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:13:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="384528606"
Date: Thu, 25 Sep 2008 19:13:17 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251912210.1736@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e1000e: dump eeprom to dmesg for ich8/9

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

dumping the eeprom for now seems like a bit of a verbose
hack, but might be useful when we want to restore it.

if syslogd (or something like) isn't running it won't be kept
however.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000e/netdev.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index ad026d0..c5a99ed 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4600,6 +4600,11 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 
 	e1000_eeprom_checks(adapter);
 
+	/* debug code ... dump the first bytes of the eeprom for
+	 * ich parts that might get a corruption */
+	if (adapter->flags & FLAG_IS_ICH)
+		e1000e_dump_eeprom(adapter);
+
 	/* don't block initalization here due to bad MAC address */
 	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
 	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);
