Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYBGQSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYBGQSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYBGQR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:17:58 -0500
Received: from mail.vyatta.com ([216.93.170.194]:48620 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbYBGQR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:17:57 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.436
Date: Thu, 7 Feb 2008 08:17:51 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Marcin Koziej <marcinkoziej@o2.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug? Kernels 2.6.2x drops TCP packets over wireless
 (independent of card used)
Message-ID: <20080207081751.73916530@extreme>
In-Reply-To: <56de948.2f1b076b.47aac980.bfd66@o2.pl>
References: <56de948.2f1b076b.47aac980.bfd66@o2.pl>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 10:04:00 +0100
Marcin Koziej  <marcinkoziej@o2.pl> wrote:

> 
> Hello, I have problem with wireless network connectivity;
> I have tested this on two wireless cards, both giving same results:
> These are:
> 1) 02:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
> working under madwifi-0.9.3.3
> 2) 00:0a.0 Ethernet controller: Linksys, A Division of Cisco Systems [AirConn] INPROCOMM IPN 2220 Wireless LAN Adapter (rev 01)
> working under ndiswrapper on neti2220 driver
> 
> On kernel 2.6.19 both cards are working fine (with same network configuration)
> 
> Problems arise on kernels 2.6.2x, information below is from 2.6.23, but 2.6.24-rc8-git7 also was tested:
> Both cards can associate with ap, and get TCP/IP configuration from the router.
> Both cards can ping the router (0% packet loss), resolve hostnames using DNS (suggesting UDP is working fine).
> However, when any kind of TCP connection is made, it hangs after initial handshake and maybe some ammount of data interchanged. This is checked by tcpdump provided below.
> 
> This happens every time to all tcp connections.
> 

You have the wrong mailing list:

1. You are using proprietary drivers (ndiswrapper and madwifi both have binary only parts).
2. The network developers read netdev@vger.kernel.org

Sounds like you have a TCP corrupting firewall that mangles the window scaling.
This is a known issue with buggy middleboxes that can not be fixed in Linux without
limiting performance.  Complain to the middlebox vendors or IETF.

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
