Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZGAAaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZGAAaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbZGAA35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:29:57 -0400
Received: from kroah.org ([198.145.64.141]:34295 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758918AbZGAA34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:29:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:03:56 2009
Message-Id: <20090701000356.613902877@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 16:59:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@vyatta.com>,
       Jay Vosburgh <fubar@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/30] bonding: fix multiple module load problem
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=bonding-fix-multiple-module-load-problem.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Hemminger <shemminger@vyatta.com>

[ Upstream commit 130aa61a77b8518f1ea618e1b7d214d60b405f10 ]

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
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -1464,6 +1464,7 @@ int bond_create_sysfs(void)
 			printk(KERN_ERR
 			       "network device named %s already exists in sysfs",
 			       class_attr_bonding_masters.attr.name);
+		ret = 0;
 	}
 
 	return ret;


