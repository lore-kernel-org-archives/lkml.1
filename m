Return-Path: <linux-kernel-owner+w=401wt.eu-S933493AbZHECdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbZHECdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbZHECdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:33:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35065
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933273AbZHECdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:33:35 -0400
Date: Tue, 04 Aug 2009 19:33:44 -0700 (PDT)
Message-Id: <20090804.193344.71849943.davem@davemloft.net>
To: chiachi@android.com
Cc: john.dykstra1@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Keep interface binding when sending packets with
 ipi_ifindex = 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <6c039e090908041706p6f06ac55ja796ac53855e829a@mail.gmail.com>
References: <6c039e090908040036j38666152y2db1d4c55529eaff@mail.gmail.com>
	<20090804.115701.250978139.davem@davemloft.net>
	<6c039e090908041706p6f06ac55ja796ac53855e829a@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n753UV8B003250

From: Chia-chi Yeh (è‘‰å®¶é½Š) <chiachi@android.com>
Date: Wed, 5 Aug 2009 08:06:25 +0800

> 2009/8/5 David Miller <davem@davemloft.net>:
>> I think we really cannot change behavior here. Â If the user specifies
>> "0" in ipi_ifindex we must respect that in ipc->oif. Â This is an
>> override, and the ability to override is the very purpose of this
>> control message.
>>
>> Even GLIBC makes use of that case of specifying "0" in ipi_ifindex.
>> We must respect it.
>>
>> I'm not applying any of these patches, sorry.
>>
> 
> If you treat ipi_ifindex as an override, do you want to do that in
> ipi6_ifindex as well? Also, CAP_NET_RAW check for SO_BINDTODEVICE
> becomes meaningless in this case.

ipi_ifindex influences routing decisions, it doesn't also influence
socket matching like SO_BINDTODEVICE does.

That's the crucial difference.

This interface index gets passed into the routing lookup and that is
completely harmless to allow users to do.

About ipv6 it is indeed an important issue, because apps that work now
with ipv4's behavior are going to break if they care about this case
when they start using ipv6.  Probably the thing to do is make ipv6
work the same as ipv4.

> I did not find the usage of ipi_ifindex in glibc. It would be great if
> you can give me some pointers. Thanks for your help.

If grep is broken on your system, I'm sorry to hear that:

	find . -type f | xargs egrep IP_PKTINFO

Give that a try on your glibc tree.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
