Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbXHFIAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbXHFIAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 04:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbXHFIAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 04:00:06 -0400
Received: from sargon.lncsa.com ([212.99.8.251]:50399 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758988AbXHFIAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 04:00:04 -0400
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 04:00:04 EDT
Date: Mon, 6 Aug 2007 09:38:19 +0200
From: Laurent Caron <lcaron@lncsa.fr>
To: linux-kernel@vger.kernel.org
Subject: Oops on 2.6.21 + DRBD + XFS
Message-ID: <20070806093449.aebaisai@trusted.lncsa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using an XFS filesystem over DRBD for a few weeks on this machine
and did experience an oops.
--------------------------------------------------------------------
Aug  3 10:59:47 fileserv kernel: Oops: 0002 [#1] 
Aug  3 10:59:47 fileserv kernel: SMP  
Aug  3 10:59:47 fileserv kernel: CPU:    3 
Aug  3 10:59:47 fileserv kernel: EIP:    0060:[<c0164ed0>]    Not tainted VLI 
Aug  3 10:59:47 fileserv kernel: EFLAGS: 00010082   (2.6.21-dl380-g5-20070628 #1) 
Aug  3 10:59:47 fileserv kernel: EIP is at free_block+0x90/0x130 
Aug  3 10:59:47 fileserv kernel: eax: d1c3c000   ebx: 00000007   ecx: cb163080   edx: 7c57dcba 
Aug  3 10:59:47 fileserv kernel: esi: cb163000   edi: f79f9d40   ebp: f7a1f4b0   esp: f7d3fe3c 
Aug  3 10:59:47 fileserv kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068 
Aug  3 10:59:47 fileserv kernel: Process kswapd0 (pid: 240, ti=f7d3e000 task=f7c0a0b0 task.ti=f7d3e000) 
Aug  3 10:59:47 fileserv kernel: Stack: 00000009 00000000 0000001b f79ed440 00000007 f7a1f494 0000001b f79ed440  
Aug  3 10:59:47 fileserv kernel: f7a1e400 c0164be9 00000000 f7a1f480 f79f9d40 f7a1f480 00000246 f7724cc0  
Aug  3 10:59:47 fileserv kernel: 00000001 c0164d2a f7724cc0 fa66746c e3234080 c025fa16 00000001 e323409c  
Aug  3 10:59:47 fileserv kernel: Call Trace: 
Aug  3 10:59:47 fileserv kernel: [<c0164be9>] cache_flusharray+0x59/0xd0 
Aug  3 10:59:47 fileserv kernel: [<c0164d2a>] kmem_cache_free+0x5a/0x70 
Aug  3 10:59:47 fileserv kernel: [<c025fa16>] xfs_finish_reclaim+0x36/0x170 
Aug  3 10:59:47 fileserv kernel: [<c026fe41>] xfs_fs_clear_inode+0x91/0xc0 
Aug  3 10:59:47 fileserv kernel: [<c017c063>] clear_inode+0x93/0x140 
Aug  3 10:59:47 fileserv kernel: [<c017c38a>] dispose_list+0x1a/0xd0 
Aug  3 10:59:47 fileserv kernel: [<c017c5bd>] shrink_icache_memory+0x17d/0x250 
Aug  3 10:59:47 fileserv kernel: [<c01522bf>] shrink_slab+0x11f/0x180 
Aug  3 10:59:47 fileserv kernel: [<c0152737>] kswapd+0x357/0x450 
Aug  3 10:59:47 fileserv kernel: [<c0132260>] autoremove_wake_function+0x0/0x50 
Aug  3 10:59:47 fileserv kernel: [<c01523e0>] kswapd+0x0/0x450 
Aug  3 10:59:47 fileserv kernel: [<c01320ab>] kthread+0xbb/0xf0 
Aug  3 10:59:47 fileserv kernel: [<c0131ff0>] kthread+0x0/0xf0 
Aug  3 10:59:47 fileserv kernel: [<c0104cff>] kernel_thread_helper+0x7/0x18 
Aug  3 10:59:47 fileserv kernel: ======================= 
Aug  3 10:59:47 fileserv kernel: Code: 01 f2 8b 02 f6 c4 40 0f 85 a4 00 00 00 8b 02 84 c0 0f 89 a7 00 00 00 8b 72 1c 8b 44 24 28 8b 54 24 0c 8b 7c 82 54 8b 16 8b 46 04 <89> 42 04 89 10 8b 5e 0c c7 06 00 01 10 00 c7 46 04 00 02 20 00  
Aug  3 10:59:47 fileserv kernel: EIP: [<c0164ed0>] free_block+0x90/0x130 SS:ESP 0068:f7d3fe3c 
-----------------------------------------------

Thanks

Laurent

PS: Can you please cc me while replying.

