Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbYBGUGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbYBGUGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933050AbYBGUDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38645 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761333AbYBGUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CVzhc6pHnE55ymxobttNPjiCciyIcYPKyWtiEBwNvktTDJHQmQwIQWzfZ3nKJedFzCzTWOyuAs52XAzjF/PEVUykar1YTWWsFRicPPdv4TczmJizTPJDH7mY7Sdm+jbtmLee/LgEQ9lSoJweQLXF1RKrZKJIJP1Z+btqHi/VMOw=
Message-ID: <6101e8c40802071203o2877ffc0q9e8c4681fe130648@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:34 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {08/14} - [VIA_VELOCITY]: Don't oops on MTU change - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: via-velocity-dont-oops-on-mtu-change-1.patch


From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Thu, 15 Nov 2007 03:47:27 +0000 (-0800)
Subject: [VIA_VELOCITY]: Don't oops on MTU change.
Patch-mainline: v2.6.24-rc3
References: 341537

[VIA_VELOCITY]: Don't oops on MTU change.

mainline: bd7b3f34198071d8bec05180530c362f1800ba46

Simple mtu change when device is down.
Fix http://bugzilla.kernel.org/show_bug.cgi?id=9382.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
---
 drivers/net/via-velocity.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/via-velocity.c	2008-01-03 15:18:35.000000000 -0500
+++ b/drivers/net/via-velocity.c	2008-01-03 15:18:50.000000000 -0500
@@ -1798,6 +1798,11 @@ static int velocity_change_mtu(struct ne
 		return -EINVAL;
 	}

+	if (!netif_running(dev)) {
+		dev->mtu = new_mtu;
+		return 0;
+	}
+
 	if (new_mtu != oldmtu) {
 		spin_lock_irqsave(&vptr->lock, flags);


-- 
Thanks,
Oliver
