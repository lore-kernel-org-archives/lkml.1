Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbXICVjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbXICVjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 17:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXICVjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 17:39:15 -0400
Received: from igraine.blacknight.ie ([81.17.252.25]:57949 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXICVjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 17:39:14 -0400
X-Greylist: delayed 2056 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 17:39:13 EDT
Date: Mon, 3 Sep 2007 22:04:56 +0100
From: Robert Fitzsimons <robfitz@273k.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: FD Cami <francois.cami@free.fr>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       charles gagalac <charles.gagalac@gmail.com>,
       daryll q <daryll_26m@yahoo.com.ph>, linux-kernel@vger.kernel.org
Subject: Re: Hang in 2.6.23-rc5
Message-ID: <20070903210440.GA2640@localhost>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com> <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com> <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com> <20070902232939.f2c8acbb.francois.cami@free.fr> <20070902214631.GA1892@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902214631.GA1892@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=1.088, required 7,
	autolearn=disabled, RCVD_IN_NERDS_IE -3.50, RCVD_IN_SORBS_DUL 1.99,
	SARE_BAYES_5x8 0.80, SARE_BAYES_6x8 0.80, SARE_BAYES_7x8 1.00)
X-blacknight-igraine-MailScanner-SpamScore: s
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a relevant oops for this hang.

[ 7329.832382] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000025
[ 7329.934755]  printing eip:
[ 7329.967145] 802cb921
[ 7329.993347] *pde = 00000000
[ 7330.026799] Oops: 0000 [#1]
[ 7330.060246] Modules linked in: usblp ipt_MASQUERADE iptable_nat nf_nat ipt_LOG xt_limit xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables pppoe pppox ppp_generic slhc dvb_pll cx22702 usbhid tuner hid cx88_dvb video_buf_dvb dvb_core cx8800 cx8802 cx88_alsa cx88xx ir_common i2c_algo_bit tveeprom i2c_core videodev compat_ioctl32 v4l2_common v4l1_compat video_buf ehci_hcd uhci_hcd btcx_risc usbcore
[ 7330.518076] CPU:    0
[ 7330.518077] EIP:    0060:[<802cb921>]    Not tainted VLI
[ 7330.518079] EFLAGS: 00210246   (2.6.23-rc5-dirty #72)
[ 7330.669129] EIP is at tcp_rto_min+0xb/0x16
[ 7330.718088] eax: 00000032   ebx: d76b5ab0   ecx: 0000209d   edx: 00000000
[ 7330.799277] esi: d76b5ab0   edi: 00000000   ebp: 803ecdd8   esp: 803ecdd8
[ 7330.880468] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
[ 7330.950225] Process firefox-bin (pid: 2625, ti=803ec000 task=d1bfcaa0 task.ti=d1bfd000)
[ 7331.043890] Stack: 803ecde8 802cb9e8 d76b5ab0 d76b5ab0 803ecdf4 802cc1e2 803bc3e0 803ece6c
[ 7331.144727]        802cd85f 03ccf75e 208b3367 291abfc5 6eaa5ef6 d6c52818 00000000 00000000
[ 7331.245564]        00000001 03ccf6f4 eddd6e3e 03ccf75e 00000001 00000001 803eceac 03ccf75e
[ 7331.346403] Call Trace:
[ 7331.377800]  [<80102abd>] show_trace_log_lvl+0x1a/0x2f
[ 7331.439343]  [<80102b6d>] show_stack_log_lvl+0x9b/0xa3
[ 7331.500885]  [<80102d1f>] show_registers+0x1aa/0x278
[ 7331.560349]  [<80102ed5>] die+0xe8/0x205
[ 7331.607336]  [<802f0bea>] do_page_fault+0x469/0x53a
[ 7331.665761]  [<802ef73a>] error_code+0x6a/0x70
[ 7331.718987]  [<802cb9e8>] tcp_rtt_estimator+0xbc/0x102
[ 7331.780529]  [<802cc1e2>] tcp_ack_saw_tstamp+0x17/0x47
[ 7331.842071]  [<802cd85f>] tcp_ack+0x6a5/0x1731
[ 7331.895298]  [<802d11be>] tcp_rcv_established+0x353/0x5f5
[ 7331.959959]  [<802d6358>] tcp_v4_do_rcv+0x2f/0x2fa
[ 7332.017344]  [<802d8413>] tcp_v4_rcv+0x6d1/0x71a
[ 7332.072650]  [<802c0919>] ip_local_deliver+0x12d/0x17c
[ 7332.134193]  [<802c07c0>] ip_rcv+0x40b/0x437
[ 7332.185339]  [<802ac6b0>] netif_receive_skb+0x161/0x1ac
[ 7332.247921]  [<802ae63a>] process_backlog+0x71/0xda
[ 7332.306345]  [<802ae6f9>] net_rx_action+0x56/0xd5
[ 7332.362690]  [<80114514>] __do_softirq+0x38/0x7a
[ 7332.417995]  [<801039cd>] do_softirq+0x41/0x91
[ 7332.471223]  =======================
[ 7332.513947] Code: e4 8b 82 54 03 00 00 89 82 f8 04 00 00 a1 30 e7 39 80 89 82 fc 04 00 00 83 c4 10 5b 5e 5f c9 c3 55 8b 50 64 b8 32 00 00 00 89 e5 <f6> 42 25 20 74 03 8b 42 54 c9 c3 55 85 d2 b9 01 00 00 00 0f 45
[ 7332.746397] EIP: [<802cb921>] tcp_rto_min+0xb/0x16 SS:ESP 0068:803ecdd8
[ 7332.825845] Kernel panic - not syncing: Fatal exception in interrupt

> Try this from net-2.6 tree:
> 
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -560,7 +560,7 @@ static u32 tcp_rto_min(struct sock *sk)
>  	struct dst_entry *dst = __sk_dst_get(sk);
>  	u32 rto_min = TCP_RTO_MIN;
>  
> -	if (dst_metric_locked(dst, RTAX_RTO_MIN))
> +	if (dst && dst_metric_locked(dst, RTAX_RTO_MIN))
>  		rto_min = dst->metrics[RTAX_RTO_MIN-1];
>  	return rto_min;
>  }

Looks like this is the fix.  I'm recompiling with it now.

Robert

