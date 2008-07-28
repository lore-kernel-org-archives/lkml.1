Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYG1WMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYG1WMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYG1WMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:12:16 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55621 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbYG1WMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:12:15 -0400
Subject: ipwireless: fix compile failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Sterba <dsterba@suse.cz>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-net@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 17:11:44 -0500
Message-Id: <1217283104.3503.170.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a brown paper bag compile failure introduced by this patch

commit a01386924874c4d6d67f8a34e66f04452c2abb69
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Jul 28 16:53:32 2008 +0200

    ipwireless: Preallocate received packet buffers with MRU size
 
Really, it can't ever have been even compile tested.  It looks like the
closing bracket is in the wrong place, so this is the fix.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 7d500f8..4c1820c 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -568,7 +568,7 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 			list_del(&packet->queue);
 		} else {
 			const int min_capacity =
-				ipwireless_ppp_mru(hw->network + 2);
+				ipwireless_ppp_mru(hw->network) + 2;
 			int new_capacity;
 
 			spin_unlock_irqrestore(&hw->lock, flags);


