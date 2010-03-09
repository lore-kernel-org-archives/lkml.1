Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0CIWKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:10:21 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42595 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0CIWKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 17:10:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cIaLSE8CPuYaXb+aY5fOlNr3h8z2h3m4GuN6oyeBTj8T1oc6E66eGSYftTr9NCuKA7
         1hhS1bPsAJZGmB6SyEEoiFhNtW8EY/2WOoW529xR7yQbbxJ0J8g5pouBt92XmakiRZsc
         q0yEGq8/pe4E60pnxuqn7cgw1MmHYeakkFCXo=
Subject: Re: how to tweak ARP timer on kernel 2.6.9
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tom Ammon <tom.ammon@utah.edu>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <4B96A24A.6060405@utah.edu>
References: <4B96A24A.6060405@utah.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 23:10:14 +0100
Message-ID: <1268172614.2872.122.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 09 mars 2010 à 12:32 -0700, Tom Ammon a écrit :
> Hi,
> 
> I've been trying to figure out how to adjust the ARP timeout on kernel 
> 2.6.9 and I found the following in /proc/sys/net/ipv4/neigh/ib0 (its an 
> IB interface I am interested in changing) with the following values. 
> This is on kernel 2.6.9-89ELsmp (RHEL4) :
> 

> When I test this, along with per-flow ECMP (using the iproute2 utils), I 
> see that the ARP cache is timing out about every 10 minutes (I observe 
> this by load balancing an iperf flow between two different gateway 
> machines and then graphing the interface traffic)
> 

10 minutes seems out of specs.

> On a newer kernel, 2.6.18-164.11.1.el5 (RHEL5), I see mostly the same 
> parms available, but a few new ones have been added. However, all of the 
> parms that are the same name between the two kernels are the same values:
> 

> Yet when I observe the same traffic flow with this machine, the ARP 
> cache times out about once per minute.
> 

This seems normal, old kernels were a bit lazy about arp.


> Is there another set of parameters somewhere that govern how often the 
> kernel times out the ARP cache? If so, where might I find that? Is there 
> any kernel documentation that talks about changing ARP timers on the 
> linux kernel?
> 

I would suggest :

man 7 arp

http://linux.die.net/man/7/arp



base_reachable_time
        Once a neighbour has been found, the entry is considered to be
        valid for at least a random value between base_reachable_time/2
        and 3*base_reachable_time/2. An entry's validity will be
        extended if it receives positive feedback from higher level
        protocols. Defaults to 30 seconds.

gc_interval
        How frequently the garbage collector for neighbour entries
        should attempt to run. Defaults to 30 seconds.

gc_stale_time
        Determines how often to check for stale neighbour entries. When
        a neighbour entry is considered stale it is resolved again
        before sending data to it. Defaults to 60 seconds.
        


and "ip -s neigh"


