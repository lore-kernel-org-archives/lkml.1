Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbXIWCK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbXIWCK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 22:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXIWCKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 22:10:19 -0400
Received: from smtp1.Vir.com ([199.202.113.40]:48086 "EHLO smtp1.vir.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbXIWCKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 22:10:18 -0400
Message-ID: <46F5CB08.9060108@soo.com>
Date: Sat, 22 Sep 2007 22:10:16 -0400
From: ben soo <lnx-kern@soo.com>
Reply-To: lnx-kern@soo.com
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Carlos_Narv=E1ez?= <crakup@gmail.com>,
       Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Linux Router
References: <e660b2250709221609l1475c061t5a1a78de4fa529f@mail.gmail.com>
In-Reply-To: <e660b2250709221609l1475c061t5a1a78de4fa529f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i used to add proxy arp's on the router when i had problems like 
this.  Dunno if it's the recommended fix, but it worked.

http://en.wikipedia.org/wiki/Proxy_arp

Carlos Narváez wrote:
>  This is starting to frustrate me, because it should be much simpler
> than it seems to be, and I feel like I'm missing something small and
> obvious.
> 
> I have two private networks, we'll say 192.168.254.0/24 and
> 192.168.251.0/24. And I have a linux box in the middle with addresses
> 192.168.254.17 and 192.168.251.10:
> 
> 
> +---------------+ . +----------------+
> ¦ 192.168.251.1 +---+ 192.168.251.10 ¦ . +----------------+
> +---------------+ . ¦ 192.168.254.17 +---+ 192.168.254.16 ¦
> . . . . . . . . . . +----------------+ . +----------------+
> 
> 
> There is no NAT involved.. I just want the box in the middle to pass
> traffic between the two networks. Here is what I have done:
> 
> - IP Forwarding has been enabled on the router via "echo 1 >
> /proc/sys/net/ipv4/ip_forward"
> 
> - A route has been configured on 192.168.251.1 to point all traffic
> for 192.168.254.0/24 to 192.168.251.10.
> 
> - A route has been configured on 192.168.254.16 to point all traffic
> for 192.168.251.0/24 to 192.168.254.17.
> 
> - The command "iptables -I FORWARD -j ACCEPT" has been executed.
> 
> Now.. here's what happens. 192.168.251.10 can ping both interfaces on
> the router. 192.168.254.16 can also ping both interfaces on the
> router. However, 192.168.251.1 cannot ping 192.168.254.16, and
> likewise, 192.168.254.16 cannot ping 192.168.251.1.
> 
> What have I forgotten?
> 

