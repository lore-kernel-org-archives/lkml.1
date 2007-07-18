Return-Path: <linux-kernel-owner+w=401wt.eu-S935777AbXGRXAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935777AbXGRXAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbXGRW5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:57:52 -0400
Received: from stinky.trash.net ([213.144.137.162]:50228 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580AbXGRW5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:57:51 -0400
Message-ID: <469E9AC8.3090603@trash.net>
Date: Thu, 19 Jul 2007 00:57:12 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: andrei radulescu-banu <iubica2@yahoo.com>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Linux, tcpdump and vlan
References: <878246.51044.qm@web56608.mail.re3.yahoo.com>
In-Reply-To: <878246.51044.qm@web56608.mail.re3.yahoo.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

andrei radulescu-banu wrote:
> [...]
> 
> In conclusion, here is the buglist:  
> 1). If set promiscuous, the e1000 should disable any vlan rx filtering, so that it can receive vlan frames of other vlan id's. Other ethernet drivers probably need fixed as well.
>   2). The packet layer should change the rx skb device from the vlan 'fake' device (eth0.2) to the corresponding physical device (eth0), so when we run tcpdump on eth0 we see all vlan-tagged and non-vlan-tagged frames
>   3). The packet socket layer should insert the vlan tag header before passing frames to the upper layer, so tcpdump can display them.


Put another way, once you enable VLAN header stripping, you
won't see the headers for *any* VLAN, not only for those you're
actually running locally. This is also a problem for devices
like macvlan, where it would be desirable to make use of
hardware VLAN accerlation. I was thinking about storing the
information somewhere in the packets meta-data on both RX and
TX paths, that would also allow tcpdump to properly display
packets.

I have planned to look into this when I find some time.
Your suggestion of disabling VLAN acceleration in promiscous
mode sounds like a reasonable solution until then ..

