Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbXF2Ljl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbXF2Ljl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbXF2Lje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:39:34 -0400
Received: from stinky.trash.net ([213.144.137.162]:42594 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbXF2Ljd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:39:33 -0400
Message-ID: <4684EF6A.7070109@trash.net>
Date: Fri, 29 Jun 2007 13:39:22 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andreas Steinmetz <ast@domdv.de>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
References: <4684E853.20900@domdv.de>
In-Reply-To: <4684E853.20900@domdv.de>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Steinmetz wrote:
> There seems to be a problem with mss to pmtu clamping for incoming syn
> packets on reply to an outgoing connection on a ppp interface. The mss
> of the outgoing syn packets is always always clamped to the pmtu, I did
> check this with a target host I do have access to. The incoming syn
> reply to such a packet, however, is mss clamped only sometimes and this
> seems to depend on the DSL line used.
> 
> The kernels tested were 2.6.20.1, 2.6.20.3 and 2.6.22rc6.
> 
> Test setup: Two DSL lines, otherwise identical setup (same masquerading
> linux gateway, same DSL account, same DSL modem, same DSL line provider,
> same target host, request from and tcpdump on the same client).
> 
> Linux Client<->Masquerading Linux Gateway<->DSL Modem<->DSL Line<->...
> 
> DSL line 1, working:
> 
> 22:26:39.319281 IP (tos 0x0, ttl  64, id 22377, offset 0, flags [DF],
> length: 48
> ) 192.168.0.253.1164 > 64.34.165.170.80: S [tcp sum ok]
> 1465827859:1465827859(0)
>  win 5840 <mss 1460,nop,nop,sackOK>
> 22:26:39.459314 IP (tos 0x0, ttl  51, id 0, offset 0, flags [DF],
> length: 48) 64
> .34.165.170.80 > 192.168.0.253.1164: S [tcp sum ok]
> 3667852791:3667852791(0) ack
>  1465827860 win 5840 <mss 1452,nop,nop,sackOK>
> 
> The tcpdump on the client shows that the mss of the incoming syn reply
> packet is clamped to the ppp interface mtu.
> 
> DSL line 2, not working:
> 
> 22:03:57.725998 IP (tos 0x0, ttl  64, id 55984, offset 0, flags [DF],
> length: 48
> ) 192.168.0.253.1600 > 64.34.165.170.80: S [tcp sum ok]
> 36968258:36968258(0) win
>  5840 <mss 1460,nop,nop,sackOK>
> 22:03:57.866966 IP (tos 0x0, ttl  51, id 0, offset 0, flags [DF],
> length: 48) 64
> .34.165.170.80 > 192.168.0.253.1600: S [tcp sum ok]
> 2226854208:2226854208(0) ack
>  36968259 win 5840 <mss 1460,nop,nop,sackOK>
> 
> The tcpdump on the client shows that the mss of the incoming syn reply
> packet is *NOT* clamped to the ppp interface mtu.


You forgot to mention *how* you're clamping the MSS. Using
TCPMSS? Do you have a rule for incoming packets?

