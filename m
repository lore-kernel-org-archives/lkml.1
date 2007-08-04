Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbXHDRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbXHDRH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932623AbXHDRHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:07:09 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:27246 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbXHDRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:07:06 -0400
Date: Sat, 04 Aug 2007 11:07:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: many problems with mac80211,
 iwlwifi and ACPI on Santa Rosa laptop
In-reply-to: <fa.v/A5H4Pm9oA6Hct919AmEbMQfJ0@ifi.uio.no>
To: =?UTF-8?B?TWljaGHFgiBLdWTFgmE=?= <michal.kudla@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46B4B234.9040000@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.v/A5H4Pm9oA6Hct919AmEbMQfJ0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michał Kudła wrote:
> [1.] One line summary of the problem:
> many crashes on my new laptop - Santa Rosa
> 
> [2.] Full description of the problem/report:
> from /var/log/messages
> 
> cat /var/log/messages 
>  Aug  4 13:34:28 laptok wlan0: setting MTU 576 
>  Aug  4 13:34:30 laptok r8169: eth0: link down 
>  Aug  4 13:34:30 laptok dhcpcd[6258]: eth0: dhcpcd 3.0.16 starting 
>  Aug  4 13:34:30 laptok dhcpcd[6258]: eth0: hardware address = 
> 00:1b:fc:41:a1:d8 
>  Aug  4 13:34:30 laptok dhcpcd[6258]: eth0: broadcasting for a lease 
>  Aug  4 13:34:49 laptok ------------[ cut here ]------------ 
>  Aug  4 13:34:49 laptok kernel BUG at mm/slab.c:592! 
>  Aug  4 13:34:49 laptok invalid opcode: 0000 [#1] 
>  Aug  4 13:34:49 laptok SMP 
>  Aug  4 13:34:49 laptok Modules linked in: nvidia(P) iwl4965 
>  Aug  4 13:34:49 laptok CPU:    1 
>  Aug  4 13:34:49 laptok EIP:    0060:[<c015edfb>]    Tainted: P       VLI 

Can you reproduce this without the binary NVIDIA module loaded?

>  Aug  4 13:34:49 laptok EFLAGS: 00010046   (2.6.22-gentoo-r2 #5) 
>  Aug  4 13:34:49 laptok EIP is at kfree+0x7b/0x90 
>  Aug  4 13:34:49 laptok eax: 40000000   ebx: 00000000   ecx: 00000000   edx: 
> c16e0380 
>  Aug  4 13:34:49 laptok esi: f701c000   edi: 00000286   ebp: f6cc7d8c   esp: 
> f6cc7d80 
>  Aug  4 13:34:49 laptok ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068 
>  Aug  4 13:34:49 laptok Process iwl4965 (pid: 3303, ti=f6cc6000 task=f6d8fa50 
> task.ti=f6cc6000) 
>  Aug  4 13:34:49 laptok Stack: 00000000 f78a8840 f7fb0e74 f6cc7d9c c03b439c 
> f78a8840 f78a8840 f6cc7da8 
>  Aug  4 13:34:49 laptok c03b415b 00000000 f6cc7dc8 c03b4230 00000000 00000000 
> 00000000 00000000 
>  Aug  4 13:34:49 laptok f7fb0d00 f78a8840 f6cc7dd0 c03b42ce f6cc7f7c c04455a9 
> f78a8864 00000001 
>  Aug  4 13:34:49 laptok Call Trace: 
>  Aug  4 13:34:49 laptok [<c01039fa>] show_trace_log_lvl+0x1a/0x30 
>  Aug  4 13:34:49 laptok [<c0103ab9>] show_stack_log_lvl+0xa9/0xd0 
>  Aug  4 13:34:49 laptok [<c0103cc9>] show_registers+0x1e9/0x2f0 
>  Aug  4 13:34:49 laptok [<c0103edf>] die+0x10f/0x240 
>  Aug  4 13:34:49 laptok [<c01040a1>] do_trap+0x91/0xc0 
>  Aug  4 13:34:49 laptok [<c0104459>] do_invalid_op+0x89/0xa0 
>  Aug  4 13:34:49 laptok [<c045b5aa>] error_code+0x72/0x78 
>  Aug  4 13:34:49 laptok [<c03b439c>] skb_release_data+0x5c/0x90 
>  Aug  4 13:34:49 laptok [<c03b415b>] kfree_skbmem+0xb/0x90 
>  Aug  4 13:34:49 laptok [<c03b4230>] __kfree_skb+0x50/0xd0 
>  Aug  4 13:34:49 laptok [<c03b42ce>] kfree_skb+0x1e/0x40 
>  Aug  4 13:34:49 laptok [<c04455a9>] ieee80211_sta_work+0xd9/0x1a30 
>  Aug  4 13:34:49 laptok [<c012c178>] run_workqueue+0x78/0x100 
>  Aug  4 13:34:49 laptok [<c012cb6d>] worker_thread+0x9d/0x100 
>  Aug  4 13:34:49 laptok [<c012f732>] kthread+0x42/0x70 
>  Aug  4 13:34:49 laptok [<c0103623>] kernel_thread_helper+0x7/0x14 
>  Aug  4 13:34:49 laptok ======================= 
>  
> And uncatched Exceptions - please look at photos
> http://picasaweb.google.pl/Michal.Kudla/Gentoo

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

