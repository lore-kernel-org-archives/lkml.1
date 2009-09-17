Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZIQAyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZIQAyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZIQAyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:54:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56026 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZIQAyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:54:43 -0400
Date: Thu, 17 Sep 2009 10:54:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Ken Kawasaki <ken_kawasaki@spring.nifty.jp>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the tty.current tree with the
 net-current tree
Message-Id: <20090917105442.297b6ea1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the tty.current tree got a conflict in
drivers/serial/serial_cs.c between commit
531afd64d027e3d798c416b2b37b3cfb1de417d9 ("pcnet_cs: add cis of Linksys
multifunction pcmcia card") from the net-current tree and commit
5cea4a4e15a918f19d32fd3dc9a5056f333847c3 ("tty: serial/pcmcia: add ID for
Advantech card") from the tty.current tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/serial/serial_cs.c
index ed4648b,6ecb51b..0000000
--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@@ -883,10 -883,11 +883,11 @@@ static struct pcmcia_device_id serial_i
  	PCMCIA_DEVICE_CIS_MANF_CARD(0x0192, 0x0710, "SW_7xx_SER.cis"),	/* Sierra Wireless AC710/AC750 GPRS Network Adapter R1 */
  	PCMCIA_DEVICE_CIS_MANF_CARD(0x0192, 0xa555, "SW_555_SER.cis"),  /* Sierra Aircard 555 CDMA 1xrtt Modem -- pre update */
  	PCMCIA_DEVICE_CIS_MANF_CARD(0x013f, 0xa555, "SW_555_SER.cis"),  /* Sierra Aircard 555 CDMA 1xrtt Modem -- post update */
 -	PCMCIA_DEVICE_CIS_PROD_ID12("MultiTech", "PCMCIA 56K DataFax", 0x842047ee, 0xc2efcf03, "MT5634ZLX.cis"),
 +	PCMCIA_DEVICE_CIS_PROD_ID12("MultiTech", "PCMCIA 56K DataFax", 0x842047ee, 0xc2efcf03, "cis/MT5634ZLX.cis"),
+ 	PCMCIA_DEVICE_CIS_PROD_ID12("ADVANTECH", "COMpad-32/85B-2", 0x96913a85, 0x27ab5437, "COMpad2.cis"),
  	PCMCIA_DEVICE_CIS_PROD_ID12("ADVANTECH", "COMpad-32/85B-4", 0x96913a85, 0xcec8f102, "COMpad4.cis"),
  	PCMCIA_DEVICE_CIS_PROD_ID123("ADVANTECH", "COMpad-32/85", "1.0", 0x96913a85, 0x8fbe92ae, 0x0877b627, "COMpad2.cis"),
 -	PCMCIA_DEVICE_CIS_PROD_ID2("RS-COM 2P", 0xad20b156, "RS-COM-2P.cis"),
 +	PCMCIA_DEVICE_CIS_PROD_ID2("RS-COM 2P", 0xad20b156, "cis/RS-COM-2P.cis"),
  	PCMCIA_DEVICE_CIS_MANF_CARD(0x0013, 0x0000, "GLOBETROTTER.cis"),
  	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.","SERIAL CARD: SL100  1.00.",0x19ca78af,0xf964f42b),
  	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.","SERIAL CARD: SL100",0x19ca78af,0x71d98e83),
