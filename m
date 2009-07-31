Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbZGaM2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbZGaM2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZGaM2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:28:35 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46040 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZGaM2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:28:34 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2009 08:28:33 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Z98YB9nlTPG0/Hg8xmParrV8OoRrPc/CrCdYi2NZj4Qz/XS62wBSgufUSZddoxTYEc
         7iyr0VaAnu4zWy93EXMmlE7GkCWRXvca69ip7KL2vqcwcN1QcWMftcFuCPe+2rP9nBnX
         xp1d1ieQUnZbsBUkF+MK4MwN8JfJPG8LClkeI=
MIME-Version: 1.0
Date: Fri, 31 Jul 2009 14:21:32 +0200
Message-ID: <c4e36d110907310521v1234e8fdg99a101a4057dc51e@mail.gmail.com>
Subject: kmemleak report from network usage
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: catalin.marinas@arm.com, linux.nics@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


Recently I'm running kernel with kmemleak.

Here are some frequently repeating messages:

Are they false positives or some real leaks?

 unreferenced object 0xffff880139e5ec78 (size 96):
  comm "NetworkManager", pid 1505, jiffies 4294887099
  backtrace:
    [<ffffffff810ff6f2>] create_object+0x142/0x2d0
    [<ffffffff810ff9a6>] kmemleak_alloc+0x26/0x60
    [<ffffffff810fb083>] kmem_cache_alloc+0x133/0x1a0
    [<ffffffff810a0947>] request_threaded_irq+0xb7/0x250
    [<ffffffffa00d9003>] e1000_request_irq+0x1f3/0x280 [e1000e]
    [<ffffffffa00dc8f0>] e1000_open+0x3f0/0x4c4 [e1000e]
    [<ffffffff812f32f1>] dev_open+0xa1/0x100
    [<ffffffff812f2956>] dev_change_flags+0x96/0x1c0
    [<ffffffff812feb92>] do_setlink+0x212/0x490
    [<ffffffff812ff442>] rtnl_setlink+0x122/0x160
    [<ffffffff812fe70f>] rtnetlink_rcv_msg+0x1df/0x220
    [<ffffffff8130a349>] netlink_rcv_skb+0xa9/0xd0
    [<ffffffff812fe515>] rtnetlink_rcv+0x25/0x40
    [<ffffffff81309bbd>] netlink_unicast+0x29d/0x2f0
    [<ffffffff8130ada2>] netlink_sendmsg+0x222/0x310
    [<ffffffff812e1acb>] sock_sendmsg+0x10b/0x140


unreferenced object 0xffff8800b2a6d180 (size 328):
  comm "softirq", pid 0, jiffies 4295453369
  backtrace:
    [<ffffffff810ff6f2>] create_object+0x142/0x2d0
    [<ffffffff810ff9a6>] kmemleak_alloc+0x26/0x60
    [<ffffffff810fb083>] kmem_cache_alloc+0x133/0x1a0
    [<ffffffff812f8af0>] dst_alloc+0x30/0x80
    [<ffffffff81311643>] ip_route_input+0x1f3/0x1200
    [<ffffffff81314299>] ip_rcv_finish+0x279/0x400
    [<ffffffff81314b0b>] ip_rcv+0x25b/0x330
    [<ffffffff812f3a99>] netif_receive_skb+0x339/0x430
    [<ffffffff812f3d68>] napi_skb_finish+0x58/0x70
    [<ffffffff812f4349>] napi_gro_receive+0x39/0x50
    [<ffffffffa00d77a2>] e1000_receive_skb+0x52/0x60 [e1000e]
    [<ffffffffa00d91b1>] e1000_clean_rx_irq+0x121/0x440 [e1000e]
    [<ffffffffa00d7f2e>] e1000_clean+0x7e/0x280 [e1000e]
    [<ffffffff812f45a0>] net_rx_action+0x170/0x270
    [<ffffffff81052d6c>] __do_softirq+0xbc/0x200
    [<ffffffff8100d2dc>] call_softirq+0x1c/0x50

unreferenced object 0xffff8800b2a6ce00 (size 328):
  comm "cupsd", pid 1460, jiffies 4295453973
  backtrace:
    [<ffffffff810ff6f2>] create_object+0x142/0x2d0
    [<ffffffff810ff9a6>] kmemleak_alloc+0x26/0x60
    [<ffffffff810fb083>] kmem_cache_alloc+0x133/0x1a0
    [<ffffffff812f8af0>] dst_alloc+0x30/0x80
    [<ffffffff81312b8e>] __ip_route_output_key+0x45e/0xb30
    [<ffffffff81313296>] ip_route_output_flow+0x36/0x2c0
    [<ffffffff8133b839>] udp_sendmsg+0x659/0x7c0
    [<ffffffff81342de9>] inet_sendmsg+0x29/0x60
    [<ffffffff812e1acb>] sock_sendmsg+0x10b/0x140
    [<ffffffff812e1e75>] sys_sendto+0xf5/0x130
    [<ffffffff8100c09b>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff




My system - Lenovo T61  x86_64 SMP kernel, C2D, 4GB

Zdenek
