Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbXKAVLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbXKAVLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXKAVKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:10:54 -0400
Received: from ppp-111-237.adsl.restena.lu ([158.64.111.237]:44932 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674AbXKAVKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:10:53 -0400
X-Greylist: delayed 1507 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 17:10:52 EDT
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.23: IPv6 router advertisments missed by kernel
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3264
Date: Thu, 1 Nov 2007 21:45:42 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711012145.43085.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, clean
X-SpamProbe: GOOD 0.0000300 c6233953f8ad35b650ae1eacf832f69a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing unexpected behavior on my laptop since I updated kernel to 2.6.23.1 
from 2.6.22.1.

My setup:
  Cisco Router <--- [2 vlans] -----> Laptop

On the link two VLANs are active, native vlan is not used.
Laptop nic is:
   Tigon3 [partno(BCM95751m) rev 4201 PHY(5750)] (PCI Express)
   10/100/1000Base-T Ethernet

On laptop I have eth0.500 and eth0.658 as active interfaces (eth0 is just up - 
no address manually assigned) with IPv4 address assigned. IPv6 is only 
enabled on the router for one of both vlans (500).

When booting with 2.6.23.1 the router advertisments coming from the router 
(vlan 500) seem to get ignored by the kernel (they are detected by 2.6.22) 
and only enabling promiscuous mode on eth0 makes the kernel detect the router 
advertisments. (I'm doing "tcpdump icmp6" on the vlan interface)

This looks like it could be caused by changes in regard to handling vlans with 
Tigon3 nic.
A different machine (other nic and no vlans) sees the router advertisments 
correctly with 2.6.23.1. (So I don't expect the cause to be on IPv6 side)

Bruno



Probably relevant .config extract for 2.6.23.1:
  CONFIG_PACKET=y
  CONFIG_UNIX=y
  CONFIG_INET=y
  CONFIG_IP_MULTICAST=y
  CONFIG_IP_ADVANCED_ROUTER=y
  CONFIG_ASK_IP_FIB_HASH=y
  CONFIG_IP_FIB_HASH=y
  CONFIG_IP_MULTIPLE_TABLES=y
  CONFIG_NET_IPGRE=m
  CONFIG_SYN_COOKIES=y
  CONFIG_INET_DIAG=y
  CONFIG_INET_TCP_DIAG=y
  CONFIG_TCP_CONG_CUBIC=y
  CONFIG_DEFAULT_TCP_CONG="cubic"
  CONFIG_IPV6=y
  CONFIG_INET6_TUNNEL=m
  CONFIG_IPV6_TUNNEL=m
  CONFIG_IPV6_MULTIPLE_TABLES=y
  CONFIG_IPV6_SUBTREES=y
  CONFIG_NETFILTER=y

  CONFIG_NETDEVICES=y
  CONFIG_NETDEVICES_MULTIQUEUE=y
  # CONFIG_MACVLAN is not set
  CONFIG_TUN=m
  CONFIG_PHYLIB=m
  CONFIG_BROADCOM_PHY=m
  CONFIG_NET_ETHERNET=y
  CONFIG_MII=y
  CONFIG_NET_PCI=y
  CONFIG_B44=m
  CONFIG_NETDEV_1000=y
  CONFIG_TIGON3=m

Same extract for 2.6.22.1:
  CONFIG_PACKET=y
  CONFIG_UNIX=y
  CONFIG_INET=y
  CONFIG_IP_MULTICAST=y
  CONFIG_IP_ADVANCED_ROUTER=y
  CONFIG_ASK_IP_FIB_HASH=y
  CONFIG_IP_FIB_HASH=y
  CONFIG_IP_MULTIPLE_TABLES=y
  CONFIG_NET_IPGRE=m
  CONFIG_SYN_COOKIES=y
  CONFIG_INET_DIAG=y
  CONFIG_INET_TCP_DIAG=y
  CONFIG_TCP_CONG_CUBIC=y
  CONFIG_DEFAULT_TCP_CONG="cubic"
  CONFIG_IPV6=y
  CONFIG_INET6_TUNNEL=m
  CONFIG_IPV6_TUNNEL=m
  CONFIG_IPV6_MULTIPLE_TABLES=y
  CONFIG_IPV6_SUBTREES=y
  CONFIG_NETFILTER=y

  CONFIG_NETDEVICES=y
  CONFIG_DUMMY=m
  CONFIG_TUN=m
  CONFIG_PHYLIB=m
  CONFIG_BROADCOM_PHY=m
  CONFIG_NET_ETHERNET=y
  CONFIG_MII=y
  CONFIG_NET_PCI=y
  CONFIG_B44=m
  CONFIG_NETDEV_1000=y
  CONFIG_TIGON3=m

