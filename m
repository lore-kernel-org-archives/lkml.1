Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYIPMkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYIPMkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYIPMkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:40:08 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:63073 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIPMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j9fRDnwR/EKII9g7gK7/23e2duqlvHysKkNkIfFfc9yMODiKIbYbUr8jewd8fFwY4o
         UMrSYd1MOUK39JMf7t0BX0W1XH1WtH0qVKfo1cL3DKGcLl8HdWkm+rNgfZnItWND/ROK
         7QLyi+0cbNdUP6ukHF2g/w052dm8ZsNAf7P+4=
Message-ID: <efeafa350809160540j5dba16bma38644c3dceca92a@mail.gmail.com>
Date: Tue, 16 Sep 2008 14:40:03 +0200
From: Lazy <lazy404@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-netdev@vger.kernel.org
Subject: Re: SKB BUG: Invalid truesize (412) len=28, ipsec related ?
In-Reply-To: <efeafa350808070748t652a77cm9bf28aad851aa791@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <efeafa350808070748t652a77cm9bf28aad851aa791@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/7 Lazy <lazy404@gmail.com>:
> vanilla 2.6.25.13, working as a router, 4 interfaces about 100MBit/s traffic
> using e1000 and tg3 ethernet drivers
>
> it's a production machine so I basicly can't touch it now, I think
> it's triggerd by ipsec tunnel because
> before rolling this machine on production it was stress tested
> (without the tunnel) to tune the firewall,
> and there ware no BUG()'s triggerd.
>
> Aug  7 07:16:49 cisco-ng kernel: SKB BUG: Invalid truesize (412)
> len=286, sizeof(sk_buff)=156
> Aug  7 07:16:51 cisco-ng kernel: SKB BUG: Invalid truesize (284)
> len=142, sizeof(sk_buff)=156
> Aug  7 07:16:51 cisco-ng kernel: SKB BUG: Invalid truesize (284)
> len=142, sizeof(sk_buff)=156
> Aug  7 07:16:54 cisco-ng kernel: SKB BUG: Invalid truesize (284)
> len=134, sizeof(sk_buff)=156
> Aug  7 07:16:55 cisco-ng kernel: SKB BUG: Invalid truesize (284)
> len=134, sizeof(sk_buff)=156
> Aug  7 07:16:59 cisco-ng kernel: SKB BUG: Invalid truesize (284)
> len=142, sizeof(sk_buff)=156
> Aug  7 07:16:59 cisco-ng kernel: SKB BUG: Invalid truesize (284)
> len=142, sizeof(sk_buff)=156
>
> tunnel is created by setkey
> add 10.0.5.2 10.0.5.1 esp 0xxxx -m tunnel -E 3des-cbc ...
>
> Tomorrow i will try to trigger it in a test environment, any pointers
> how to get more info out of it?
> I found this http://lists.openwall.net/netdev/2008/05/06/61 will it be ok ?
with this patch i got some more info

c02ef322>] __netdev_alloc_skb+0x22/0x50
 [<f88c4ea5>] e1000_clean_rx_irq+0x3f5/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
 [<c0129014>] __do_softirq+0xd4/0xf0
 [<c0129068>] do_softirq+0x38/0x40
 [<c01055ae>] do_IRQ+0x3e/0x80
 [<c010380b>] common_interrupt+0x23/0x28
 [<c010142c>] mwait_idle_with_hints+0x3c/0x50
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c02ef322>] __netdev_alloc_skb+0x22/0x50
 [<f88c4ea5>] e1000_clean_rx_irq+0x3f5/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
 [<c0129014>] __do_softirq+0xd4/0xf0
 [<c0129068>] do_softirq+0x38/0x40
 [<c01055ae>] do_IRQ+0x3e/0x80
 [<c010380b>] common_interrupt+0x23/0x28
 [<c010142c>] mwait_idle_with_hints+0x3c/0x50
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c032b32d>] tcp_send_ack+0x2d/0xe0
 [<c0326cb7>] tcp_rcv_established+0x4c7/0x690
 [<c032e915>] tcp_v4_do_rcv+0x105/0x110
 [<c032ee2b>] tcp_v4_rcv+0x50b/0x5f0
 [<c0313244>] ip_local_deliver_finish+0x84/0x160
 [<c0313369>] ip_local_deliver+0x49/0xa0
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c011ba2d>] enqueue_task_fair+0x2d/0x30
 [<c011d442>] enqueue_task+0x12/0x30
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c02ef322>] __netdev_alloc_skb+0x22/0x50
 [<f88c4ea5>] e1000_clean_rx_irq+0x3f5/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
 [<c0129014>] __do_softirq+0xd4/0xf0
 [<c0129068>] do_softirq+0x38/0x40
 [<c01055ae>] do_IRQ+0x3e/0x80
 [<c010380b>] common_interrupt+0x23/0x28
 [<c010142c>] mwait_idle_with_hints+0x3c/0x50
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c02ef322>] __netdev_alloc_skb+0x22/0x50
 [<f88c4ea5>] e1000_clean_rx_irq+0x3f5/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
 [<c0129014>] __do_softirq+0xd4/0xf0
 [<c0129068>] do_softirq+0x38/0x40
 [<c01055ae>] do_IRQ+0x3e/0x80
 [<c010380b>] common_interrupt+0x23/0x28
 [<c010142c>] mwait_idle_with_hints+0x3c/0x50
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c02ef322>] __netdev_alloc_skb+0x22/0x50
 [<f88c4ea5>] e1000_clean_rx_irq+0x3f5/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
 [<c0129014>] __do_softirq+0xd4/0xf0
 [<c0129068>] do_softirq+0x38/0x40
 [<c01055ae>] do_IRQ+0x3e/0x80
 [<c010380b>] common_interrupt+0x23/0x28
 [<c010142c>] mwait_idle_with_hints+0x3c/0x50
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c032b32d>] tcp_send_ack+0x2d/0xe0
 [<c0326cb7>] tcp_rcv_established+0x4c7/0x690
 [<c032e915>] tcp_v4_do_rcv+0x105/0x110
 [<c032ee2b>] tcp_v4_rcv+0x50b/0x5f0
