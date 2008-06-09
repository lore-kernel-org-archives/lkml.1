Return-Path: <linux-kernel-owner+w=401wt.eu-S1762648AbYFIWgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762648AbYFIWgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761057AbYFIWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:34:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:23179 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761374AbYFIWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UZVGeU331bM9A+0JLl9dH7zYuCZ22h+uGtOA14To4v/Y70HWY9iYoU2TDPWGCpKU26
         MxyP1tKrKgV+VWqd6l3r6SYljXNlIPIPD4zoysZ3/r3Hp1dM8oJUi59m15p9j9boTEGN
         +DKW5RwUJXRs/126Df2sHxFMqMVWCdv4wIx4g=
Message-ID: <484DAF9D.5080702@gmail.com>
Date: Tue, 10 Jun 2008 00:33:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev <netdev@vger.kernel.org>
Subject: sock lockup -> process in D state [Was: 2.6.26-rc5-mm1]
References: <20080609053908.8021a635.akpm@linux-foundation.org>
In-Reply-To: <20080609053908.8021a635.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2008 02:39 PM, Andrew Morton wrote:
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm1/

I don't know how to reproduce it so far, but posting anyway:

httpd2-prefor D 00000000ffffffff     0  3697   2811
  ffff810055bd7198 0000000000000046 ffff810055bd7160 ffff810055bd715c
  ffffffff80728000 ffff810063896700 ffff81007d093380 ffff810063896980
  00000001781e1700 00000001005585a6 ffff810063896980 0000000000000600
Call Trace:
  [<ffffffff8049d6fd>] lock_sock_nested+0x8d/0xd0
  [<ffffffff8024e010>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff8049a00c>] sock_fasync+0x4c/0x180
  [<ffffffff8049b4ad>] sock_close+0x1d/0x40
  [<ffffffff802a6314>] __fput+0xc4/0x1a0
  [<ffffffff802a640d>] fput+0x1d/0x30
  [<ffffffff802a2b9b>] filp_close+0x5b/0x90
  [<ffffffff802399e9>] put_files_struct+0x79/0xe0
  [<ffffffff80239a9e>] exit_files+0x4e/0x60
  [<ffffffff8023bc44>] do_exit+0x6e4/0x7f0
  [<ffffffff8022cade>] ? __wake_up+0x4e/0x70
  [<ffffffff8054bd18>] oops_end+0x88/0x90
  [<ffffffff8020e0be>] die+0x5e/0x90
  [<ffffffff8054c386>] do_trap+0x146/0x170
  [<ffffffff8054e3e5>] ? atomic_notifier_call_chain+0x15/0x20
  [<ffffffff8020e7b2>] do_invalid_op+0x92/0xb0
  [<ffffffff80277ec7>] ? unlock_page+0x17/0x40
  [<ffffffff8029ee95>] ? check_object+0x265/0x270
  [<ffffffff8029e6c0>] ? init_object+0x50/0x90
  [<ffffffff8054b739>] error_exit+0x0/0x51
  [<ffffffff80277ec7>] ? unlock_page+0x17/0x40
  [<ffffffff80277edd>] ? unlock_page+0x2d/0x40
  [<ffffffff8028386d>] ? shrink_page_list+0x2fd/0x720
  [<ffffffff80282ad3>] ? isolate_pages_global+0x1c3/0x270
  [<ffffffff80283ed0>] ? shrink_list+0x240/0x5e0
  [<ffffffff8029e6c0>] ? init_object+0x50/0x90
  [<ffffffff802844c3>] ? shrink_zone+0x253/0x330
  [<ffffffff80280060>] ? background_writeout+0x0/0xe0
  [<ffffffff80285441>] ? try_to_free_pages+0x251/0x3e0
  [<ffffffff80282910>] ? isolate_pages_global+0x0/0x270
  [<ffffffff8027e8ff>] ? __alloc_pages_internal+0x20f/0x4e0
  [<ffffffff802a0e04>] ? __slab_alloc+0x6d4/0x6f0
  [<ffffffff804d1521>] ? sk_stream_alloc_skb+0x41/0x110
  [<ffffffff804d1521>] ? sk_stream_alloc_skb+0x41/0x110
  [<ffffffff802a2033>] ? __kmalloc_track_caller+0xc3/0xf0
  [<ffffffff804a2b4e>] ? __alloc_skb+0x6e/0x150
  [<ffffffff804d1521>] ? sk_stream_alloc_skb+0x41/0x110
  [<ffffffff804d1960>] ? tcp_sendmsg+0x370/0xc30
  [<ffffffff80499b07>] ? sock_aio_write+0x137/0x150
  [<ffffffff802bb711>] ? touch_atime+0x31/0x140
  [<ffffffff804999d0>] ? sock_aio_write+0x0/0x150
  [<ffffffff802a4bcb>] ? do_sync_readv_writev+0xeb/0x130
  [<ffffffff802aceb1>] ? pipe_read+0x4b1/0x4c0
  [<ffffffff8024e010>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff802a4e41>] ? do_sync_read+0xf1/0x140
  [<ffffffff802a49de>] ? rw_copy_check_uvector+0x7e/0x130
  [<ffffffff802a538f>] ? do_readv_writev+0xcf/0x1e0
  [<ffffffff802d985b>] ? sys_epoll_wait+0xcb/0x560
  [<ffffffff802a54e0>] ? vfs_writev+0x40/0x60
  [<ffffffff802a5550>] ? sys_writev+0x50/0xb0
  [<ffffffff8020c42b>] ? system_call_after_swapgs+0x7b/0x80
