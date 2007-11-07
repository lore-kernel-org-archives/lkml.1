Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbXKGWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbXKGWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbXKGWZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:25:49 -0500
Received: from rtr.ca ([76.10.145.34]:1930 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbXKGWZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:25:48 -0500
Message-ID: <47323B6B.9000909@rtr.ca>
Date: Wed, 07 Nov 2007 17:25:47 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] r8169 fix regression on ASUS motherboards (updated)
References: <4731E2AB.5080703@rtr.ca> <4731FDB7.8010505@rtr.ca> <20071107220455.GA15367@electric-eye.fr.zoreil.com> <47323A69.5050206@rtr.ca>
In-Reply-To: <47323A69.5050206@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Francois Romieu wrote:
>..
>> I am not convinced, the broken ones include some RTL_GIGA_MAC_VER_12
>> too, namely XID = 0x38000000.
..

Here is the updated patch for both VER_11 and VER_12.
Let's get this in, as the driver has been broken for weeks now.

* * * *

Fix r8169 regression on ASUS motherboards.

Second attempt.  This one fixes both VER_11 and VER_12 MACs.

The r8169 ethernet driver worked fine in 2.6.23, but fails
in 2.6.24-rc* for the onboard ethernet of ASUS P5B series motherboards.
This patch fixes it again.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- broken/drivers/net/r8169.c	2007-11-03 16:24:16.000000000 -0400
+++ linux/drivers/net/r8169.c	2007-11-07 17:22:59.000000000 -0500
@@ -1326,6 +1326,7 @@
 		break;
 	case RTL_GIGA_MAC_VER_11:
 	case RTL_GIGA_MAC_VER_12:
+		break;
 	case RTL_GIGA_MAC_VER_17:
 		rtl8168b_hw_phy_config(ioaddr);
 		break;
