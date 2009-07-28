Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZG1Xtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZG1Xtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZG1Xti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:38 -0400
Received: from kroah.org ([198.145.64.141]:35640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbZG1Xth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:52 2009
Message-Id: <20090728234152.140237780@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephane Contri <Stephane.Contri@grassvalley.com>,
       Lennert Buytenhek <buytenh@marvell.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/71] dsa: fix 88e6xxx statistics counter snapshotting
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=dsa-fix-88e6xxx-statistics-counter-snapshotting.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephane Contri <Stephane.Contri@grassvalley.com>

commit 1ded3f59f35a2642852b3e2a1c0fa8a97777e9af upstream.

The bit that tells us whether a statistics counter snapshot operation
has completed is located in the GLOBAL register block, not in the
GLOBAL2 register block, so fix up mv88e6xxx_stats_wait() to poll the
right register address.

Signed-off-by: Stephane Contri <Stephane.Contri@grassvalley.com>
Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/dsa/mv88e6xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dsa/mv88e6xxx.c
+++ b/net/dsa/mv88e6xxx.c
@@ -418,7 +418,7 @@ static int mv88e6xxx_stats_wait(struct d
 	int i;
 
 	for (i = 0; i < 10; i++) {
-		ret = REG_READ(REG_GLOBAL2, 0x1d);
+		ret = REG_READ(REG_GLOBAL, 0x1d);
 		if ((ret & 0x8000) == 0)
 			return 0;
 	}


