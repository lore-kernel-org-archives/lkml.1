Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYHGWf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYHGWf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYHGWfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:35:13 -0400
Received: from main.gmane.org ([80.91.229.2]:44626 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYHGWfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:35:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: sungem lockup on 2.6.26.2 on sparc64
Date: Thu, 7 Aug 2008 23:16:45 +0100
Message-ID: <dr8sm5-vjr.ln1@woodchuck.wormnet.eu>
References: <alpine.LNX.1.10.0808071138160.3804@squeaker.ratbox.org>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: tin/1.9.2-20070201 ("Dalaruan") (UNIX) (Linux/2.6.25-2-sparc64 (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Sethman <androsyn@ratbox.org> wrote:
>
> Got this on 2.6.26.2 on sparc64
>
I got it on a 2.6.24 (going up from 2.6.18ish) :-/  I also too get it
on a 2.6.26 kernel.
 
> eth1: Pause is disabled
> BUG: soft lockup - CPU#0 stuck for 61s! [ifconfig:1297]
> TSTATE: 0000000080009600 TPC: 00000000005ed080 TNPC: 00000000005ed084 Y: 
> 00000000    Not tainted
> g0: 0000000000000000 g1: fffff80047beef90 g2: fffff80047beef90 g3: 
> fffff80065670560
> g4: fffff80066193060 g5: 0000006574683100 g6: fffff80047bec000 g7: 
> 00000000007db630
> o0: fffff80065670000 o1: fffff80047bec400 o2: 0000000000460f24 o3: 
> 0000000000000100
> o4: fffff80066096000 o5: fffff80066096000 sp: fffff80047bee6e1 ret_pc: 
> 00000000004610b4
> l0: 00000000007da780 l1: 0000000000000100 l2: fffff80047beef90 l3: 
> 00000000005ed080
> l4: 0000000000715758 l5: 00000000007db790 l6: 00000000007dbb90 l7: 
> ff2002ffff2002ff
> i0: 00000000007da320 i1: fffff80066096650 i2: 0000000000000001 i3: 
> 0000000000000000
> i4: 00000000007dc390 i5: 00000000007dbf90 i6: fffff80047bee7b1 i7: 
> 000000000045bf10
> 
> 
> The output of ksymoops on this is as follows:
> 
> Reading Oops report from the terminal
> TSTATE: 0000000080009600 TPC: 00000000005ed080 TNPC: 00000000005ed084 Y: 
> 00000000    Not tainted
> Using defaults from ksymoops -a sparc
> g0: 0000000000000000 g1: fffff80047beef90 g2: fffff80047beef90 g3: 
> fffff80065670560
> g4: fffff80066193060 g5: 0000006574683100 g6: fffff80047bec000 g7: 
> 00000000007db630
> o0: fffff80065670000 o1: fffff80047bec400 o2: 0000000000460f24 o3: 
> 0000000000000100
> o4: fffff80066096000 o5: fffff80066096000 sp: fffff80047bee6e1 ret_pc: 
> 00000000004610b4
> l0: 00000000007da780 l1: 0000000000000100 l2: fffff80047beef90 l3: 
> 00000000005ed080
> l4: 0000000000715758 l5: 00000000007db790 l6: 00000000007dbb90 l7: 
> ff2002ffff2002ff
> i0: 00000000007da320 i1: fffff80066096650 i2: 0000000000000001 i3: 
> 0000000000000000
> i4: 00000000007dc390 i5: 00000000007dbf90 i6: fffff80047bee7b1 i7: 
> 000000000045bf10
> 
> 
>>>TPC; 005ed080 <sym53c8xx_timer+0/40>   <=====
> 
>>>g7; 007db630 <boot_tvec_bases+eb0/2040>
>>>o2; 00460f24 <run_timer_softirq+4/200>
>>>ret_pc; 004610b4 <run_timer_softirq+194/200>
>>>l0; 007da780 <boot_tvec_bases+0/2040>
>>>l3; 005ed080 <sym53c8xx_timer+0/40>
>>>l4; 00715758 <jiffies+0/0>
>>>l5; 007db790 <boot_tvec_bases+1010/2040>
>>>l6; 007dbb90 <boot_tvec_bases+1410/2040>
>>>i0; 007da320 <softirq_vec+10/200>
>>>i4; 007dc390 <boot_tvec_bases+1c10/2040>
>>>i5; 007dbf90 <boot_tvec_bases+1810/2040>
>>>i7; 0045bf10 <__do_softirq+70/100>
> 
Yeah, exactly the same for me, it cares not about PREEMPT either (the
only testing I did do).

> Any ideas or clues?
>
I found its the autoneg bit and kept meaning to track down the bug.
Alas the Netra I have powered on is 'production' and the users
complain when I reboot regularly and the spare one I have is under my
desk and needs some love and attention.

The workaround I have is just before you configure your NIC's
(assuming you only use eth0) to put in your network startup scripts:

====
ethtool -s eth0 autoneg off
ethtool -s eth1 autoneg off
ethtool -s eth0 autoneg on
====

So for debian, prepend 'pre-up' before those lines.

I apologise to the maintainer of the driver for being lazy :-/

Cheers

Alex

