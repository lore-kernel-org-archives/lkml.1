Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZJBJak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZJBJak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbZJBJaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:30:39 -0400
Received: from bamako.nerim.net ([62.4.17.28]:61121 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbZJBJag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:30:36 -0400
Date: Fri, 2 Oct 2009 11:30:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       stable@kernel.org
Subject: [PATCH] net: Fix wrong sizeof
Message-ID: <20091002113038.1dc3d284@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which is why I have always preferred sizeof(struct foo) over
sizeof(var).

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
Stable team, the non-documentation part of this fix applies to 2.6.31,
2.6.30 and 2.6.27.

 Documentation/networking/timestamping/timestamping.c |    2 +-
 drivers/net/iseries_veth.c                           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.32-rc1.orig/Documentation/networking/timestamping/timestamping.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.32-rc1/Documentation/networking/timestamping/timestamping.c	2009-10-02 11:07:19.000000000 +0200
@@ -381,7 +381,7 @@ int main(int argc, char **argv)
 	memset(&hwtstamp, 0, sizeof(hwtstamp));
 	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
 	hwtstamp.ifr_data = (void *)&hwconfig;
-	memset(&hwconfig, 0, sizeof(&hwconfig));
+	memset(&hwconfig, 0, sizeof(hwconfig));
 	hwconfig.tx_type =
 		(so_timestamping_flags & SOF_TIMESTAMPING_TX_HARDWARE) ?
 		HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
--- linux-2.6.32-rc1.orig/drivers/net/iseries_veth.c	2009-09-28 10:28:42.000000000 +0200
+++ linux-2.6.32-rc1/drivers/net/iseries_veth.c	2009-10-02 11:07:15.000000000 +0200
@@ -495,7 +495,7 @@ static void veth_take_cap_ack(struct vet
 			   cnx->remote_lp);
 	} else {
 		memcpy(&cnx->cap_ack_event, event,
-		       sizeof(&cnx->cap_ack_event));
+		       sizeof(cnx->cap_ack_event));
 		cnx->state |= VETH_STATE_GOTCAPACK;
 		veth_kick_statemachine(cnx);
 	}


-- 
Jean Delvare
