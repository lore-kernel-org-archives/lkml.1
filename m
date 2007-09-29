Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbXI2JWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbXI2JWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXI2JWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:22:10 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:50646 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbXI2JWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:22:09 -0400
X-Greylist: delayed 48829 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Sep 2007 05:22:08 EDT
Message-ID: <46FE193E.60200@free.fr>
Date: Sat, 29 Sep 2007 11:22:06 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc[68]-mm: network hangs
References: <46FD5A82.9070505@free.fr> <20070929013106.4f84320d.akpm@linux-foundation.org>
In-Reply-To: <20070929013106.4f84320d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29.09.2007 10:31, Andrew Morton a écrit :
> On Fri, 28 Sep 2007 21:48:18 +0200 Laurent Riffard <laurent.riffard@free.fr> wrote:
> 
>> Hi,
>>
>> >From time to time, I experience some complete network hangs:
>>
>> Suddenly, all network connections become unresponsive. Even "ping
>> 127.0.0.1" doesn't work. SysRq-w does not show any blocked processus.
>>
>> When such hang happen, I have to reboot (shutdown does work).
>>
>> This is not easily reproducible: it happens several minutes after 
>> boot (could be 45 minutes or 2 hours). I do not use heavy networking 
>> apps (like P2P). My typical usage is a Gnome desktop with  browser, 
>> mailer, IM, video or audio streaming. 
>>
>> I have a single PC connected to a DSL router via ethernet (so no LAN 
>> with NFS or CIFS).
>>
>> This happens with 2.6.23-rc8-mm2 and 2.6.23-rc6-mm1. I can't remember 
>> when I first see this problem. Maybe 2 months ago.
>>
>> I attached the output of "strace ping 127.0.0.1". How can I collect 
>> some more data when this problem happens ?
>>
> 
> I have a second report of this from Uwe Bugla (who has been banished from
> all vger lists for various naughtinesses).
> 
> Similar story - after a few hours his network router (which is using ppp in
> some fashion) craps out and dhcp queries all time out.
> 
> I'd be suspecting a ppp bug in net-2.6.24.

mmm... I don't use PPP at all, nor dhcp. 

My DSL box act as a NAT-router. Its local adress is 192.168.0.254 and my PC 
is at 192.192.0.9 (fixed IP).

       /--- telephone line 
       |
 +----------+
 | ADSL box |
 +----------+
 192.168.0.254
       |
  192.168.0.9
 +-----------+
 |    PC     |
 +-----------+

Firstly, I suspected a bug in the DSL box, so I reset it but it did not help. 
I have to reboot the PC (don't need to reset the DSL box). 

Could a router problem prevent "ping 127.0.0.1" from working ?

[this becomes somewhat off-topic for LKML, sorry]

Here's my routing table:

linux-2.6-mm$ LANG=C netstat -rn
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
192.168.0.0     0.0.0.0         255.255.255.0   U         0 0          0 eth0
169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 eth0
0.0.0.0         192.168.0.254   0.0.0.0         UG        0 0          0 eth0

It seems it lacks a route for 127.0.0.1 through lo, isn't it? In this case, if 
eth0 hangs, 127.0.0.1 hangs too, no?

So, it could be an ethernet driver bug. I'm using ne2k-pci.
-- 
laurent
