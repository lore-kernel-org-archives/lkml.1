Return-Path: <linux-kernel-owner+w=401wt.eu-S1764140AbXFKHzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764140AbXFKHzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbXFKHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:55:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbXFKHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:55:39 -0400
Date: Mon, 11 Jun 2007 00:55:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [BUG] fs/buffer.c:1821 in 2.6.22-rc4-mm2
Message-Id: <20070611005529.422d1678.akpm@linux-foundation.org>
In-Reply-To: <20070610155714.GA21592@alice>
References: <20070610155714.GA21592@alice>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007 17:57:14 +0200 Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:

> hi,
> 
> i got the following BUG while running the syscalls.sh
> from ltp-full-20070531 on an ext3 partition, it is easily reproducible
> for me
> 
> [  476.338068] ------------[ cut here ]------------
> [  476.338223] kernel BUG at fs/buffer.c:1821!
> [  476.338324] invalid opcode: 0000 [#1]
> [  476.338423] PREEMPT 
> [  476.338665] Modules linked in:
> [  476.338833] CPU:    0
> [  476.338836] EIP:    0060:[<c01a1914>]    Not tainted VLI
> [  476.338840] EFLAGS: 00010202   (2.6.22-rc4-mm2 #1)
> [  476.339206] EIP is at __block_prepare_write+0x64/0x410
> [  476.339311] eax: 00000001   ebx: c136fbb8   ecx: c07faf28   edx:
> 00000001
> [  476.339417] esi: c1dc9040   edi: c32d2dfc   ebp: c3733db8   esp:
> c3733d50
> [  476.339584] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> [  476.339690] Process vmsplice01 (pid: 7680, ti=c3733000 task=c351ed60
> task.ti=c3733000)
> [  476.339796] Stack: c3733d70 c0143e76 c1a0eab0 00000046 00000000
> c2509d64 00000cd8 c136fbb8 
> [  476.340675]        c32d2dfc 00000296 c02313b6 c1086088 00000050
> c02313b6 c1dc9040 c2509d50 
> [  476.341491]        c1dc9054 c3733dc4 c02313e9 c3733dbc c015728d
> c32d2f0c 00000000 c136fbb8 
> [  476.342371] Call Trace:
> [  476.342565]  [<c01a1d83>] block_write_begin+0x83/0xf0
> [  476.342804]  [<c0207778>] ext3_write_begin+0xc8/0x1c0
> [  476.342987]  [<c01595bf>] pagecache_write_begin+0x4f/0x150
> [  476.343243]  [<c019db3b>] pipe_to_file+0x9b/0x170
> [  476.343418]  [<c019d4b0>] __splice_from_pipe+0x70/0x260
> [  476.343654]  [<c019d6e8>] splice_from_pipe+0x48/0x70
> [  476.343828]  [<c019d9f8>] generic_file_splice_write+0x88/0x130
> [  476.344066]  [<c019d267>] do_splice_from+0xb7/0xc0
> [  476.344240]  [<c019ea51>] sys_splice+0x1a1/0x230
> [  476.344474]  [<c01043be>] sysenter_past_esp+0x5f/0x99
> [  476.344656]  [<ffffe410>] 0xffffe410
> [  476.344882]  =======================
> [  476.344984] INFO: lockdep is turned off.
> [  476.345084] Code: 00 0f 97 c2 e8 ee 2f 22 00 85 c0 74 04 0f 0b eb fe
> 31 d2 b8 28 af 7f c0 81 7d 08 00 10 00 00 0f 97 c2 e8 d0 2f 22 00 85 c0
> 74 04 <0f> 0b eb fe 8b 55 08 39 55 b0 0f 97 c0 0f b6 d0 b8 0c af 7f c0 
> [  476.350365] EIP: [<c01a1914>] __block_prepare_write+0x64/0x410 SS:ESP
> 0068:c3733d50

Yep, vmsplice01 is not supported on -mm kernels ;)

Nick has a protofix but I don't think it's been tested yet.

