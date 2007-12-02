Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbXLBNK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbXLBNK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbXLBNKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:10:09 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:34895 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbXLBNKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:10:07 -0500
From: Wagner Ferenc <wferi@niif.hu>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 3/5] net/bonding: Purely cosmetic: rename a local variable
References: <87wss3jin5.fsf@szonett.ki.iif.hu>
	<871wabkxcd.fsf@szonett.ki.iif.hu>
	<20071127194929.757e4ebe.randy.dunlap@oracle.com>
	<87bq9ekb8m.fsf@szonett.ki.iif.hu> <474D8B83.9050609@oracle.com>
	<87wss1c3d8.fsf_-_@szonett.ki.iif.hu> <26966.1196298795@death>
Date: Sun, 02 Dec 2007 14:09:55 +0100
In-Reply-To: <26966.1196298795@death> (Jay Vosburgh's message of "Wed, 28 Nov
	2007 17:13:15 -0800, Wed, 28 Nov 2007 17:01:23 -0800")
Message-ID: <87r6i5z1i4.fsf_-_@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code for rendering multivalue sysfs files occurs three times
in this module.  Rename 'buffer' to 'buf' in the first, for
the sake of consistency.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/net/bonding/bond_sysfs.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 6bb91e2..5c31f5c 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -74,7 +74,7 @@ struct rw_semaphore bonding_rwsem;
  * "show" function for the bond_masters attribute.
  * The class parameter is ignored.
  */
-static ssize_t bonding_show_bonds(struct class *cls, char *buffer)
+static ssize_t bonding_show_bonds(struct class *cls, char *buf)
 {
 	int res = 0;
 	struct bonding *bond;
@@ -86,13 +86,12 @@ static ssize_t bonding_show_bonds(struct class *cls, char *buffer)
 			/* not enough space for another interface name */
 			if ((PAGE_SIZE - res) > 10)
 				res = PAGE_SIZE - 10;
-			res += sprintf(buffer + res, "++more++ ");
+			res += sprintf(buf + res, "++more++ ");
 			break;
 		}
-		res += sprintf(buffer + res, "%s ",
-			       bond->dev->name);
+		res += sprintf(buf + res, "%s ", bond->dev->name);
 	}
-	if (res) buffer[res-1] = '\n'; /* eat the leftover space */
+	if (res) buf[res-1] = '\n'; /* eat the leftover space */
 	up_read(&(bonding_rwsem));
 	return res;
 }
-- 
1.4.4.4

