Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXFGP1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXFGP1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXFGP0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:26:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594AbXFGP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:26:51 -0400
Date: Thu, 7 Jun 2007 08:26:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.22-rc4-mm2
Message-Id: <20070607082643.545eca6e.akpm@linux-foundation.org>
In-Reply-To: <4667E70F.7010902@googlemail.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<4667E70F.7010902@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 13:07:59 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Andrew Morton pisze:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> > 
> 
> LTP triggered this
> 
> [ 4691.872882] ------------[ cut here ]------------
> [ 4691.877619] kernel BUG at fs/buffer.c:1821!
> [ 4691.881857] invalid opcode: 0000 [#1]
> [ 4691.885596] PREEMPT SMP 
> [ 4691.888205] Modules linked in: isofs nls_base zlib_inflate autofs4 sunrpc af_packet nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_REJECT ip6table_filter ip6_tables x_tables firmware_class binfmt_misc thermal processor fan container ipv6 nvram loop snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer i2c_i801 snd soundcore intel_agp snd_page_alloc agpgart evdev rtc
> [ 4691.937384] CPU:    1
> [ 4691.937385] EIP:    0060:[<c04a510f>]    Not tainted VLI
> [ 4691.937387] EFLAGS: 00010202   (2.6.22-rc4-mm2 #1)
> [ 4691.949984] EIP is at __block_prepare_write+0x64/0x3a5
> [ 4691.955164] eax: 00000001   ebx: c624fc50   ecx: c07e0910   edx: 00000001
> [ 4691.962041] esi: 00000418   edi: 00000000   ebp: cc454dc0   esp: cc454d60
> [ 4691.968946] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [ 4691.974850] Process vmsplice01 (pid: 8420, ti=cc454000 task=cafe6800 task.ti=cc454000)
> [ 4691.982699] Stack: cc454d80 c0443c61 00000001 00000001 c7f71080 00000418 c624fc50 c98ec464 
> [ 4691.991372]        00000000 00000286 c04d6706 c523d7c8 00000050 c04d6706 c7f71080 c828d7f0 
> [ 4691.999998]        c7f71094 cc454dd4 c04d673f c065cfbc c624fc50 c624fc50 00000418 00000000 
> [ 4692.008729] Call Trace:
> [ 4692.011397]  [<c04a5513>] block_write_begin+0x90/0xf4
> [ 4692.016556]  [<c04c9779>] ext3_write_begin+0xda/0x19b
> [ 4692.021750]  [<c0464b5a>] pagecache_write_begin+0x4d/0x12f
> [ 4692.027349]  [<c04a1a35>] pipe_to_file+0xa0/0x15f
> [ 4692.032148]  [<c04a14af>] __splice_from_pipe+0x63/0x1d2
> [ 4692.037459]  [<c04a1660>] splice_from_pipe+0x42/0x58
> [ 4692.042544]  [<c04a1916>] generic_file_splice_write+0x8b/0x10a
> [ 4692.048477]  [<c04a1409>] do_splice_from+0xca/0xd6
> [ 4692.053391]  [<c04a2754>] sys_splice+0x108/0x22b
> [ 4692.058119]  [<c040420c>] syscall_call+0x7/0xb
> [ 4692.062691]  [<b7f53410>] 0xb7f53410
> [ 4692.066398]  =======================
> [ 4692.070031] INFO: lockdep is turned off.
> [ 4692.074038] Code: 2c 09 7e c0 e8 2f 6e 07 00 85 c0 74 04 0f 0b eb fe 31 d2 81 7d 08 00 10 00 00 0f 97 c2 b8 10 09 7e c0 e8 11 6e 07 00 85 c0 74 04 <0f> 0b eb fe 8b 55 08 39 55 b4 0f 97 c2 0f b6 d2 b8 f4 08 7e c0 
> [ 4692.094556] EIP: [<c04a510f>] __block_prepare_write+0x64/0x3a5 SS:ESP 0068:cc454d60
> 
> (gdb) l *__block_prepare_write+0x64
> 0xc10a510f is in __block_prepare_write (fs/buffer.c:1821).
> 1816            unsigned blocksize, bbits;
> 1817            struct buffer_head *bh, *head, *wait[2], **wait_bh=wait;
> 1818
> 1819            BUG_ON(!PageLocked(page));
> 1820            BUG_ON(from > PAGE_CACHE_SIZE);
> 1821            BUG_ON(to > PAGE_CACHE_SIZE);
> 1822            BUG_ON(from > to);
> 1823
> 1824            blocksize = 1 << inode->i_blkbits;
> 1825            if (!page_has_buffers(page))

yup, thanks, I'd forgotten about that one.  Nick had a protofix but afaik nobody
has tested it yet.


