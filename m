Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbXKDR5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbXKDR5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 12:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXKDR5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 12:57:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:59549 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXKDR5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 12:57:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=qVDA0HsGatULBHidI30ky3XBNgRI8iJlGEUnMiFzK0UtaBeAetPGsPqqFcAaKTg5cAwBhFfpYrFOeB0B6hRw3gS+iI/hXpYuHhVxUlMgpS50z8spXfCmBQwNe7KyXszRKGsPFt5sj9a40e+l1Kk7fY0+qCSObZ0xKaS+JFnFOho=
Message-ID: <472E07ED.2010907@gmail.com>
Date: Sun, 04 Nov 2007 18:57:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Felipe Dias <felipediassss@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: textsearch in module = BUG: scheduling while atomic
References: <3c16e8dc0711040915n206c38d6u7e15972bf55e0e0d@mail.gmail.com>
In-Reply-To: <3c16e8dc0711040915n206c38d6u7e15972bf55e0e0d@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2007 06:15 PM, Felipe Dias wrote:
> hi, i have a short module in kernel 2.6.22 with uses textsearch to
> search strings in network packages, and i have this erros in dmesg:
> 
> --------------
> BUG: scheduling while atomic: apache2/0x10000101/3710
>  [<c02aefe6>] __sched_text_start+0x56/0x7c8
>  [<c0119284>] __wake_up_common+0x35/0x53
>  [<c01197f6>] __wake_up+0x32/0x43
>  [<c028ba0f>] tcp_v4_send_check+0x86/0xbc
>  [<c011bc98>] __cond_resched+0x18/0x29
>  [<c02af7be>] cond_resched+0x26/0x31
>  [<c015e711>] __kmalloc+0x38/0x6e
>  [<f8f6e0fa>] bm_init+0x28/0x1c9 [ts_bm]
>  [<c0256fe4>] __alloc_skb+0x47/0x104
>  [<c01ba6da>] textsearch_prepare+0xf4/0x11a
>  [<f91af451>] hook_test+0x4c/0xb6 [test_mod]
>  [<c028d416>] tcp_v4_rcv+0x84c/0x8aa
>  [<c026ef84>] nf_iterate+0x38/0x6a
>  [<c0273f1c>] ip_rcv_finish+0x0/0x294
>  [<c026f0c1>] nf_hook_slow+0x4d/0xb5
>  [<c0273f1c>] ip_rcv_finish+0x0/0x294
>  [<c027462f>] ip_rcv+0x20b/0x4bd
>  [<c0273f1c>] ip_rcv_finish+0x0/0x294
>  [<c025aee2>] netif_receive_skb+0x2ef/0x309
>  [<c025ca16>] process_backlog+0x7c/0xe9
>  [<c025cbe6>] net_rx_action+0x95/0x186
>  [<c012469f>] __do_softirq+0x6c/0xcf
>  [<c0124734>] do_softirq+0x32/0x36
>  [<c0124900>] local_bh_enable+0x7b/0x89
>  [<c025ced9>] dev_queue_xmit+0x202/0x221
>  [<c0279686>] ip_output+0x269/0x2a3
>  [<c0278d95>] ip_queue_xmit+0x358/0x39a
>  [<f8cd15a9>] journal_end+0xba/0xc2 [reiserfs]
>  [<f8cc2c16>] reiserfs_dirty_inode+0x78/0x7e [reiserfs]
>  [<c0286f8f>] tcp_transmit_skb+0x618/0x652
>  [<c0288906>] __tcp_push_pending_frames+0x71c/0x7cc
>  [<f8cbe957>] reiserfs_file_write+0x1841/0x1871 [reiserfs]
>  [<c0256fe4>] __alloc_skb+0x47/0x104
>  [<c027ec8b>] tcp_sendmsg+0x91b/0x9f0
>  [<c0258623>] skb_copy_datagram_iovec+0x53/0x1d0
>  [<c027fcbb>] tcp_recvmsg+0x8e5/0x9f0
>  [<c0251227>] sock_aio_write+0xf3/0xfb
>  [<c0160e8a>] do_sync_readv_writev+0xc0/0x103
>  [<c0130125>] autoremove_wake_function+0x0/0x33
>  [<c0252bc2>] sys_getsockname+0x9f/0xb0
>  [<c01b6856>] copy_from_user+0x23/0x4f
>  [<c0160d40>] rw_copy_check_uvector+0x50/0xaa
>  [<c0161566>] do_readv_writev+0xbc/0x187
>  [<c0251134>] sock_aio_write+0x0/0xfb
>  [<c0118731>] do_page_fault+0x273/0x516
>  [<c016166e>] vfs_writev+0x3d/0x48
>  [<c0161a6a>] sys_writev+0x41/0x67
>  [<c0103d16>] sysenter_past_esp+0x5f/0x85
>  =======================
> 
> My module part with find the string with textsearch:
> -------------------------------
>         int pos, err;
>         struct ts_config *conf;
>         struct ts_state state;
> 
>         list_for_each_entry_safe(entry, next, &head, list) {
> 
>                 conf = textsearch_prepare("bm", entry->content,
> strlen(entry->content), GFP_KERNEL, TS_AUTOLOAD);

I guess you want GFP_ATOMIC while calling it from (soft)irq.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
