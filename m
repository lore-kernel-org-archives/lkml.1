Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYHLBmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYHLBmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYHLBlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:41:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYHLBls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:41:48 -0400
Message-ID: <48A0EA29.8010209@kernel.sg>
Date: Tue, 12 Aug 2008 09:40:57 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: brian.haley@hp.com, adobriyan@gmail.com, john.gumb@tandberg.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       parag.warudkar@gmail.com
Subject: Re: OOPS, ip -f inet6 route get fec0::1, linux-2.6.26, ip6_route_output,
 rt6_fill_node+0x175
References: <20080807203748.GA5196@martell.zuzino.mipt.ru>	<489BD227.6000209@hp.com>	<489FFAF8.3000909@redhat.com> <20080811.135003.105171324.davem@davemloft.net> <48A0D5B4.9050908@kernel.sg> <48A0DC37.7080209@kernel.sg>
In-Reply-To: <48A0DC37.7080209@kernel.sg>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Teo wrote:
> Eugene Teo wrote:
>> David Miller wrote:
>>> From: Eugene Teo <eteo@redhat.com>
>>> Date: Mon, 11 Aug 2008 16:40:24 +0800
> [...]
>> With the patch I posted, this is the behaviour I get:
>>
>> $ ip -f inet6 route get fec0::1
>> unreachable fec0::1 dev lo  table unspec  proto none  src
>> fe80::214:4fff:fe0f:7332  metric -1  error -101 hoplimit 255
> 
> Ok, so there's a mistake in my patch. It should return the loopback MAC

s/MAC/ipv6/

> address instead. I'm wondering if the fix should be related to
> initialising rt6i_idev in addrconf_init routine like in the upstream
> commit: c62dba9011b93fd88fde929848582b2a98309878. The code changed quite
> a lot.

So I checked, it's initialised in ip6_route_init().

Eugene
