Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZKICDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZKICDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZKICDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:03:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60615 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbZKICDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:03:20 -0500
Date: Mon, 9 Nov 2009 13:03:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfgang Grandegger <wg@grandegger.com>,
       Sebastian Haas <haas@ems-wuensche.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20091109130323.5dcc7829.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/can/usb/ems_usb.c between commit
2b2072e902848a63168570f500a5726744b3873a ("ems_usb: Fix byte order issues
on big endian machines") from the net-current tree and commit
7b6856a0296a8f187bb88ba31fa83a08abba7966 ("can: provide library functions
for skb allocation") from the net tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/can/usb/ems_usb.c
index abdbd9c,3685f3e..0000000
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@@ -315,11 -315,7 +315,7 @@@ static void ems_usb_rx_can_msg(struct e
  	if (skb == NULL)
  		return;
  
- 	skb->protocol = htons(ETH_P_CAN);
- 
- 	cf = (struct can_frame *)skb_put(skb, sizeof(struct can_frame));
- 
 -	cf->can_id = msg->msg.can_msg.id;
 +	cf->can_id = le32_to_cpu(msg->msg.can_msg.id);
  	cf->can_dlc = min_t(u8, msg->msg.can_msg.length, 8);
  
  	if (msg->type == CPC_MSG_TYPE_EXT_CAN_FRAME
