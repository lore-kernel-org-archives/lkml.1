Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbZAHSzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbZAHSzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761825AbZAHSzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:55:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59716
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761812AbZAHSz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:55:29 -0500
Date: Thu, 08 Jan 2009 10:55:31 -0800 (PST)
Message-Id: <20090108.105531.176161465.davem@davemloft.net>
To: cooloney@kernel.org
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       graf.yang@analog.com
Subject: Re: [PATCH 2/2] netdev: bfin_mac: enable VLAN support in Blackfin
 MAC driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1231344879-26069-3-git-send-email-cooloney@kernel.org>
References: <1231344879-26069-1-git-send-email-cooloney@kernel.org>
	<1231344879-26069-3-git-send-email-cooloney@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <cooloney@kernel.org>
Date: Thu,  8 Jan 2009 00:14:39 +0800

> +#define VLAN_ETHER_TYPE 0x8100

Please use ETH_P_8021Q from linux/if_ether.h instead of inventing
your own definition.

> +	/* The legal length of the frame is increased to 1538 bytes */
> +	/*bfin_write_EMAC_VLAN2(VLAN_ETHER_TYPE);*/

Please do not add code that is just going to be commented
out and not used.

Also, I disagree with the:

+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)

conditional.  Probably this part of the chip should be programmed
unconditionally.

We can get VLAN packets received and sent, using AF_PACKET
sockets, for example.  The chip should still respect those
even if VLAN proper is not being utilized.
