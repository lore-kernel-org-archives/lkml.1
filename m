Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYILDFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYILDFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 23:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYILDFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 23:05:06 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51747 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756817AbYILDFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 23:05:02 -0400
Message-ID: <48C9DC5C.3040109@lwfinger.net>
Date: Thu, 11 Sep 2008 22:05:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: I need help with a sparse warning
References: <48C9D040.8010107@lwfinger.net> <ada4p4mm6iy.fsf@cisco.com>
In-Reply-To: <ada4p4mm6iy.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > In file drivers/net/wireless/p54/p54common.c, the statement
>  > 
>  >        priv->rx_mtu = (size_t) le16_to_cpu((__le16)bootrec->data[10]);
> 
> [I don't see this code in Linus's tree]

It is in wireless-testing.

> 
> the code in question looks buggy to me.  Since bootrec->data[10] is u32,
> casting it to a 16-bit type is going to take a different 2 bytes out of
> the 4 bytes depending on the endianness of the system the driver is
> built for.  And I assume you are parsing some fixed-layout thing that
> the firmware is giving you or something like that.
> 
> I would guess you want something like:
> 
> 	priv->rx_mtu = le16_to_cpu(((__force __le16 *) bootrec->data)[20]);
> 
> (__force is what shuts up sparse, and as far as I can see, the size_t
> cast is useless, since the result will be promoted anyway)

Yes, that one works. As you suspected, this section is parsing data 
from the firmware.

When I started, there were 18 sparse warnings, and a number of them 
were accesses of little-endian variables without an appropriate 
leXX_to_cpu() conversion. Obviously, this code has never been tested 
on a big-endian machine.

Thanks,

Larry

