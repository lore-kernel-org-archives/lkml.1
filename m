Return-Path: <linux-kernel-owner+w=401wt.eu-S936800AbXLQWh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936800AbXLQWh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932297AbXLQWh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:37:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33724 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbXLQWhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:37:25 -0500
Date: Mon, 17 Dec 2007 23:37:24 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-2.6.25 1/8] Create ipv4_is_<type>(__be32 addr)
 functions
In-Reply-To: <1197589141-7020-1-git-send-email-joe@perches.com>
Message-ID: <Pine.LNX.4.64.0712172333550.32270@fbirervta.pbzchgretzou.qr>
References: <1197589141-7020-1-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 13 2007 15:38, Joe Perches wrote:
>
>Change IPV4 specific macros LOOPBACK MULTICAST LOCAL_MCAST BADCLASS and ZERONET
>macros to inline functions ipv4_is_<type>(__be32 addr)
>
>Adds type safety and arguably some readability.
>
>Changes since last submission:
>
>Removed ipv4_addr_octets function
>Used hex constants
>Converted recently added rfc3330 macros
>
>Signed-off-by: Joe Perches <joe@perches.com>
>---
>+static inline bool ipv4_is_loopback(__be32 addr)
>+{
>+	return (addr & htonl(0xff000000)) == htonl(0x7f000000);
>+}
>+

Can we use __constant_htonl()?

>+static inline bool ipv4_is_private_10(__be32 addr)
>+{
>+	return (addr & htonl(0xff000000)) == htonl(0x0a000000);
>+}

What are these functions needed for, even? There does not seem to be
any code (at least in davem's net-2.6.25:net/ipv4/, where I dared to grep)
that uses them.
