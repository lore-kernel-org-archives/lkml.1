Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbZHHPh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbZHHPh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZHHPh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:37:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:61093 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZHHPh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZHPnPaCcu6skOUzU8JAA924ETpf/sSdNYmXUTpDk5yU6xoP2H07SJGVibS6vlF8xuB
         H3jRvGlV+iQdTvJS/mETr8PhDk83dB6WOvMopbU811J5O7gTMBfk2RWxdCyiy5Y2J3Ex
         iVsOtuy1Lz0w5gJJs2uEF+HfEGqkYZM1O05lM=
Message-ID: <4A7D9CB0.8050003@gmail.com>
Date: Sat, 08 Aug 2009 17:41:36 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange wireless card?
References: <200908042306.36043.gene.heskett@verizon.net>
In-Reply-To: <200908042306.36043.gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 05-08-09 05:06, Gene Heskett schreef:
> Greetings;
> 
> Can anyone tell me if this pci wireless card is supported, or what its 
> status is?
> 
>>From lspci -v:
> 01:06.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless (rev 03)
>         Subsystem: Netgear WG311v3 802.11g Wireless PCI Adapter
> 
> I have built a 2.6.31-rc5 kernel with the Marvel stuffs all enabled, but
> even a modprobe mwl8k, while apparently loading the driver, doesn't create
> any wireless devices in /dev.
> 
> Thanks for any pointers.
> 

It could be due to a regression I caused, see this thread,

http://lkml.org/lkml/2009/8/8/77

Could you test it with this?

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index d699737..49fceb9 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -45,7 +45,7 @@ static int get_common_rates(struct lbs_private *priv,
 {
 	u8 *card_rates = lbs_bg_rates;
 	int ret = 0, i, j;
-	u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
+	u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates) - 1];
 	size_t tmp_size = 0;
 
 	/* For each rate in card_rates that exists in rate1, copy to tmp */
