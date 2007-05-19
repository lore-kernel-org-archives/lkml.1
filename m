Return-Path: <linux-kernel-owner+w=401wt.eu-S1764414AbXEST3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764414AbXEST3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759275AbXEST3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:29:12 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:55982 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXEST3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:29:10 -0400
Message-ID: <464F4FD7.80303@cosmosbay.com>
Date: Sat, 19 May 2007 21:28:23 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Packets lost: Softirq
References: <3388.10.107.26.27.1179320821.squirrel@gpo.iitb.ac.in>    <464B19A9.700@freemail.hu> <2770.10.107.26.27.1179579009.squirrel@gpo.iitb.ac.in>
In-Reply-To: <2770.10.107.26.27.1179579009.squirrel@gpo.iitb.ac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 19 May 2007 21:28:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vasantha Kumar Puttappa a écrit :
> Hi All,
>  Please somebody guide me here. I desparatley need help regarding this
> issue. ( plz do "reply to all")
> 
>  I am tracking all udp packets (in particular, SIP based UDP packets)that
> goes through the iptables using LOG mechanism.
>  I use the following command,
>      iptables -A INPUT -p udp -j LOG --log-level-4.
>      iptables -A FORWARD -p udp -j LOG --log-level-4
> 
>   In addition, i also run 'Ethereal' to make sure that all the packets
> captured goes through the iptables as well.
> 
>   Here is the problem,
>     Sometimes, a random number of packets doesnot go through IPtables and
>   they are completely lost. Although, I can see those lost packets in
> Ethereal. I tried increasing the backlog queue and ip_queue length, but
> still no use.
> 
>    I am using Netgear's wireless network card (WG511, made in taiwan).
>    Device driver: Prism54
>    firmware: isl3890
>    Kernel verison-- 2.6.11-6mdk
> 
>   Let me give you more insight into what I am trying do.
> 
>  I have a vitrual network interface and 2 physical network interface (one
> Ethernet based, and other 802.11 based). The virtual network interface
> dynamically binds to any one of the above physical interfaces for packet
> transmission. The issue of packet loss occurs **only** during link
> switching.
> 
> I feel that the following issues might be the possible reasons for the
> packet loss.
> 
> 1. Due to missing soft_IRQ interrupt for packets and hence packet loss ( i
> have no proof to back this)
> 2. Due to incompatible wireless device driver.
> 

netdev CCed

3) packets are going normally through iptables, but the '-j LOG' is flooded 
and syslog miss some of them.

Just do a : iptables -nvL INPUT

and check packets counters : they should match ethereal ones :)

-j LOG is not designed for logging all packets, just some of them :)

