Return-Path: <linux-kernel-owner+w=401wt.eu-S937424AbXLQXDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937424AbXLQXDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937311AbXLQXCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:02:42 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52480 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937309AbXLQXCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:02:40 -0500
Date: Tue, 18 Dec 2007 00:02:37 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Miller <davem@davemloft.net>
cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6.25 1/8] Create ipv4_is_<type>(__be32 addr)
 functions
In-Reply-To: <20071217.144319.93471413.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0712180001110.32270@fbirervta.pbzchgretzou.qr>
References: <1197589141-7020-1-git-send-email-joe@perches.com>
 <Pine.LNX.4.64.0712172333550.32270@fbirervta.pbzchgretzou.qr>
 <20071217.144319.93471413.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 17 2007 14:43, David Miller wrote:
>> On Dec 13 2007 15:38, Joe Perches wrote:
>> >+static inline bool ipv4_is_private_10(__be32 addr)
>> >+{
>> >+	return (addr & htonl(0xff000000)) == htonl(0x0a000000);
>> >+}
>> 
>> What are these functions needed for, even? There does not seem to be
>> any code (at least in davem's net-2.6.25:net/ipv4/, where I dared to grep)
>> that uses them.
>
>You really need to grep the whole tree, never ever decrease the scope
>of directories to search if you want to see if an interface is used.
>
Hah you got me there :)

>It's used by some ipv6 address translation code as well as some
>bits in SCTP:
>
>include/net/addrconf.h:	eui[0] = (ipv4_is_zeronet(addr) || ipv4_is_private_10(addr) ||
>net/sctp/protocol.c:	} else if (ipv4_is_private_10(addr->v4.sin_addr.s_addr) ||
>
>So lazy...

I just discovered git-grep...
