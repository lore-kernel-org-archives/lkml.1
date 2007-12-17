Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbXLQPdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbXLQPdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbXLQPdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:33:37 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:45972 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbXLQPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:33:36 -0500
Message-ID: <476696A5.1010101@nortel.com>
Date: Mon, 17 Dec 2007 09:32:53 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: yoshfuji@linux-ipv6.org
CC: dada1@cosmosbay.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: "ip neigh show" not showing arp cache entries?
References: <4760279E.1080203@nortel.com>	<47602DD0.8070402@cosmosbay.com> <47605934.2060604@nortel.com> <20071213.070641.20411400.yoshfuji@linux-ipv6.org>
In-Reply-To: <20071213.070641.20411400.yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Dec 2007 15:32:56.0723 (UTC) FILETIME=[18FE9630:01C840C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki / 吉藤英明 wrote:
> In article <47605934.2060604@nortel.com> (at Wed, 12 Dec 2007
> 15:57:08 -0600), "Chris Friesen" <cfriesen@nortel.com> says:

>>> You may try other versions of this command
>>> 
>>> http://devresources.linux-foundation.org/dev/iproute2/download/
>> 
>> They appear to be numbered by kernel version, and the above version
>> is the most recent one for 2.6.14.  Will more recent ones (for
>> newer kernels) work with my kernel?

> It should work; if it doesn't, please make a report.  Thanks.

I downloaded iproute2-2.6.23 and built it for my kernel.

I'm compiling for a different kernel than is actually running on the 
build system, so I had to add a line defining KERNEL_INCLUDE to the 
Makefile, and I had to add "-I${KERNEL_INCLUDE}" to the CFLAGS 
definition.  Someone might want to do something about that...

Anyways, the arp entry issue is still there.  The "arp" command gives a 
bunch of entries:

root@typhoon-base-unit0:/root> arp -n
Address          HWtype  HWaddress           Flags Mask            Iface
192.168.24.81    ether   00:01:AF:14:E9:8A   C                     bond2
172.24.132.2             (incomplete)                              bond0
172.24.136.0     ether   00:C0:8B:07:B3:7E   C                     bond0
172.24.137.0             (incomplete)                              bond0
172.24.0.9       ether   00:07:E9:41:4B:B4   C                     bond0
10.41.18.101     ether   00:0E:0C:5E:95:BD   C                     eth6
172.24.0.11      ether   00:03:CC:51:06:5E   C                     bond0
172.24.132.1     ether   00:01:AF:14:E9:88   C                     bond0
172.24.0.15      ether   00:0E:0C:85:FD:D2   C                     bond0
172.24.0.3       ether   00:01:AF:14:C8:CC   C                     bond0
172.24.0.5       ether   00:01:AF:15:E0:6A   C                     bond0

The original "ip" command and the new one ("/tmp/ip") both give the same 
results--some of the entries are missing.

root@typhoon-base-unit0:/root> ip neigh show all
172.24.137.0 dev bond0  FAILED
172.24.0.9 dev bond0 lladdr 00:07:e9:41:4b:b4 REACHABLE
10.41.18.101 dev eth6 lladdr 00:0e:0c:5e:95:bd REACHABLE
172.24.0.11 dev bond0 lladdr 00:03:cc:51:06:5e STALE
172.24.132.1 dev bond0 lladdr 00:01:af:14:e9:88 REACHABLE
172.24.0.15 dev bond0 lladdr 00:0e:0c:85:fd:d2 STALE
172.24.0.3 dev bond0 lladdr 00:01:af:14:c8:cc REACHABLE
172.24.0.5 dev bond0 lladdr 00:01:af:15:e0:6a STALE

root@typhoon-base-unit0:/root> /tmp/ip neigh show all
172.24.137.0 dev bond0  FAILED
172.24.0.9 dev bond0 lladdr 00:07:e9:41:4b:b4 REACHABLE
10.41.18.101 dev eth6 lladdr 00:0e:0c:5e:95:bd REACHABLE
172.24.0.11 dev bond0 lladdr 00:03:cc:51:06:5e STALE
172.24.132.1 dev bond0 lladdr 00:01:af:14:e9:88 REACHABLE
172.24.0.15 dev bond0 lladdr 00:0e:0c:85:fd:d2 STALE
172.24.0.3 dev bond0 lladdr 00:01:af:14:c8:cc REACHABLE
172.24.0.5 dev bond0 lladdr 00:01:af:15:e0:6a STALE


However, if I specifically try to print out one of the missing entries, 
it shows up:

root@typhoon-base-unit0:/root> /tmp/ip neigh show 192.168.24.81
192.168.24.81 dev bond2 lladdr 00:01:af:14:e9:8a REACHABLE


Chris
