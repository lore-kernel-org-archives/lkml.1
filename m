Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZHHRY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZHHRY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 13:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZHHRY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 13:24:59 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:35553 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZHHRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 13:24:58 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: Strange wireless card?
Date: Sat, 08 Aug 2009 13:24:08 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5; KDE/4.2.4; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200908042306.36043.gene.heskett@verizon.net>
 <4A7D9CB0.8050003@gmail.com>
In-reply-to: <4A7D9CB0.8050003@gmail.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908081324.08513.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 August 2009, Roel Kluin wrote:
>Op 05-08-09 05:06, Gene Heskett schreef:
>> Greetings;
>>
>> Can anyone tell me if this pci wireless card is supported, or what its
>> status is?
>>
>>>From lspci -v:
>> 01:06.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335
>> [Libertas] 802.11b/g Wireless (rev 03) Subsystem: Netgear WG311v3 802.11g
>> Wireless PCI Adapter
>>
>> I have built a 2.6.31-rc5 kernel with the Marvel stuffs all enabled, but
>> even a modprobe mwl8k, while apparently loading the driver, doesn't create
>> any wireless devices in /dev.
>>
>> Thanks for any pointers.
>
>It could be due to a regression I caused, see this thread,
>
>http://lkml.org/lkml/2009/8/8/77
>
>Could you test it with this?
>
>diff --git a/drivers/net/wireless/libertas/assoc.c
> b/drivers/net/wireless/libertas/assoc.c index d699737..49fceb9 100644
>--- a/drivers/net/wireless/libertas/assoc.c
>+++ b/drivers/net/wireless/libertas/assoc.c
>@@ -45,7 +45,7 @@ static int get_common_rates(struct lbs_private *priv,
> {
> 	u8 *card_rates = lbs_bg_rates;
> 	int ret = 0, i, j;
>-	u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
>+	u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates) - 1];
> 	size_t tmp_size = 0;
>
> 	/* For each rate in card_rates that exists in rate1, copy to tmp */

This is a total failure when I attempt to patch my 2.6.31-rc5 tree.  The patch 
trigger phrase lines are even so different that I am not comfortable trying to 
apply it by hand.

So obviously there have been other, intervening patches also.
If this makes it into rc6, maybe it will work?

>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

If he should ever change his faith, it'll be because he no longer thinks
he's God.

