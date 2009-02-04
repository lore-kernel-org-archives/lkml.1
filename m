Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZBDPTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZBDPTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZBDPTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:19:21 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:59135 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbZBDPTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:19:19 -0500
Message-ID: <4989B1C3.2040805@hiramoto.org>
Date: Wed, 04 Feb 2009 16:18:27 +0100
From: Karl Hiramoto <karl@hiramoto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: netfilter@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: NF_CT_ASSERT()  with NAT on  IP over ATM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Using classical IP over ATM(RFC1577 / RFC2225) I have the following
NF_CT_ASSERT()  occurring:


------------[ cut here
]------------                                                                                                          

WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89
nf_nat_fn+0x44/0x194
[iptable_nat]()                                                    
Modules linked in: xt_MARK crc_ccitt nf_conntrack_pptp
nf_conntrack_proto_gre ixp4xx_crypto ipt_MASQUERADE ipt_REDIRECT
nf_nat_sip nf_conntrac)
[<c0025798>] (dump_stack+0x0/0x14) from [<c0031878>]
(warn_on_slowpath+0x4c/0x68)                                                             

[<c003182c>] (warn_on_slowpath+0x0/0x68) from [<bf0d13a0>]
(nf_nat_fn+0x44/0x194
[iptable_nat])                                               
 r6:00000004 r5:c583d240
r4:bf0d24e8                                                                                                          

[<bf0d135c>] (nf_nat_fn+0x0/0x194 [iptable_nat]) from [<bf0d1764>]
(nf_nat_out+0x44/0xc4 [iptable_nat])
[<bf0d1720>] (nf_nat_out+0x0/0xc4 [iptable_nat]) from [<c01e5a9c>]
(nf_iterate+0x64/0xd0)
 r5:c0313d70 r4:bf0d24e8
[<c01e5a38>] (nf_iterate+0x0/0xd0) from [<c01e5b6c>]
(nf_hook_slow+0x64/0xf0)
[<c01e5b08>] (nf_hook_slow+0x0/0xf0) from [<c01f1c38>] (ip_output+0x84/0xa4)
[<c01f1bb4>] (ip_output+0x0/0xa4) from [<c01eea10>]
(ip_forward_finish+0x44/0x4c)
 r4:c583d240
[<c01ee9cc>] (ip_forward_finish+0x0/0x4c) from [<c01eecdc>]
(ip_forward+0x2c4/0x340)
 r4:c583d240
[<c01eea18>] (ip_forward+0x0/0x340) from [<c01ed5d8>]
(ip_rcv_finish+0x338/0x35c)
 r7:c7d78000 r6:c034ce64 r5:c588e018 r4:c034d0ac
[<c01ed2a0>] (ip_rcv_finish+0x0/0x35c) from [<c01edb18>]
(ip_rcv+0x23c/0x270)
[<c01ed8dc>] (ip_rcv+0x0/0x270) from [<c01d0fe8>]
(netif_receive_skb+0x380/0x3c0)
 r7:00000800 r6:c7d78000 r5:c583d240 r4:c034d0ac
[<c01d0c68>] (netif_receive_skb+0x0/0x3c0) from [<c01d35fc>]
(process_backlog+0x8c/0x128)
[<c01d3570>] (process_backlog+0x0/0x128) from [<c01d2fec>]
(net_rx_action+0x60/0x1b8)
[<c01d2f8c>] (net_rx_action+0x0/0x1b8) from [<c0036458>]
(__do_softirq+0x68/0x104)
[<c00363f0>] (__do_softirq+0x0/0x104) from [<c00367c8>] (irq_exit+0x44/0x4c)
[<c0036784>] (irq_exit+0x0/0x4c) from [<c0021068>]
(__exception_text_start+0x68/0x84)
[<c0021000>] (__exception_text_start+0x0/0x84) from [<c00219c4>]
(__irq_svc+0x24/0x80)
Exception stack(0xc0313f4c to 0xc0313f94)
3f40:                            c0333ad4 c78e4600 a0000013 00000000
c0022dd8
3f60: c0312000 c0022dd8 c0333148 0001d74c 69054041 0001d67c c0313fc0
c0313fa4
3f80: c0313f94 c0022ca0 c0022de0 60000013 ffffffff
 r5:0000001f r4:ffffffff
