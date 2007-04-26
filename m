Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbXDZXAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbXDZXAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbXDZXAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:00:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:13519 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbXDZXAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KOKDjLCluEcSL5HAkcd05PJSvvnVwNnWyrQP00D8UF42U/eLgkD3wJ32jn3hj2E2zFQRoe1Hy0h3mgW6ZthV8sUw9HM0kLw/opYGcx9IaEYXky8qLj92bRFaXuhhcoVuvGdYi7Bxp6r0x/CS8lDc4Mzxnm9iZ6i9xO+0DMuMIQ4=
Message-ID: <6278d2220704261600h2edeafe4j2eec308f1aa9182e@mail.gmail.com>
Date: Fri, 27 Apr 2007 00:00:33 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: [sky2] hw csum failure with 2.6.17 and Yukon-EC...
Cc: "Linux Netdev" <linux-netdev@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On my sky2 platform [1], I'm still seeing lockups after some time [2]
with 2.6.21 (including all the -rc kernels). I've found that 'ethtool
-K lan0 rx off' seems to workaround the problem - I'm running with 9k
jumbo frames, but I find the problem with 1500 byte frames also.

Perhaps you need to blacklist this hardware as having RX offload problems too?

Thanks,
  Dan

--- [1]

sky2 0000:01:00.0: v1.14 addr 0xdfbfc000 irq 16 Yukon-EC (0xb6) rev 1
sky2 eth1: addr 00:03:2d:05:9c:27
sky2 lan0: enabling interface
sky2 lan0: ram buffer 48K
sky2 lan0: Link is up at 1000 Mbps, full duplex, flow control both

--- [2]

kernel: lan0: hw csum failure.
kernel:  [__skb_checksum_complete+93/96] __skb_checksum_complete+0x5d/0x60
kernel:  [nf_ip_checksum+180/288] nf_ip_checksum+0xb4/0x120
kernel:  [tcp_error+375/496] tcp_error+0x177/0x1f0
kernel:  [tcp_manip_pkt+196/256] tcp_manip_pkt+0xc4/0x100
kernel:  [tcp_error+0/496] tcp_error+0x0/0x1f0
kernel:  [nf_conntrack_in+246/1248] nf_conntrack_in+0xf6/0x4e0
kernel:  [sock_queue_rcv_skb+213/256] sock_queue_rcv_skb+0xd5/0x100
kernel:  [packet_rcv_spkt+0/368] packet_rcv_spkt+0x0/0x170
kernel:  [dev_hard_start_xmit+445/544] dev_hard_start_xmit+0x1bd/0x220
kernel:  [nf_iterate+99/144] nf_iterate+0x63/0x90
kernel:  [__qdisc_run+126/336] __qdisc_run+0x7e/0x150
kernel:  [nf_iterate+99/144] nf_iterate+0x63/0x90
kernel:  [ip_rcv_finish+0/528] ip_rcv_finish+0x0/0x210
kernel:  [nf_hook_slow+89/224] nf_hook_slow+0x59/0xe0
kernel:  [ip_rcv_finish+0/528] ip_rcv_finish+0x0/0x210
kernel:  [ip_rcv+701/1120] ip_rcv+0x2bd/0x460
kernel:  [ip_rcv_finish+0/528] ip_rcv_finish+0x0/0x210
kernel:  [packet_rcv_spkt+226/368] packet_rcv_spkt+0xe2/0x170
kernel:  [netif_receive_skb+488/752] netif_receive_skb+0x1e8/0x2f0
kernel:  [sky2_poll+915/2432] sky2_poll+0x393/0x980
kernel:  [e100_rx_alloc_skb+36/144] e100_rx_alloc_skb+0x24/0x90
kernel:  [e100_poll+848/992] e100_poll+0x350/0x3e0
kernel:  [net_rx_action+92/256] net_rx_action+0x5c/0x100
kernel:  [__do_softirq+66/144] __do_softirq+0x42/0x90
kernel:  [do_softirq+92/176] do_softirq+0x5c/0xb0
kernel:  [handle_edge_irq+0/224] handle_edge_irq+0x0/0xe0
kernel:  [irq_exit+90/96] irq_exit+0x5a/0x60
kernel:  [do_IRQ+112/176] do_IRQ+0x70/0xb0
kernel:  [enqueue_hrtimer+107/272] enqueue_hrtimer+0x6b/0x110
kernel:  [common_interrupt+35/40] common_interrupt+0x23/0x28
kernel:  [default_idle+42/64] default_idle+0x2a/0x40
kernel:  [cpu_idle+62/96] cpu_idle+0x3e/0x60
kernel:  [start_kernel+760/912] start_kernel+0x2f8/0x390
kernel:  [unknown_bootoption+0/608] unknown_bootoption+0x0/0x260
kernel:  =======================
-- 
Daniel J Blueman
