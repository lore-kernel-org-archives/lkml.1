Return-Path: <linux-kernel-owner+w=401wt.eu-S965638AbXA3RNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965638AbXA3RNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965635AbXA3RNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:13:54 -0500
Received: from stinky.trash.net ([213.144.137.162]:37317 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965634AbXA3RNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:13:53 -0500
Message-ID: <45BF7CCC.9080306@trash.net>
Date: Tue, 30 Jan 2007 18:13:48 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org, netfilter@lists.netfilter.org,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] NF_CONNTRACK_H323 must depend on (IPV6 || IPV6=n)
References: <20070128222136.GZ6017@stusta.de> <20070128.155348.39160134.davem@davemloft.net> <20070129000011.GB6017@stusta.de> <20070128.160442.48527586.davem@davemloft.net> <20070129002108.GC6017@stusta.de>
In-Reply-To: <20070129002108.GC6017@stusta.de>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 28, 2007 at 04:04:42PM -0800, David Miller wrote:
> 
>>From: Adrian Bunk <bunk@stusta.de>
>>Date: Mon, 29 Jan 2007 01:00:11 +0100
>>
>>>"depends on IPV6" would fix the bug - but it would also make 
>>>NF_CONNTRACK_H323 unavailable for all people without IPV6 support in 
>>>their kernel.
>>
>>Yes, that is an issue.
>>
>>I guess with some slightly ugly ifdefs we could support the
>>whole matrix of possibilities.  But perhaps that's undesirable
>>for another reason.
>>...
> 
> 
> This depends on what NF_CONNTRACK_H323=y, IPV6=m is supposed to be:
> - not allowed (NF_CONNTRACK_H323 must be modular) or
> - NF_CONNTRACK_H323 can only be used for IPV4
> 
> My patch implements the first case.


Unfortunately a few ifdefs aren't enough to support IPV6=m,
NF_CONNTRACK_H323=y. For now I think Adrian's patch is the
best solution (IPV6=m isn't that useful anyway since it will
normally get loaded automatically when the first program
attempts to open an AF_INET6 socket and can't be unloaded),
but I'll look into moving the route lookup to the netfilter
AF ops in 2.6.21 so we can also support that configuration.


Acked-by: Patrick McHardy <kaber@trash.net>
