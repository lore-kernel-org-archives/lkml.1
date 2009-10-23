Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbZJWO1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbZJWO1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZJWO1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:27:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37556 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbZJWO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:27:10 -0400
X-Sasl-enc: fya2TWyoRH7TIIy+kF/cOiv+8VQly/I0w2GFVglxXpXi 1256308034
Message-ID: <4AE1BD3D.3020007@imap.cc>
Date: Fri, 23 Oct 2009 16:27:09 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       i4ldeveloper <i4ldeveloper@listserv.isdn4linux.de>,
       Karsten Keil <isdn@linux-pingi.de>
Subject: Re: NOHZ: local_softirq_pending 08
References: <4AD31213.6020006@imap.cc> <20091015114052.GA9870@ff.dom.local>	 <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc>	 <4AE0ECCE.2020407@imap.cc> <1256304869.12174.20.camel@johannes.local>
In-Reply-To: <1256304869.12174.20.camel@johannes.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Johannes Berg schrieb:
> On Fri, 2009-10-23 at 01:37 +0200, Tilman Schmidt wrote:
> 
>> --- a/drivers/isdn/i4l/isdn_ppp.c
>> +++ b/drivers/isdn/i4l/isdn_ppp.c
>> @@ -1174,7 +1174,10 @@ isdn_ppp_push_higher(isdn_net_dev * net_dev, isdn_net_local * lp, struct sk_buff
>>  #endif /* CONFIG_IPPP_FILTER */
>>  	skb->dev = dev;
>>  	skb_reset_mac_header(skb);
>> -	netif_rx(skb);
>> +	if (in_interrupt())
>> +		netif_rx(skb);
>> +	else
>> +		netif_rx_ni(skb);
> 
> So you've verified that the entire i4l stack can cope with being called
> twice on the same CPU, from different contexts?

What makes you think so?
Better yet, what do you propose?

Thanks,
Tilman

- --
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFK4b09Q3+did9BuFsRAqBvAKCbRI0iXQEyK3ztxkGHcqpbcceqbACgkagX
JF7nYd152ihp2uemIs/cB54=
=YOin
-----END PGP SIGNATURE-----
