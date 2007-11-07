Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbXKGWVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbXKGWVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXKGWVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:21:32 -0500
Received: from rtr.ca ([76.10.145.34]:4032 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbXKGWVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:21:31 -0500
Message-ID: <47323A69.5050206@rtr.ca>
Date: Wed, 07 Nov 2007 17:21:29 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] r8169 fix regression on ASUS motherboards
References: <4731E2AB.5080703@rtr.ca> <4731FDB7.8010505@rtr.ca> <20071107220455.GA15367@electric-eye.fr.zoreil.com>
In-Reply-To: <20071107220455.GA15367@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Mark Lord <lkml@rtr.ca> :
>> Fix r8169 regression on ASUS motherboards.
>>
>> The r8169 ethernet driver worked fine in 2.6.23, but fails
>> in 2.6.24-rc* for the onboard ethernet of ASUS P5B series motherboards.
>> This patch fixes it again.
> [...]
>> --- broken/drivers/net/r8169.c	2007-11-07 12:32:29.000000000 -0500
>> +++ linux/drivers/net/r8169.c	2007-11-07 12:55:07.000000000 -0500
>> @@ -1325,6 +1325,7 @@
>> 		rtl8169sb_hw_phy_config(ioaddr);
>> 		break;
>> 	case RTL_GIGA_MAC_VER_11:
>> +		break;
>> 	case RTL_GIGA_MAC_VER_12:
>> 	case RTL_GIGA_MAC_VER_17:
>> 		rtl8168b_hw_phy_config(ioaddr);
> 
> I am not convinced, the broken ones include some RTL_GIGA_MAC_VER_12
> too, namely XID = 0x38000000.
..

Tested and working here on VER_11.  I don't have a VER_12, so I left that as-is.
If you want to fix that as well, just move the new "break;" down one line.

The rest of the broken commit works fine without the new call
to rtl8168b_hw_phy_config(ioaddr).

It's been weeks now, so please FIX it now.

Thanks.





