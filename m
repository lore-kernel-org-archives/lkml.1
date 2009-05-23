Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbZEWOq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbZEWOq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 10:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZEWOqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 10:46:15 -0400
Received: from bu3sch.de ([62.75.166.246]:44451 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZEWOqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 10:46:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Riepe <michael.riepe@googlemail.com>
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
Date: Sat, 23 May 2009 16:44:12 +0200
User-Agent: KMail/1.9.9
Cc: David Dillow <dave@thedillows.org>, Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <200905231124.28925.mb@bu3sch.de> <4A1809B0.3030109@googlemail.com>
In-Reply-To: <4A1809B0.3030109@googlemail.com>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905231644.13326.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 May 2009 16:35:28 Michael Riepe wrote:
> Hi!
> 
> Michael Buesch wrote:
> 
> > Thanks a lot, Dave! This fixes the issue on my chip.
> 
> Yep, it's stable here as well. And even a little faster than pci=nomsi.
> The only strangeness I observed is that the throughput (measured with
> iperf and a single TCP connection) varies:
> 
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec    667 MBytes    559 Mbits/sec
> [  3] 10.0-20.0 sec    803 MBytes    673 Mbits/sec
> [  3] 20.0-30.0 sec    802 MBytes    673 Mbits/sec
> [  3] 30.0-40.0 sec    714 MBytes    599 Mbits/sec
> [  3] 40.0-50.0 sec    669 MBytes    561 Mbits/sec
> [  3] 50.0-60.0 sec    791 MBytes    663 Mbits/sec
> [  3]  0.0-60.0 sec  4.34 GBytes    622 Mbits/sec

Are you running the iperf server or client on the r8169?
I'm running the iperf server on the r8169 and get the following results:

mb@homer:~$ iperf -c 192.168.2.50 -t120 -i10
------------------------------------------------------------
Client connecting to 192.168.2.50, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.205 port 34739 connected with 192.168.2.50 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec    789 MBytes    662 Mbits/sec
[  3] 10.0-20.0 sec    791 MBytes    664 Mbits/sec
[  3] 20.0-30.0 sec    799 MBytes    670 Mbits/sec
[  3] 30.0-40.0 sec    794 MBytes    666 Mbits/sec
[  3] 40.0-50.0 sec    795 MBytes    667 Mbits/sec
[  3] 50.0-60.0 sec    793 MBytes    665 Mbits/sec
[  3] 60.0-70.0 sec    800 MBytes    671 Mbits/sec
[  3] 70.0-80.0 sec    795 MBytes    667 Mbits/sec
[  3] 80.0-90.0 sec    800 MBytes    672 Mbits/sec
[  3] 90.0-100.0 sec    797 MBytes    669 Mbits/sec
[  3] 100.0-110.0 sec    789 MBytes    662 Mbits/sec
[  3] 110.0-120.0 sec    791 MBytes    663 Mbits/sec
[  3]  0.0-120.0 sec  9.31 GBytes    666 Mbits/sec

Looks acceptable to me.
The iperf client device is a BCM5780.

-- 
Greetings, Michael.
