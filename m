Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZJZIrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZJZIrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZJZIrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:47:20 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51003 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbZJZIrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:47:19 -0400
X-Sasl-enc: I3viX5KEpMVKOjLJBst0X0hF8yQLIct86+Xm9GCFiz2e 1256546843
Message-ID: <4AE56217.3040708@imap.cc>
Date: Mon, 26 Oct 2009 10:47:19 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
References: <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc>	 <20091021211906.GA11401@ami.dom.local>	 <1256160330.12174.2.camel@johannes.local>	 <20091021213947.GA12202@ami.dom.local>	 <1256200021.12174.11.camel@johannes.local> <4AE1C00B.5010008@imap.cc>	 <1256309191.12174.51.camel@johannes.local>	 <20091026074126.GA6187@ff.dom.local>	 <1256543054.28230.6.camel@johannes.local>	 <20091026075438.GB6187@ff.dom.local> <1256543932.28230.9.camel@johannes.local>
In-Reply-To: <1256543932.28230.9.camel@johannes.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 26.10.2009 09:58 schrieb Johannes Berg:
> On Mon, 2009-10-26 at 07:54 +0000, Jarek Poplawski wrote:
> 
>>> No, I wrote that I didn't know. I suppose now that I looked at it I do
>>> know, and only disabling preemption is required.
>> But netif_rx has preemption disabled most of the time (by hardirqs
>> disabling). So maybe disabling preemption isn't the main reason here
>> either?
> 
> Not for netpoll though, which may or may not be relevant (if I were to
> venture a guess I'd say it isn't and it disables preemption to be able
> to do the softirq thing)
> 
> However, I lost track now of why we're discussing this.

The starting point were several reports of the kernel message:

NOHZ: local_softirq_pending 08

Originally most if not all of them came from wireless networking,
but I muddied the waters by adding to the mix a case involving ISDN.
You stated that all the solutions proposed so far were wrong, so
we're naturally turning to you for guidance on what the right
solution might be.

> Basically it boils down to using netif_rx() when in (soft)irq, and
> netif_rx_ni() when in process context. That could just be an
> optimisation, but it's a very valid one.

Hmmm. That seems to contradict your earlier statement to me that
simply replacing a call to netif_rx() by one to netif_rx_ni()
when not in interrupt context isn't a valid solution either.
What am I missing?

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

iD8DBQFK5WIXQ3+did9BuFsRAsj1AJ0e4VJ7Nsp69ROXCiT4oM/Q6lIpSwCfZvXS
4nV4tWTIzgk4IRlCt0CCF3Y=
=r15I
-----END PGP SIGNATURE-----
