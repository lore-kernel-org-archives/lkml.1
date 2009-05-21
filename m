Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZEUOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZEUOcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZEUOcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:32:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40234 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbZEUOcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:32:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A1565B6.10907@s5r6.in-berlin.de>
Date: Thu, 21 May 2009 16:31:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jiri Pirko <jpirko@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-hotplug@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d"
 as interface name
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de> <20090521134856.GA3457@psychotron.englab.brq.redhat.com>
In-Reply-To: <20090521134856.GA3457@psychotron.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Pirko wrote:
> Thu, May 21, 2009 at 03:29:10PM CEST, stefanr@s5r6.in-berlin.de wrote:
>> -	dev = alloc_netdev(sizeof(*priv), "eth%d", ether1394_init_dev);
>> +	dev = alloc_netdev(sizeof(*priv),
>> +			   firewire_interface_name ? "firewire%d" : "eth%d",
> 
> Isn't "firewire" too long? Wouldn't it be better to use some addrev like other
> devices do? "fw"? To safe some time and possible troubles with typos.
> 
> Just a thought.

Usually I prefer brevity too.  Alas, it may not be clear to many people 
what "fw" is supposed to mean.  People might associate it with, let's 
say, "firewall" before "firewire" when they deal with networking. 
However, more opinions on this are welcome.

As for practical length restrictions:  The kernel's networking core 
requires that these names fit into 15 characters plus trailing \0.  I 
don't have an idea whether there are userland components which have even 
tighter restrictions.

Does anybody know of potential trouble in networking tools if interface 
names are 9 or 10 characters long?

BTW, FreeBSD uses the name fwip%d AFAIK, and OS X just uses fw%d.  (But 
basically nobody is ever confronted with this interface name on OS X 
because Apple's network config GUIs don't use them.)

FWIW, ifconfig's output is still nicely aligned after this change. :-)

-------------------- 8< --------------------

eth0      Link encap:Ethernet  HWaddr 00:23:54:91:8a:2b
           inet addr:192.168.0.42  Bcast:192.168.0.255  Mask:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:12350891 errors:0 dropped:0 overruns:0 frame:0
           TX packets:13934958 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:7376420576 (6.8 GiB)  TX bytes:8066580858 (7.5 GiB)
           Interrupt:28 Base address:0xa000

firewire0 Link encap:UNSPEC  HWaddr 
08-00-28-56-00-00-31-9B-00-00-00-00-00-00-00-00
           inet addr:10.10.222.42  Bcast:10.10.222.255  Mask:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:2 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:0 (0.0 B)  TX bytes:72 (72.0 B)

lo        Link encap:Local Loopback
           inet addr:127.0.0.1  Mask:255.0.0.0
           UP LOOPBACK RUNNING  MTU:16436  Metric:1
           RX packets:2865 errors:0 dropped:0 overruns:0 frame:0
           TX packets:2865 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:0
           RX bytes:1292569 (1.2 MiB)  TX bytes:1292569 (1.2 MiB)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
