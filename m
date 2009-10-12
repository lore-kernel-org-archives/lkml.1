Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZJLI3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZJLI3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZJLI3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:29:38 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45984 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474AbZJLI3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:29:36 -0400
X-Sasl-enc: +HgElxORd4GWrkpa+CbTzj41Mic5X09Hdi4hezDKQDF7 1255336139
Message-ID: <4AD2E8C8.4060205@imap.cc>
Date: Mon, 12 Oct 2009 10:28:56 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless <linux-wireless@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, linux-ppp@vger.kernel.org,
       netdev@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: NOHZ: local_softirq_pending 08
References: <20091011095217.GA2200@darkstar>	 <1255255735.4095.53.camel@johannes.local>	 <4AD1BF06.3050103@phoenixsoftware.de> <1255261251.4095.143.camel@johannes.local>
In-Reply-To: <1255261251.4095.143.camel@johannes.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

[CCing PPP people]

Am 11.10.2009 13:40 schrieb Johannes Berg:
> On Sun, 2009-10-11 at 13:18 +0200, Tilman Schmidt wrote:
> 
>> Can you explain a bit more what that message is about?
>> I am encountering it in a completely different context
>> (PPP over ISDN) [...]
> 
> Basically, calling netif_rx() with softirqs enabled.

AFAICS that would have to be the netif_rx() call in
ppp_receive_nonmp_frame() [drivers/net/ppp_generic.c#L1791],
called (via others) from the tasklet work function
ppp_sync_process() [drivers/net/ppp_synctty.c#L545].
Should that be changed to the
"if (in_interrupt()) netif_rx(skb) else netif_rx_ni(skb)"
stanza from the linux.kernel.wireless.general thread then?

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

iD8DBQFK0ujIQ3+did9BuFsRAtGBAJ9rj2pyQZ75ZKTipLhpICqA3ZvTdQCdHQs/
RmdeOT3TuPZykXJxcHLJCzU=
=87DI
-----END PGP SIGNATURE-----
