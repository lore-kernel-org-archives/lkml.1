Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZA0QKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZA0QKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZA0QKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:10:12 -0500
Received: from mail.lncsa.com ([212.99.8.243]:33707 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752550AbZA0QKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:10:10 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 11:10:09 EST
Date: Tue, 27 Jan 2009 16:59:34 +0100
From: Laurent Caron <lcaron@lncsa.com>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at net/core/skbuff.c:154 sock_rfree+0x22/0x51()
Message-ID: <20090127095317.ahphaesi@trusted.lncsa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm hitting a bug while using OpenSwan + PPPoE + tg3 card.

After a couple of days my syslog gets filled with that kind of messages:

Jan 27 08:04:21 gw kernel: ------------[ cut here ]------------
Jan 27 08:04:21 gw kernel: WARNING: at net/core/skbuff.c:154 sock_rfree+0x22/0x51()
Jan 27 08:04:21 gw kernel: SKB BUG: Invalid truesize (352) len=136, sizeof(sk_buff)=224
Jan 27 08:04:21 gw kernel: Modules linked in: xt_TCPMSS nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 rmd160 pwc iTCO_wdt iTCO_vendor_support i82975x_edac sundance rng_core snd_hda_intel edac_core tg3
Jan 27 08:04:21 gw kernel: Pid: 22920, comm: iptraf Tainted: G        W  2.6.28.1-20090121 #1
Jan 27 08:04:21 gw kernel: Call Trace:
Jan 27 08:04:21 gw kernel: [<ffffffff8024b3ed>] warn_slowpath+0xb4/0xd2
Jan 27 08:04:21 gw kernel: [<ffffffff802a055d>] do_select+0x497/0x4e8
Jan 27 08:04:21 gw kernel: [<ffffffff802a08ce>] __pollwait+0x0/0xe1
Jan 27 08:04:21 gw kernel: [<ffffffff80245108>] default_wake_function+0x0/0xe
Jan 27 08:04:21 gw kernel: [<ffffffff8067620a>] __skb_recv_datagram+0x1fe/0x225
Jan 27 08:04:21 gw kernel: [<ffffffff804a5fc5>] __ratelimit+0xb5/0xc0
Jan 27 08:04:21 gw kernel: [<ffffffff80670ca7>] sock_rfree+0x22/0x51
Jan 27 08:04:21 gw kernel: [<ffffffff80673b44>] skb_release_head_state+0x60/0xbb
Jan 27 08:04:21 gw kernel: [<ffffffff80674268>] skb_release_all+0x9/0x12
Jan 27 08:04:21 gw kernel: [<ffffffff80673a29>] __kfree_skb+0x9/0x6f
Jan 27 08:04:21 gw kernel: [<ffffffff8067632e>] skb_free_datagram+0xc/0x32
Jan 27 08:04:21 gw kernel: [<ffffffff8070b902>] packet_recvmsg+0x17f/0x192
Jan 27 08:04:21 gw kernel: [<ffffffff8066e343>] sock_recvmsg+0xd5/0xed
Jan 27 08:04:21 gw kernel: [<ffffffff80519716>] n_tty_receive_buf+0xd0a/0xd46
Jan 27 08:04:21 gw kernel: [<ffffffff8025cad4>] autoremove_wake_function+0x0/0x2e
Jan 27 08:04:21 gw kernel: [<ffffffff802a07a4>] core_sys_select+0x1f6/0x262
Jan 27 08:04:21 gw kernel: [<ffffffff8025cc43>] remove_wait_queue+0x12/0x45
Jan 27 08:04:21 gw kernel: [<ffffffff8066dcf1>] sockfd_lookup_light+0x1a/0x52
Jan 27 08:04:21 gw kernel: [<ffffffff8066f198>] sys_recvfrom+0xbc/0x126
Jan 27 08:04:21 gw kernel: [<ffffffff802619fa>] getnstimeofday+0x53/0xb3
Jan 27 08:04:21 gw kernel: [<ffffffff8025f4cd>] ktime_get_ts+0x22/0x4b
Jan 27 08:04:21 gw kernel: [<ffffffff8029fa3a>] poll_select_copy_remaining+0xd8/0xfd
Jan 27 08:04:21 gw kernel: [<ffffffff802a08b9>] sys_select+0xa9/0xbe
Jan 27 08:04:21 gw kernel: [<ffffffff8022336b>] system_call_fastpath+0x16/0x1b
Jan 27 08:04:21 gw kernel: ---[ end trace 13e3590b92f0dfd0 ]---
Jan 27 08:04:21 gw kernel: ------------[ cut here ]------------

When those messages are shown the network connection becomes
unresponsive (high latency).


This bug occurs on kernels > 2.6.24.

I have had 2 options so far:
- Rebooting
- Booting under 2.6.24

This problem is quite easily triggered when using tcpdump or iptraf.

Is this some kind of known bug ?

Thanks

Laurent

PS: I did upgrade to 2.6.28.2 in the meantime just to check how it
behaves.

