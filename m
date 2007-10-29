Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbXJ2PF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbXJ2PF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXJ2PFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:05:22 -0400
Received: from 66-17-170-34.static.mesanetworks.net ([66.17.170.34]:58812 "EHLO
	wonderland.us.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644AbXJ2PFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:05:21 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 11:05:21 EDT
Message-ID: <4725F416.2030100@wonderland.us.com>
Date: Mon, 29 Oct 2007 08:54:14 -0600
From: Tom Southerland <toms@wonderland.us.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: drivers/net/sunhme.c patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a unique mac address for all interfaces
for the Sun QFE card (non-sparc).  It takes the base mac from
the first interface and increments the mac address for the
other interfaces.

It still preserves the 'macaddr' parameter so if desired, it
can still be used.

Before patching:

eth0      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
eth1      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
eth2      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
eth3      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB

After patching:

eth0      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BB
eth1      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BC
eth2      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BD
eth3      Link encap:Ethernet  HWaddr 00:03:BA:17:4C:BE

Cheers,

Tom



--- linux-2.6.23.1/drivers/net/sunhme.c.orig    2007-10-29 07:58:25.000000000 -0600
+++ linux-2.6.23.1/drivers/net/sunhme.c 2007-10-29 08:53:03.000000000 -0600
@@ -3083,6 +3083,11 @@ static int __devinit happy_meal_pci_prob
                 }
  #else
                 get_hme_mac_nonsparc(pdev, &dev->dev_addr[0]);
+                if(macaddr[5] == 0){
+                 for (i = 0; i < 6; i++)
+                       macaddr[i] = dev->dev_addr[i];
+                 macaddr[5]++;
+                }
  #endif
         }

