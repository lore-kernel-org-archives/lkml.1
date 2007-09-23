Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbXIWGZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbXIWGZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXIWGZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:25:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48791 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbXIWGZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:25:23 -0400
Date: Sun, 23 Sep 2007 08:25:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: ben soo <lnx-kern@soo.com>
cc: =?ISO-8859-1?Q?Carlos_Narv=E1ez?= <crakup@gmail.com>,
       Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Linux Router
In-Reply-To: <46F5CB08.9060108@soo.com>
Message-ID: <Pine.LNX.4.64.0709230822510.15712@fbirervta.pbzchgretzou.qr>
References: <e660b2250709221609l1475c061t5a1a78de4fa529f@mail.gmail.com>
 <46F5CB08.9060108@soo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 22 2007 22:10, ben soo wrote:
>
> i used to add proxy arp's on the router when i had problems like this.  Dunno
> if it's the recommended fix, but it worked.

There is certainly no Proxy ARP required here since you do not
do subnet sharing or funny games like that.

> http://en.wikipedia.org/wiki/Proxy_arp
>
> Carlos Narváez wrote:
>> +---------------+ . +----------------+
>> ¦ 192.168.251.1 +---+ 192.168.251.10 ¦ . +----------------+
>> +---------------+ . ¦ 192.168.254.17 +---+ 192.168.254.16 ¦
>> . . . . . . . . . . +----------------+ . +----------------+
>> 
>> - A route has been configured on 192.168.251.1 to point all traffic
>> for 192.168.254.0/24 to 192.168.251.10.
>> 
>> - A route has been configured on 192.168.254.16 to point all traffic
>> for 192.168.251.0/24 to 192.168.254.17.
>> 
>> - The command "iptables -I FORWARD -j ACCEPT" has been executed.

Well, and do the counters increase?

>> Now.. here's what happens. 192.168.251.10 can ping both interfaces on
>> the router. 192.168.254.16 can also ping both interfaces on the
>> router. However, 192.168.251.1 cannot ping 192.168.254.16, and
>> likewise, 192.168.254.16 cannot ping 192.168.251.1.
>> 
>> What have I forgotten?

Default GWs (though if you ahve routes, ok..).

On 251.1, use `ip r g 192.168.254.16` and it should
show "192.168.254.16 via 192.168.251.10 dev eth0 ...".

Same on the other side.
