Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZJTNik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZJTNik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZJTNik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:38:40 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:59992 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752058AbZJTNij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:38:39 -0400
X-Sender-Authentication: net64
Date: Tue, 20 Oct 2009 15:38:38 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: page allocation failure message kernel 2.6.31.4 (tty-related)
Message-Id: <20091020153838.665bc39c.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

is this something to worry about, I saw several of those:

Oct 20 11:25:41 box kernel: ssh: page allocation failure. order:1, mode:0x20
Oct 20 11:25:41 box kernel: Pid: 2970, comm: ssh Tainted: G   M       2.6.31.4 #1
Oct 20 11:25:41 box kernel: Call Trace:
Oct 20 11:25:41 box kernel:  [<c105545c>] ? __alloc_pages_nodemask+0x404/0x446
Oct 20 11:25:41 box kernel:  [<c106e1d1>] ? cache_alloc_refill+0x249/0x42d
Oct 20 11:25:41 box kernel:  [<c106e41c>] ? __kmalloc+0x67/0x9e
Oct 20 11:25:41 box kernel:  [<c1147c5a>] ? tty_buffer_request_room+0xa9/0x112
Oct 20 11:25:42 box kernel:  [<c1147deb>] ? tty_insert_flip_string+0x24/0x90
Oct 20 11:25:42 box kernel:  [<c114869e>] ? pty_write+0x25/0x3f
Oct 20 11:25:42 box kernel:  [<c1144b6f>] ? n_tty_write+0x23d/0x2d5
Oct 20 11:25:42 box kernel:  [<c1021cc7>] ? default_wake_function+0x0/0x8
Oct 20 11:25:42 box kernel:  [<c1142ab7>] ? tty_write+0x144/0x1b3
Oct 20 11:25:42 box kernel:  [<c1144932>] ? n_tty_write+0x0/0x2d5
Oct 20 11:25:42 box kernel:  [<c1142973>] ? tty_write+0x0/0x1b3
Oct 20 11:25:42 box kernel:  [<c107238b>] ? vfs_write+0x84/0x105
Oct 20 11:25:42 box kernel:  [<c10724a4>] ? sys_write+0x3c/0x63
Oct 20 11:25:42 box kernel:  [<c1002804>] ? sysenter_do_call+0x12/0x22
Oct 20 11:25:44 box kernel: DMA per-cpu:
Oct 20 11:25:44 box kernel: CPU    0: hi:    0, btch:   1 usd:   0
Oct 20 11:25:44 box kernel: CPU    1: hi:    0, btch:   1 usd:   0
Oct 20 11:25:44 box kernel: Normal per-cpu:
Oct 20 11:25:44 box kernel: CPU    0: hi:  186, btch:  31 usd: 193
Oct 20 11:25:44 box kernel: CPU    1: hi:  186, btch:  31 usd:  46
Oct 20 11:25:44 box kernel: HighMem per-cpu:
Oct 20 11:25:44 box kernel: CPU    0: hi:  186, btch:  31 usd: 157
Oct 20 11:25:44 box kernel: CPU    1: hi:  186, btch:  31 usd: 142
Oct 20 11:25:44 box kernel: Active_anon:89762 active_file:96664 inactive_anon:23257
Oct 20 11:25:44 box kernel:  inactive_file:119147 unevictable:0 dirty:53 writeback:0 unstable:0
Oct 20 11:25:45 box kernel:  free:569624 slab:38452 mapped:14421 pagetables:977 bounce:0
Oct 20 11:25:45 box kernel: DMA free:3488kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:8980kB inactive_file:3024kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaima
Oct 20 11:25:45 box kernel: lowmem_reserve[]: 0 865 3698 3698
Oct 20 11:25:45 box kernel: Normal free:5468kB min:3728kB low:4660kB high:5592kB active_anon:0kB inactive_anon:0kB active_file:324840kB inactive_file:330196kB unevictable:0kB present:885944kB pages_scanned:0
Oct 20 11:25:45 box kernel: lowmem_reserve[]: 0 0 22669 22669
Oct 20 11:25:45 box kernel: HighMem free:2269540kB min:512kB low:3564kB high:6616kB active_anon:359048kB inactive_anon:93028kB active_file:52836kB inactive_file:143368kB unevictable:0kB present:2901640kB page
Oct 20 11:25:45 box kernel: lowmem_reserve[]: 0 0 0 0
Oct 20 11:25:45 box kernel: DMA: 172*4kB 6*8kB 0*16kB 0*32kB 3*64kB 2*128kB 3*256kB 3*512kB 0*1024kB 0*2048kB 0*4096kB = 3488kB
Oct 20 11:25:45 box kernel: Normal: 1232*4kB 83*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5592kB
Oct 20 11:25:45 box kernel: HighMem: 45*4kB 80*8kB 69*16kB 29*32kB 29*64kB 22*128kB 14*256kB 9*512kB 3*1024kB 3*2048kB 548*4096kB = 2269540kB
Oct 20 11:25:45 box kernel: 216788 total pagecache pages
Oct 20 11:25:45 box kernel: 0 pages in swap cache
Oct 20 11:25:45 box kernel: Swap cache stats: add 0, delete 0, find 0/0
Oct 20 11:25:45 box kernel: Free swap  = 2104472kB
Oct 20 11:25:45 box kernel: Total swap = 2104472kB


-- 
Regards,
Stephan
