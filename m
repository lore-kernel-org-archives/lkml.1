Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbZJIXSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbZJIXSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761795AbZJIXSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:18:08 -0400
Received: from kroah.org ([198.145.64.141]:36865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761736AbZJIXSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:18:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:02 2009
Message-Id: <20091009231002.649026484@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/26] net: Fix wrong sizeof
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=net-fix-wrong-sizeof.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit b607bd900051efc3308c4edc65dd98b34b230021 upstream.

Which is why I have always preferred sizeof(struct foo) over
sizeof(var).

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/networking/timestamping/timestamping.c |    2 +-
 drivers/net/iseries_veth.c                           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/networking/timestamping/timestamping.c
+++ b/Documentation/networking/timestamping/timestamping.c
@@ -381,7 +381,7 @@ int main(int argc, char **argv)
 	memset(&hwtstamp, 0, sizeof(hwtstamp));
 	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
 	hwtstamp.ifr_data = (void *)&hwconfig;
-	memset(&hwconfig, 0, sizeof(&hwconfig));
+	memset(&hwconfig, 0, sizeof(hwconfig));
 	hwconfig.tx_type =
 		(so_timestamping_flags & SOF_TIMESTAMPING_TX_HARDWARE) ?
 		HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -495,7 +495,7 @@ static void veth_take_cap_ack(struct vet
 			   cnx->remote_lp);
 	} else {
 		memcpy(&cnx->cap_ack_event, event,
-		       sizeof(&cnx->cap_ack_event));
+		       sizeof(cnx->cap_ack_event));
 		cnx->state |= VETH_STATE_GOTCAPACK;
 		veth_kick_statemachine(cnx);
 	}


