Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbZAMXiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbZAMXiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760207AbZAMXhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:37:53 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:54590 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760196AbZAMXhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:37:51 -0500
Message-ID: <496D255E.2050804@cosmosbay.com>
Date: Wed, 14 Jan 2009 00:35:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: w@1wt.eu, ben@zeus.com, jarkao2@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
References: <4966F2F4.9080901@cosmosbay.com>	<20090109070415.GA27758@1wt.eu>	<4966FC89.8040006@cosmosbay.com> <20090113.152759.29875009.davem@davemloft.net>
In-Reply-To: <20090113.152759.29875009.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 14 Jan 2009 00:35:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Fri, 09 Jan 2009 08:28:09 +0100
> 
>> If the application uses setsockopt(sock, SOL_SOCKET, SO_RCVLOWAT,
>> [32768], 4), it would be good if kernel was smart enough and could
>> reduce number of wakeups.
> 
> Right, and as I pointed out in previous replies the problem is
> that splice() receive in TCP doesn't check the low water mark
> at all.
> 
> 

Yes I understand, but if splice() is running, wakeup occured, and
no need to check if the wakeup was good or not... just proceed and
consume some skb, since we already were awaken.

Then, an application might setup a high SO_RCVLOWAT, but want to splice()
only few bytes, so RCVLOWAT is only a hint for the thing that perform the
wakeup, not for the consumer.


