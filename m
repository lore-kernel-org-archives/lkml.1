Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbZKXKRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbZKXKRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbZKXKRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:17:08 -0500
Received: from stinky.trash.net ([213.144.137.162]:64249 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbZKXKRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:17:07 -0500
Message-ID: <4B0BB2A7.5040707@trash.net>
Date: Tue, 24 Nov 2009 11:17:11 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>
Subject: Re: [PATCH 1/4] veth: move loopback logic to common location
References: <1259024166-28158-1-git-send-email-arnd@arndb.de> <1259024166-28158-2-git-send-email-arnd@arndb.de> <4B0BAC97.6010000@trash.net> <200911241002.20904.arnd@arndb.de>
In-Reply-To: <200911241002.20904.arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 24 November 2009 09:51:19 Patrick McHardy wrote:
>>> +     skb_dst_drop(skb);
>>> +     skb->tstamp.tv64 = 0;
>>> +     skb->pkt_type = PACKET_HOST;
>>> +     skb->protocol = eth_type_trans(skb, dev);
>>> +     skb->mark = 0;
>> skb->mark clearing should stay private to veth since its usually
>> supposed to stay intact. The only exception is packets crossing
>> namespaces, where they should appear like a freshly received skbs.
> 
> But isn't that what we want in macvlan as well when we're
> forwarding from one downstream interface to another?

In the TX direction you can use the mark for TC classification
on the underlying device.

> I did all my testing with macvlan interfaces in separate namespaces
> communicating with each other, so I'd assume that we should always
> clear skb->mark and skb->dst in this function.

Good point, in that case we probably should clear it as well. But
in the non-namespace case the TC classification currently works and
this is consistent with any other virtual device driver, so it
should continue to work.
