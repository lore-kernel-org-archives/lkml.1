Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZIGPQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZIGPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZIGPQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:16:59 -0400
Received: from bu3sch.de ([62.75.166.246]:56016 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZIGPQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:16:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 7 Sep 2009 17:16:55 +0200
User-Agent: KMail/1.9.9
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
References: <20090906205952.GA6516@elte.hu>
In-Reply-To: <20090906205952.GA6516@elte.hu>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909071716.57722.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a very simple test setup on an embedded singlecore bcm47xx machine (WL500GPv2)
It uses iperf for performance testing. The iperf server is run on the
embedded device. The device is so slow that the iperf test is completely
CPU bound. The network connection is a 100MBit on the device connected
via patch cable to a 1000MBit machine.

The kernel is openwrt-2.6.30.5.

Here are the results:



Mainline CFS scheduler:

mb@homer:~$ iperf -c 192.168.1.1
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.99 port 35793 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  27.4 MBytes  23.0 Mbits/sec
mb@homer:~$ iperf -c 192.168.1.1
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.99 port 35794 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  27.3 MBytes  22.9 Mbits/sec
mb@homer:~$ iperf -c 192.168.1.1
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.99 port 56147 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  27.3 MBytes  22.9 Mbits/sec


BFS scheduler:

mb@homer:~$ iperf -c 192.168.1.1
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.99 port 52489 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  38.2 MBytes  32.0 Mbits/sec
mb@homer:~$ iperf -c 192.168.1.1
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.99 port 52490 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  38.1 MBytes  31.9 Mbits/sec
mb@homer:~$ iperf -c 192.168.1.1
------------------------------------------------------------
Client connecting to 192.168.1.1, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.99 port 52491 connected with 192.168.1.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  38.1 MBytes  31.9 Mbits/sec


-- 
Greetings, Michael.
