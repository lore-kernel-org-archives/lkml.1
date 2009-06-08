Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZFHVfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZFHVfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZFHVey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:34:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53564
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610AbZFHVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:34:53 -0400
Date: Mon, 08 Jun 2009 14:34:54 -0700 (PDT)
Message-Id: <20090608.143454.161329513.davem@davemloft.net>
To: gil.beniamini@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: SOCK_RAW does not receive broadcast (with VLAN unless PROMISC)
From: David Miller <davem@davemloft.net>
In-Reply-To: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>
References: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n58LZk54012529

From: Gil Beniamini <gil.beniamini@gmail.com>
Date: Mon, 8 Jun 2009 21:05:25 +0300

> Dear Linux Experts,
> 
> My application is using PF_PACKET and SOCK_RAW in order to receive all
> Ethernet packets for the machine-unicast MAC plus all broadcast
> packets (like ARP broadcast).

Please post networking questions and reports to netdev@vger.kernel.org
which is where the networking experts are subscribed.

I am also fully aware of your problem as Linus Torvalds forwarded
your report to me last week, you just need to be patient as I simply
haven't had a chance to look into it yet.

> That worked OK with kernel 2.6.20 (Ubuntu 7.04 with or without VLAN).
> 
> Now with kernel 2.6.28 (Ubuntu 9.04) it works OK only without-VLAN,
> but with VLAN the application receive only packets for the
> machine-unicast MAC, but no broadcast (like ARP broadcast) packets,
> only if I set the socket to PROMISC mode, I start receive also
> broadcast packets.
> 
> To me it seems a bug, as SOCK_RAW should pass all â€˜receivedâ€™ packet
> (including broadcast) to the application, without the need for PROMISC
> (which cause my machine to receive other machine unicast  packets, and
> filter those by software)!
> 
> The original application:
> 
> sock=socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
> memset((char *) &sockad, 0, sizeof(sockad));
> sockad.sll_family = PF_PACKET;
> sockad.sll_protocol = htons(ETH_P_ALL);
> sockad.sll_ifindex = ethreq.ifr_ifindex;//the relevant unit number
> 
> 
> 
> Now the workaround is to set (unwanted) PROMISC mode:
> 
> ioctl(sock,SIOCGIFFLAGS,&ethreq);
> ethreq.ifr_flags|=IFF_PROMISC; // why does 9.04 need this (+0x100) at
> least once?!
> ioctl(sock,SIOCSIFFLAGS,&ethreq);
> 
> 
> Many thanks in advance,
> Gil Beniamini
> gil.beniamini@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
