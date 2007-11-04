Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbXKDKDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbXKDKDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 05:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXKDKCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 05:02:50 -0500
Received: from ppp-111-193.adsl.restena.lu ([158.64.111.193]:33804 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753952AbXKDKCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 05:02:49 -0500
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2007 05:02:48 EST
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23: TG3+VLAN: IPv6 router advertisments missed by kernel
Date: Sun, 4 Nov 2007 10:30:06 +0100
User-Agent: KMail/1.9.7
References: <200711012145.43085.bonbons@linux-vserver.org>
In-Reply-To: <200711012145.43085.bonbons@linux-vserver.org>
Cc: Linux NetDev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711041030.06865.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, clean
X-SpamProbe: GOOD 0.0000115 984d0401369b5511a0e5ea0f962948b1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The issue shows up reliably when starting the system though some 
(re)configuration operations on the network interface makes the issue 
disapear.
One way to get the kernel to see the advertisments is to restart the interface 
with its vlans or (as below) keeping the interface in promiscuous mode.

Regards,
Bruno

On Thursday 01 November 2007 21:45:42 you wrote:
> I'm seeing unexpected behavior on my laptop since I updated kernel to
> 2.6.23.1 from 2.6.22.1.
>
> My setup:
>   Cisco Router <--- [2 vlans] -----> Laptop
>
> On the link two VLANs are active, native vlan is not used.
> Laptop nic is:
>    Tigon3 [partno(BCM95751m) rev 4201 PHY(5750)] (PCI Express)
>    10/100/1000Base-T Ethernet
>
> On laptop I have eth0.500 and eth0.658 as active interfaces (eth0 is just
> up - no address manually assigned) with IPv4 address assigned. IPv6 is only
> enabled on the router for one of both vlans (500).
>
> When booting with 2.6.23.1 the router advertisments coming from the router
> (vlan 500) seem to get ignored by the kernel (they are detected by 2.6.22)
> and only enabling promiscuous mode on eth0 makes the kernel detect the
> router advertisments. (I'm doing "tcpdump icmp6" on the vlan interface)
>
> This looks like it could be caused by changes in regard to handling vlans
> with Tigon3 nic.
> A different machine (other nic and no vlans) sees the router advertisments
> correctly with 2.6.23.1. (So I don't expect the cause to be on IPv6 side)
>
> Bruno
>
>
>
> Probably relevant .config extract for 2.6.23.1:
>   CONFIG_PACKET=y
>   CONFIG_UNIX=y
>   CONFIG_INET=y
>   CONFIG_IP_MULTICAST=y
>   CONFIG_IP_ADVANCED_ROUTER=y
>   CONFIG_ASK_IP_FIB_HASH=y
>   CONFIG_IP_FIB_HASH=y
>   CONFIG_IP_MULTIPLE_TABLES=y
>   CONFIG_NET_IPGRE=m
>   CONFIG_SYN_COOKIES=y
>   CONFIG_INET_DIAG=y
>   CONFIG_INET_TCP_DIAG=y
>   CONFIG_TCP_CONG_CUBIC=y
>   CONFIG_DEFAULT_TCP_CONG="cubic"
>   CONFIG_IPV6=y
>   CONFIG_INET6_TUNNEL=m
>   CONFIG_IPV6_TUNNEL=m
>   CONFIG_IPV6_MULTIPLE_TABLES=y
>   CONFIG_IPV6_SUBTREES=y
>   CONFIG_NETFILTER=y
>
>   CONFIG_NETDEVICES=y
>   CONFIG_NETDEVICES_MULTIQUEUE=y
>   # CONFIG_MACVLAN is not set
>   CONFIG_TUN=m
>   CONFIG_PHYLIB=m
>   CONFIG_BROADCOM_PHY=m
>   CONFIG_NET_ETHERNET=y
>   CONFIG_MII=y
>   CONFIG_NET_PCI=y
>   CONFIG_B44=m
>   CONFIG_NETDEV_1000=y
>   CONFIG_TIGON3=m
>
> Same extract for 2.6.22.1:
>   CONFIG_PACKET=y
>   CONFIG_UNIX=y
>   CONFIG_INET=y
>   CONFIG_IP_MULTICAST=y
>   CONFIG_IP_ADVANCED_ROUTER=y
>   CONFIG_ASK_IP_FIB_HASH=y
>   CONFIG_IP_FIB_HASH=y
>   CONFIG_IP_MULTIPLE_TABLES=y
>   CONFIG_NET_IPGRE=m
>   CONFIG_SYN_COOKIES=y
>   CONFIG_INET_DIAG=y
>   CONFIG_INET_TCP_DIAG=y
>   CONFIG_TCP_CONG_CUBIC=y
>   CONFIG_DEFAULT_TCP_CONG="cubic"
>   CONFIG_IPV6=y
>   CONFIG_INET6_TUNNEL=m
>   CONFIG_IPV6_TUNNEL=m
>   CONFIG_IPV6_MULTIPLE_TABLES=y
>   CONFIG_IPV6_SUBTREES=y
>   CONFIG_NETFILTER=y
>
>   CONFIG_NETDEVICES=y
>   CONFIG_DUMMY=m
>   CONFIG_TUN=m
>   CONFIG_PHYLIB=m
>   CONFIG_BROADCOM_PHY=m
>   CONFIG_NET_ETHERNET=y
>   CONFIG_MII=y
>   CONFIG_NET_PCI=y
>   CONFIG_B44=m
>   CONFIG_NETDEV_1000=y
>   CONFIG_TIGON3=m


