Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYI3DXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYI3DXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYI3DUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:20:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:21516 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYI3DUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:20:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="445147617"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 09/12] e1000e: dump eeprom to dmesg for ich8/9
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 29 Sep 2008 20:20:03 -0700
Message-ID: <20080930032003.22950.38716.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:20:03.0262 (UTC) FILETIME=[6DBCEDE0:01C922AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dumping the eeprom for now seems like a bit of a verbose
hack, but might be useful when we want to restore it.

if syslogd (or something like) isn't running it won't be kept
however.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000e/netdev.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 48b0ded..57cead3 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4598,6 +4598,11 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 
 	e1000_eeprom_checks(adapter);
 
+	/* debug code ... dump the first bytes of the eeprom for
+	 * ich parts that might get a corruption */
+	if (adapter->flags & FLAG_IS_ICH)
+		e1000e_dump_eeprom(adapter);
+
 	/* don't block initalization here due to bad MAC address */
 	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
 	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);

