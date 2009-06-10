Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZFJGIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZFJGIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbZFJGH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:07:58 -0400
Received: from mail.vyatta.com ([76.74.103.46]:57363 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZFJGH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:07:57 -0400
Date: Tue, 9 Jun 2009 23:07:54 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Jay Vosburgh <fubar@us.ibm.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] bonding: fix multiple module load problem
Message-ID: <20090609230754.77fb1e71@nehalam>
In-Reply-To: <4A2E8D62.6090004@trash.net>
References: <20090608151127.70146505@nehalam>
 <200906091406.45463.arnd@arndb.de>
 <20090609080232.45f81833@nehalam>
 <4A2E80B3.6010600@trash.net>
 <4752.1244564082@death.nxdomain.ibm.com>
 <4A2E8D62.6090004@trash.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users still load bond module multiple times to create bonding
devices.  This accidentally was broken by a later patch about
the time sysfs was fixed.  According to Jay, it was broken
by:
   commit b8a9787eddb0e4665f31dd1d64584732b2b5d051
   Author: Jay Vosburgh <fubar@us.ibm.com>
   Date:   Fri Jun 13 18:12:04 2008 -0700

     bonding: Allow setting max_bonds to zero

Note: sysfs and procfs still produce WARN() messages when this is done
so the sysfs method is the recommended API.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
Since 2.6.30 is now out this needs to goto the first stable 2.6.30.1
tree.

--- a/drivers/net/bonding/bond_sysfs.c	2009-06-09 10:07:29.618979856 -0700
+++ b/drivers/net/bonding/bond_sysfs.c	2009-06-09 10:18:04.039973238 -0700
@@ -1538,6 +1538,7 @@ int bond_create_sysfs(void)
 			printk(KERN_ERR
 			       "network device named %s already exists in sysfs",
 			       class_attr_bonding_masters.attr.name);
+		ret = 0;
 	}
 
 	return ret;
