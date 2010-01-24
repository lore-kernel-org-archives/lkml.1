Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653Ab0AXNnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0AXNnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 08:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650Ab0AXNnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 08:43:09 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:56593 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab0AXNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 08:43:08 -0500
Message-ID: <4B5C4E5E.2010507@gmail.com>
Date: Sun, 24 Jan 2010 14:42:54 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in vlan_skb_recv
 - probably introduced by commit 9793241fe92f7d9303fb221e43fc598eb065f267
References: <20100123165657.187c11e4@neptune.home> <20100123223132.0e62d8cb@neptune.home>
In-Reply-To: <20100123223132.0e62d8cb@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 24 Jan 2010 14:42:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/01/2010 22:31, Bruno Prémont a écrit :
>> Above part of code did change between 2.6.32 and 2.6.33-rc5 with
>> commit 9793241fe92f7d9303fb221e43fc598eb065f267 (vlan: Precise RX
>> stats accounting)
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9793241fe92f7d9303fb221e43fc598eb065f267
> 
> Reverting just that commit gets the system running correctly.
> 
> Bruno

I have no idea how this patch can break vlan networking.

Your disassembly and .config seems to show your machine is not SMP

Maybe something is broken on UP and alloc_percpu() ?

Could you add a debug in vlan_dev_init()


 	vlan_dev_info(dev)->vlan_rx_stats = alloc_percpu(struct vlan_rx_stats);
	if (!vlan_dev_info(dev)->vlan_rx_stats)
 	return -ENOMEM;
+	pr_err("vlan_dev_init() rx_stats=%p\n", vlan_dev_info(dev)->vlan_rx_stats);


This make sure vlan_dev_init() is called and percpu allocation is properly done.

Thanks
