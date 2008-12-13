Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbYLMWNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbYLMWNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 17:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYLMWNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 17:13:19 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58973 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYLMWNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 17:13:18 -0500
Date: Sat, 13 Dec 2008 23:13:15 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Miller <davem@davemloft.net>
cc: ajax@redhat.com, linux-kernel@vger.kernel.org, davej@redhat.com,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       kaber@trash.net
Subject: Re: [PATCH] net: Remove a noisy printk
In-Reply-To: <20081211.203243.124017657.davem@davemloft.net>
Message-ID: <alpine.LNX.1.10.0812132310080.27276@fbirervta.pbzchgretzou.qr>
References: <1229033625-30825-1-git-send-email-ajax@redhat.com> <20081211.203243.124017657.davem@davemloft.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-12-12 05:32, David Miller wrote:
>From: Adam Jackson <ajax@redhat.com>
>Date: Thu, 11 Dec 2008 17:13:42 -0500
>
>> From: Dave Jones <davej@redhat.com>
>> 
>> These messages are trivial to trigger when running stress tests
>> like isic, and add no real value.
>> 
>> Signed-off-by: Dave Jones <davej@redhat.com>
>> Signed-off-by: Adam Jackson <ajax@redhat.com>
>
>If you don't send this to the netfilter developers nor the networking
>developers, noboby knowledgable can even look at this patch.

(For the archive, it's not the Internation Student Identity Card)
http://www.packetfactory.net/Projects/ISIC/ :

“ISIC is a suite of utilities to exercise the stability of an IP
Stack and its component stacks (TCP, UDP, ICMP et. al.) It generates
piles of pseudo random packets of the target protocol.”

>> @@ -147,8 +147,6 @@ static unsigned int ipv4_conntrack_local(unsigned int hooknum,
>>  	/* root is playing with raw sockets. */
>>  	if (skb->len < sizeof(struct iphdr) ||
>>  	    ip_hdrlen(skb) < sizeof(struct iphdr)) {
>> -		if (net_ratelimit())
>> -			printk("ipt_hook: happy cracking.\n");
>>  		return NF_ACCEPT;
>>  	}
>>  	return nf_conntrack_in(dev_net(out), PF_INET, hooknum, skb);

I think this change is ok.
