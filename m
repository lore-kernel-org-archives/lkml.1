Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbZBLO2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbZBLO2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbZBLO2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:28:40 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:37010 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbZBLO2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:28:39 -0500
Message-ID: <49943212.3080701@petalogix.com>
Date: Thu, 12 Feb 2009 15:28:34 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Network driver issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Could you give any hint what can be wrong? I use 2.6.29-rc4.
Tcpdump and wireshark show me that board can send packet and get
response but don't show
timing ping info. For incomming packets (exclude ARP) isn't any response
back. ARPs work well.

Thanks,
Michal


~ # tcpdump &
~ # device eth0 entered promiscuous mode
tcpdump: listening on eth0

~ #
~ # ping 192.168.0.102
PING 192.168.0.102 (192.168.0.102): 56 data bytes
00:00:34.639430 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:34.642714 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:35.662135 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:35.667248 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:36.671424 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:36.676416 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:37.681470 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:37.686573 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:38.691440 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:38.696452 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:39.701454 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:39.706520 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:40.711422 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:40.716429 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:41.721460 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:41.726542 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:42.731478 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:42.736476 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:43.741444 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:43.746525 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:44.751429 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:44.756441 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:45.761449 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:45.766528 192.168.0.102 > 192.168.0.20: icmp: echo reply
00:00:46.771434 192.168.0.20 > 192.168.0.102: icmp: echo request (DF)
00:00:46.776438 192.168.0.102 > 192.168.0.20: icmp: echo reply

--- 192.168.0.102 ping statistics ---
13 packets transmitted, 0 packets received, 100% packet loss
~ # 00:01:06.468561 192.168.0.102 > 192.168.0.20: icmp: echo request (DF)
00:01:07.477512 192.168.0.102 > 192.168.0.20: icmp: echo request (DF)
00:01:08.477428 192.168.0.102 > 192.168.0.20: icmp: echo request (DF)
00:01:09.477253 192.168.0.102 > 192.168.0.20: icmp: echo request (DF)
00:01:10.477131 192.168.0.102 > 192.168.0.20: icmp: echo request (DF)
00:01:11.466927 arp who-has 192.168.0.20 tell 192.168.0.102
00:01:11.472649 arp reply 192.168.0.20 is-at 0:a:35:0:22:1
00:01:11.477375 192.168.0.102 > 192.168.0.20: icmp: echo request (DF)
00:01:12.476840 192.168.0.102 > 192.168.0.20: icmp: echo request (DF)

~ # ifconfig
eth0      Link encap:Ethernet  HWaddr 00:0A:35:00:22:01 
          inet addr:192.168.0.20  Bcast:192.168.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:26 errors:0 dropped:0 overruns:0 frame:0
          TX packets:19 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2434 (2.3 KiB)  TX bytes:1694 (1.6 KiB)
          Interrupt:5

lo        Link encap:Local Loopback 
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

~ #
~ # ping 127.0.0.1
PING 127.0.0.1 (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=7.4 ms
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=3.4 ms
64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=3.4 ms

--- 127.0.0.1 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 3.4/4.7/7.4 ms
~ #


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

