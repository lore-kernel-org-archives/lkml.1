Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYHGPri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYHGPri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYHGPra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:47:30 -0400
Received: from squeaker.ratbox.org ([66.212.148.233]:49770 "EHLO
	squeaker.ratbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYHGPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:47:29 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 11:47:29 EDT
Date: Thu, 7 Aug 2008 11:39:55 -0400 (EDT)
From: Aaron Sethman <androsyn@ratbox.org>
To: linux-kernel@vger.kernel.org
Subject: sungem lockup on 2.6.26.2 on sparc64
Message-ID: <alpine.LNX.1.10.0808071138160.3804@squeaker.ratbox.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this on 2.6.26.2 on sparc64

eth1: Pause is disabled
BUG: soft lockup - CPU#0 stuck for 61s! [ifconfig:1297]
TSTATE: 0000000080009600 TPC: 00000000005ed080 TNPC: 00000000005ed084 Y: 
00000000    Not tainted
g0: 0000000000000000 g1: fffff80047beef90 g2: fffff80047beef90 g3: 
fffff80065670560
g4: fffff80066193060 g5: 0000006574683100 g6: fffff80047bec000 g7: 
00000000007db630
o0: fffff80065670000 o1: fffff80047bec400 o2: 0000000000460f24 o3: 
0000000000000100
o4: fffff80066096000 o5: fffff80066096000 sp: fffff80047bee6e1 ret_pc: 
00000000004610b4
l0: 00000000007da780 l1: 0000000000000100 l2: fffff80047beef90 l3: 
00000000005ed080
l4: 0000000000715758 l5: 00000000007db790 l6: 00000000007dbb90 l7: 
ff2002ffff2002ff
i0: 00000000007da320 i1: fffff80066096650 i2: 0000000000000001 i3: 
0000000000000000
i4: 00000000007dc390 i5: 00000000007dbf90 i6: fffff80047bee7b1 i7: 
000000000045bf10


The output of ksymoops on this is as follows:

Reading Oops report from the terminal
TSTATE: 0000000080009600 TPC: 00000000005ed080 TNPC: 00000000005ed084 Y: 
00000000    Not tainted
Using defaults from ksymoops -a sparc
g0: 0000000000000000 g1: fffff80047beef90 g2: fffff80047beef90 g3: 
fffff80065670560
g4: fffff80066193060 g5: 0000006574683100 g6: fffff80047bec000 g7: 
00000000007db630
o0: fffff80065670000 o1: fffff80047bec400 o2: 0000000000460f24 o3: 
0000000000000100
o4: fffff80066096000 o5: fffff80066096000 sp: fffff80047bee6e1 ret_pc: 
00000000004610b4
l0: 00000000007da780 l1: 0000000000000100 l2: fffff80047beef90 l3: 
00000000005ed080
l4: 0000000000715758 l5: 00000000007db790 l6: 00000000007dbb90 l7: 
ff2002ffff2002ff
i0: 00000000007da320 i1: fffff80066096650 i2: 0000000000000001 i3: 
0000000000000000
i4: 00000000007dc390 i5: 00000000007dbf90 i6: fffff80047bee7b1 i7: 
000000000045bf10


>>TPC; 005ed080 <sym53c8xx_timer+0/40>   <=====

>>g7; 007db630 <boot_tvec_bases+eb0/2040>
>>o2; 00460f24 <run_timer_softirq+4/200>
>>ret_pc; 004610b4 <run_timer_softirq+194/200>
>>l0; 007da780 <boot_tvec_bases+0/2040>
>>l3; 005ed080 <sym53c8xx_timer+0/40>
>>l4; 00715758 <jiffies+0/0>
>>l5; 007db790 <boot_tvec_bases+1010/2040>
>>l6; 007dbb90 <boot_tvec_bases+1410/2040>
>>i0; 007da320 <softirq_vec+10/200>
>>i4; 007dc390 <boot_tvec_bases+1c10/2040>
>>i5; 007dbf90 <boot_tvec_bases+1810/2040>
>>i7; 0045bf10 <__do_softirq+70/100>


Any ideas or clues?

-Aaron
