Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbXI3Rbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbXI3Rbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbXI3Rbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:31:38 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:53632 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXI3Rbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:31:37 -0400
From: "Denys" <nuclearcat@nuclearcat.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Date: Sun, 30 Sep 2007 20:31:22 +0300
Message-Id: <20070930173123.M36911@nuclearcat.com>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

P.S.S. 
I tried changing clocksource from acpi_pm to tsc. No difference.
Tried to lock eth0 by smp_affinity to single CPU (no other interrups, except 
ioapic timer(LOC) there). No luck. I tried to change hashes in nf_conntrack, 
no difference. Tried to change eth0 weidht - no difference.

Also i notice, that exactly when softirqd start using CPU nearby 100% - 
problems happens.

At this time (with or without nice - the same, also the same to ping any host 
in network)

defaulthost ~ #nice -n -10 ping -s 10000 127.0.0.1
PING 127.0.0.1 (127.0.0.1) 10000(10028) bytes of data.

10008 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=377 ms
10008 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=328 ms
10008 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=329 ms
10008 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=355 ms
10008 bytes from 127.0.0.1: icmp_seq=5 ttl=64 time=0.047 ms

Delay value is ALWAYS nearby same. 350-360ms.

At same time if i ping "buggy 2.6.23-rc8" box, ping delay is perfect.

100000 packets transmitted, 100000 received, 0% packet loss, time 41793ms
rtt min/avg/max/mdev = 0.027/0.127/1.439/0.095 ms, ipg/ewma 0.417/0.065 ms

There is nothing running except:
squid, globax (TCP accelerator).
Logs, disk cache on squid is disabled.
Important note - there is conntract and REDIRECT used.

defaulthost /config #cat /proc/net/sockstat
sockets: used 10670
TCP: inuse 12734 orphan 1390 tw 20248 alloc 12751 mem 9903
UDP: inuse 5
UDPLITE: inuse 0
RAW: inuse 0
FRAG: inuse 0 memory 0

defaulthost /config #cat /proc/net/softnet_stat
96c0060c 00000000 003fa90a 00000000 00000000 00000000 00000000 00000000 
00000000
926120af 00000000 003e8692 00000000 00000000 00000000 00000000 00000000 
00000000

defaulthost /config #cat /proc/net/ip_conntrack|wc -l
69256
(other host running 200K easily)

What can cause delays ~350-360ms for userspace applications?

--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

