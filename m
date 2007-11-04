Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXKDWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXKDWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 17:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXKDWQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 17:16:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:34622 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbXKDWQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 17:16:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SrwVHUxs+2kCy3O2nM0THUOAVZha8/r1qfZ/bOkqwLk9Q0ah3maU8vacbW9y6aeAFvGFl13M5Ol6hn6/iPUsWy728HworKBZuInP9WFib4IcdjdMFwGEUY7NdTPcp08ta+5cUrIuVtrZR63DzIpnAYOr7B4Gxthwv93n73Lt94w=
Message-ID: <472E44CA.6090600@gmail.com>
Date: Sun, 04 Nov 2007 23:16:42 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Felipe Dias <felipediassss@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: textsearch in module = BUG: scheduling while atomic
References: <3c16e8dc0711040915n206c38d6u7e15972bf55e0e0d@mail.gmail.com>	 <472E07ED.2010907@gmail.com>	 <3c16e8dc0711041222w6bc67b3fn8320e982ffd723b0@mail.gmail.com>	 <472E346E.90309@gmail.com> <3c16e8dc0711041405m33c5e54dw6c8d51ac600d51cf@mail.gmail.com>
In-Reply-To: <3c16e8dc0711041405m33c5e54dw6c8d51ac600d51cf@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2007 11:05 PM, Felipe Dias wrote:
> Ow sorry... the warning:
> 
> BUG: scheduling while atomic: gnome-cups-icon/0x00000101/3827
>  [<c02aefe6>] __sched_text_start+0x56/0x7c8
>  [<c0130139>] autoremove_wake_function+0x14/0x33
>  [<c0119284>] __wake_up_common+0x35/0x53
>  [<c01197f6>] __wake_up+0x32/0x43
>  [<c02af847>] wait_for_completion+0x6a/0x9f
>  [<c011b6ae>] default_wake_function+0x0/0xc
>  [<c012cdff>] call_usermodehelper_keys+0xad/0xc5
>  [<c012ceec>] request_module+0xd5/0xe6

Seems like it is not inteded for using in atomic at all (you probably passed an
unknown algo here to the prepare function). You seem to have to use a workqueue
if it is possible or prepare the serach before the interrupt occurs. Post your
code if you want more appropriate answer.

>  [<c01b2762>] __next_cpu+0x12/0x21
>  [<c0119e54>] find_busiest_group+0x1d6/0x55a
>  [<c01ba672>] textsearch_prepare+0x8c/0x11a
>  [<c017c11d>] __find_get_block_slow+0x127/0x131
>  [<f9198451>] hook_test+0x4c/0xb6 [test_mod]
>  [<c017c3f0>] __find_get_block+0x13f/0x149
>  [<c026ef84>] nf_iterate+0x38/0x6a
>  [<c0273f1c>] ip_rcv_finish+0x0/0x294
>  [<c026f0c1>] nf_hook_slow+0x4d/0xb5
>  [<c0273f1c>] ip_rcv_finish+0x0/0x294
>  [<c027462f>] ip_rcv+0x20b/0x4bd
>  [<c0273f1c>] ip_rcv_finish+0x0/0x294
>  [<f8ccd2ad>] search_by_key+0x17f/0xe87 [reiserfs]
>  [<c0127b32>] del_timer_sync+0xa/0x14
>  [<c02afdfb>] schedule_timeout+0x79/0x8d
>  [<c025aee2>] netif_receive_skb+0x2ef/0x309
>  [<c026e201>] __nla_put+0xe/0x25
>  [<c025ca16>] process_backlog+0x7c/0xe9
>  [<c025cbe6>] net_rx_action+0x95/0x186
>  [<c012469f>] __do_softirq+0x6c/0xcf
>  [<c0124734>] do_softirq+0x32/0x36
>  [<c0124900>] local_bh_enable+0x7b/0x89
>  [<c025ced9>] dev_queue_xmit+0x202/0x221
>  [<c0279686>] ip_output+0x269/0x2a3
>  [<c0278d95>] ip_queue_xmit+0x358/0x39a
>  [<c014b589>] __alloc_pages+0x64/0x2a8
>  [<c015e2ee>] cache_alloc_refill+0x74/0x45f
>  [<c028ba0f>] tcp_v4_send_check+0x86/0xbc
>  [<c0286f8f>] tcp_transmit_skb+0x618/0x652
>  [<c0256fe4>] __alloc_skb+0x47/0x104
>  [<c0289319>] tcp_connect+0x2a3/0x31d
>  [<c028c0cd>] tcp_v4_connect+0x493/0x5a4
>  [<c0171eb3>] touch_atime+0x8b/0xac
>  [<c0296f23>] inet_stream_connect+0x87/0x20d
>  [<c01b6856>] copy_from_user+0x23/0x4f
>  [<c02518b5>] sys_connect+0x82/0xad
>  [<c02b0c6c>] _spin_lock_bh+0x8/0x18
>  [<c02b0c6c>] _spin_lock_bh+0x8/0x18
>  [<c02538c3>] release_sock+0x12/0x8c
>  [<c027d938>] tcp_setsockopt+0x309/0x321
>  [<c016fb25>] d_alloc+0x14b/0x17e
>  [<c016f9d6>] d_instantiate+0x66/0x6a
>  [<c02532a4>] sock_common_setsockopt+0x1d/0x22
>  [<c0251814>] sys_setsockopt+0x88/0xa7
>  [<c0252e33>] sys_socketcall+0x8f/0x242
>  [<c0103d16>] sysenter_past_esp+0x5f/0x85
>  =======================

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
