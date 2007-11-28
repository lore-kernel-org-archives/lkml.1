Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbXK1Aye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbXK1Aye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbXK1AyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:54:23 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:45417 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759385AbXK1AyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:54:22 -0500
From: =?us-ascii?Q?=3D=3Futf-8=3Fq=3FFerenc=5FW=3DC3=3DA1gner=3F=3D?= 
	<wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, wferi@niif.hu
Subject: [PATCH 3/3] net/bonding: Purely cosmetic: rename a local variable.
Date: Wed, 28 Nov 2007 01:54:21 +0100
Message-ID: <87sl2rjiki.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Code for rendering multivalue sysfs files occurs three times
in this module.  Rename 'buffer' to 'buf' in the first, for
the sake of consistency.

Signed-off-by: Ferenc Wágner <wferi@niif.hu>
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