[<c0313244>] ip_local_deliver_finish+0x84/0x160
 [<c0313369>] ip_local_deliver+0x49/0xa0
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c011ba2d>] enqueue_task_fair+0x2d/0x30
 [<c011d442>] enqueue_task+0x12/0x30
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c02ef322>] __netdev_alloc_skb+0x22/0x50
 [<f88c4ea5>] e1000_clean_rx_irq+0x3f5/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
[<c0129014>] __do_softirq+0xd4/0xf0
 [<c0129068>] do_softirq+0x38/0x40
 [<c01055ae>] do_IRQ+0x3e/0x80
 [<c010380b>] common_interrupt+0x23/0x28
 [<c010142c>] mwait_idle_with_hints+0x3c/0x50
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c02ef322>] __netdev_alloc_skb+0x22/0x50
 [<f88c4ea5>] e1000_clean_rx_irq+0x3f5/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
 [<c0129014>] __do_softirq+0xd4/0xf0
 [<c0129068>] do_softirq+0x38/0x40
 [<c01055ae>] do_IRQ+0x3e/0x80
 [<c010380b>] common_interrupt+0x23/0x28
 [<c010142c>] mwait_idle_with_hints+0x3c/0x50
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c032b32d>] tcp_send_ack+0x2d/0xe0
 [<c0326cb7>] tcp_rcv_established+0x4c7/0x690
 [<c032e915>] tcp_v4_do_rcv+0x105/0x110
 [<c032ee2b>] tcp_v4_rcv+0x50b/0x5f0
 [<c0313244>] ip_local_deliver_finish+0x84/0x160
 [<c0313369>] ip_local_deliver+0x49/0xa0
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c013b710>] getnstimeofday+0x40/0x120
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c02ef2bd>] __alloc_skb+0xdd/0x120
 [<c02ef322>] __netdev_alloc_skb+0x22/0x50
 [<f88c4ea5>] e1000_clean_rx_irq+0x3f5/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
 [<c0129014>] __do_softirq+0xd4/0xf0
 [<c0129068>] do_softirq+0x38/0x40
 [<c01055ae>] do_IRQ+0x3e/0x80
 [<c010380b>] common_interrupt+0x23/0x28
 [<c010142c>] mwait_idle_with_hints+0x3c/0x50
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c01347dc>] __kernel_text_address+0x1c/0x30
 [<c0313827>] ip_rcv+0x167/0x280
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c013b710>] getnstimeofday+0x40/0x120
 [<c0313827>] ip_rcv+0x167/0x280
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c013b710>] getnstimeofday+0x40/0x120
 [<c0313827>] ip_rcv+0x167/0x280
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
SKB BUG: Invalid truesize (340) size=468, sizeof(sk_buff)=212
last reallocate at:
 [<c010a9ac>] save_stack_trace+0x2c/0x50
 [<c02efb25>] pskb_expand_head+0x85/0x1a0
 [<c0314850>] ip_forward+0x120/0x330
 [<c03134bb>] ip_rcv_finish+0xfb/0x300
 [<c013b710>] getnstimeofday+0x40/0x120
 [<c0313827>] ip_rcv+0x167/0x280
 [<c02f66d9>] netif_receive_skb+0x249/0x300
 [<f88c4c5c>] e1000_clean_rx_irq+0x1ac/0x500 [e1000]
 [<f88c468d>] e1000_clean+0x3d/0xc0 [e1000]
 [<c02f69ee>] net_rx_action+0x14e/0x1a0
device eth21 left promiscuous mode

the funny thing is that it happens only with tcpdump active on this interface

kernel 2.6.25.17, ipsec tunnel, smal packets < 97 bytes are trigger
thiese errors, kernel runs without problems,
I observed same thing on e100 network driver

 --
Lazy
