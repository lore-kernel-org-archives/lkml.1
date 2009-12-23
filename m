Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZLWVch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZLWVch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbZLWVcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:32:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54855
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbZLWVce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:32:34 -0500
Date: Wed, 23 Dec 2009 13:32:36 -0800 (PST)
Message-Id: <20091223.133236.104065227.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: error27@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] hamradio: avoid null deref
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B3257C2.2050500@gmail.com>
References: <20091223132550.GD17923@bicker>
	<4B3257C2.2050500@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 23 Dec 2009 18:47:46 +0100

> Dan Carpenter wrote, On 12/23/2009 02:25 PM:
> 
>> If dev == NULL we shouldn't dereference it.
>> 
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>> 
>> --- orig/drivers/net/hamradio/bpqether.c	2009-12-22 23:58:56.000000000 +0200
>> +++ devel/drivers/net/hamradio/bpqether.c	2009-12-22 23:59:46.000000000 +0200
>> @@ -283,7 +283,6 @@ static netdev_tx_t bpq_xmit(struct sk_bu
>>  	bpq = netdev_priv(dev);
>>  
>>  	if ((dev = bpq_get_ether_dev(dev)) == NULL) {
>> -		dev->stats.tx_dropped++;
> 
> Why not use a separate variable for another dev? This stat
> should be helpful for debugging.

And that is definitely the intent of the code here, to
bump the statistic in the original device object.