[<c0022c64>] (cpu_idle+0x0/0x58) from [<c025b078>] (rest_init+0x54/0x68)
 r7:c031636c r6:c001edb8 r5:c0332cc4 r4:c033f260
[<c025b024>] (rest_init+0x0/0x68) from [<c00089d0>]
(start_kernel+0x244/0x2a4)
[<c000878c>] (start_kernel+0x0/0x2a4) from [<00008034>] (0x8034)
 r6:c001f1bc r5:c03331ac r4:000039fd
---[ end trace 223a280469e2bcdb ]



I'm using kernel version 2.6.28.3  on a big endian ARM IXP435 CPU.   I
use the linux-atm tools  atmarp and atmarpd to setup the connection.  
All normal (NO NAT) traffic works fine only MASQUERADE traffic fails. 
On the same machine I use br2684ctl  RFC2684  ATM links and everything
works fine with no issues.


I have

NAT Host: 192.168.1.2/24
/|\
 |
 |
\|/
ROTUER LAN: 192.168.1.2/25
ROUTER WAN: 1.2.3.4/24
/|\
 |
 |
\|/
EXTERNAL HOST: 5.6.7.8


Using tcpdump on the router, i can see a ping from "NAT Host" to
"External Host" leave correctly and NAT is done.   When the Ping returns
from the "External Host"  The Router does nothing with the ping
response, and "NAT Host" does not see the ping response.


The NAT setup:


# iptables -t nat -L -vn
Chain PREROUTING (policy ACCEPT 145 packets, 9940 bytes)
 pkts bytes target     prot opt in     out     source              
destination        
  273 16380 REDIRECT   tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           MARK match 0x103 redir ports 8000
    0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           MARK match 0x101 redir ports 8080
    0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           MARK match 0x102 redir ports 8110
    1    54 REDIRECT   tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           MARK match 0x104 redir ports 8023
  144  9883 NAT_PRE    all  --  *      *       0.0.0.0/0           
0.0.0.0/0                                            
    0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           ADDRTYPE match dst-type LOCAL tcp dpt:8000 redir ports
    0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           ADDRTYPE match dst-type LOCAL tcp dpt:8080 redir ports
    0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           ADDRTYPE match dst-type LOCAL tcp dpt:8110 redir ports
    0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           ADDRTYPE match dst-type LOCAL tcp dpt:8023 redir ports

Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source              
destination        
   75  5170 NAT_IPSEC  all  --  *      *       0.0.0.0/0           
0.0.0.0/0          
   75  5170 IPSec      all  --  *      *       0.0.0.0/0           
0.0.0.0/0          
   75  5170 NAT_POST   all  --  *      *       0.0.0.0/0           
0.0.0.0/0          
   75  5170 DefNAT     all  --  *      *       0.0.0.0/0           
0.0.0.0/0          

Chain OUTPUT (policy ACCEPT 5 packets, 420 bytes)
 pkts bytes target     prot opt in     out     source              
destination        
    5   420 NAT_OUT    all  --  *      *       0.0.0.0/0           
0.0.0.0/0          

Chain DefNAT (1 references)
 pkts bytes target     prot opt in     out     source              
destination        
   75  5170 MASQUERADE  all  --  *      atm0    0.0.0.0/0           
0.0.0.0/0          

Chain IPSec (1 references)
 pkts bytes target     prot opt in     out     source              
destination        
    0     0 ACCEPT     esp  --  *      *       0.0.0.0/0           
0.0.0.0/0          
    0     0 ACCEPT     ah   --  *      *       0.0.0.0/0           
0.0.0.0/0          
    0     0 ACCEPT     udp  --  *      *       0.0.0.0/0           
0.0.0.0/0           udp dpt:500
    0     0 ACCEPT     udp  --  *      *       0.0.0.0/0           
0.0.0.0/0           udp dpt:4500

Chain NAT_IPSEC (1 references)
 pkts bytes target     prot opt in     out     source              
destination        

Chain NAT_OUT (1 references)
 pkts bytes target     prot opt in     out     source              
destination        

Chain NAT_POST (1 references)
 pkts bytes target     prot opt in     out     source              
destination        

Chain NAT_PRE (1 references)
 pkts bytes target     prot opt in     out     source              
destination    



Wondering if anyone knows how to fix this, or could point me in the
right direction of where to start looking.

Thanks.

--
Karl

