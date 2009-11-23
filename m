Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZKWSKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZKWSKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZKWSKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:10:23 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:49389 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZKWSKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:10:22 -0500
From: Amit Salecha <amit.salecha@qlogic.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Nov 2009 12:09:10 -0600
Subject: RE: linux-next: manual merge of the net tree with the net-current
 tree
Thread-Topic: linux-next: manual merge of the net tree with the net-current
 tree
Thread-Index: Acpr2Dq+419uwBvpSRCrvK2bE1ljiwAj3P0w
Message-ID: <99737F4847ED0A48AECC9F4A1974A4B80CFE956C25@MNEXMB2.qlogic.org>
References: <20091123120043.24cf5c12.sfr@canb.auug.org.au>
In-Reply-To: <20091123120043.24cf5c12.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Nov 2009 18:09:14.0331 (UTC) FILETIME=[108942B0:01CA6C68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen

 This merge looks ok and I have tested it. 

Thanks
Amit Salecha

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Sunday, November 22, 2009 5:01 PM
To: David Miller; netdev@vger.kernel.org
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Amit Salecha
Subject: linux-next: manual merge of the net tree with the net-current tree

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/netxen/netxen_nic_init.c between commit
5d521fd36de4e61ab16a358df54c5babe153396c ("netxen: fix memory
initialization") from the net-current tree and commit
0be367bd5d10634c0836f57a684432fee935d929 ("netxen: reset sequence
changes") from the net tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/netxen/netxen_nic_init.c
index 8a09043,6ee27a6..0000000
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@@ -544,9 -528,8 +528,10 @@@ int netxen_pinit_from_rom(struct netxen
  				continue;
  			if (off == (ROMUSB_GLB + 0x1c)) /* MS clock */
  				continue;
 +			if ((off & 0x0ff00000) == NETXEN_CRB_DDR_NET)
 +				continue;
- 			if (off == (NETXEN_CRB_PEG_NET_1 + 0x18))
+ 			if (off == (NETXEN_CRB_PEG_NET_1 + 0x18) &&
+ 				!NX_IS_REVISION_P3P(adapter->ahw.revision_id))
  				buf[i].data = 0x1020;
  			/* skip the function enable register */
  			if (off == NETXEN_PCIE_REG(PCIE_SETUP_FUNCTION))
