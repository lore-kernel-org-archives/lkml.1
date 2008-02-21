Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbYBUMkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbYBUMkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761545AbYBUMkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:40:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501AbYBUMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:40:22 -0500
Date: Thu, 21 Feb 2008 04:38:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
Message-Id: <20080221043828.bcd5cbce.akpm@linux-foundation.org>
In-Reply-To: <47BC982C.7050402@imap.cc>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<47BC982C.7050402@imap.cc>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 22:14:20 +0100 Tilman Schmidt <tilman@imap.cc> wrote:

> Ok, so here's my story on 2.6.25-rc2-mm1:
> 
> Built fine on my Pentium D in 32 bit mode, booted too, although
> complaining once already while unpacking the initramfs:
> 
> <0>[    0.069176] BUG: spinlock bad magic on CPU#0, swapper/0
> <0>[    0.069324]  lock: c2c19480, .magic: 00000000, .owner: swapper/0, .owner_cpu: 0
> <4>[    0.069559] Pid: 0, comm: swapper Not tainted 2.6.25-rc2-mm1-testing #1
> <4>[    0.069710]  [spin_bug+129/140] spin_bug+0x81/0x8c
> <4>[    0.069907]  [_raw_spin_unlock+30/118] _raw_spin_unlock+0x1e/0x76
> <4>[    0.069997]  [_spin_unlock+34/65] _spin_unlock+0x22/0x41
> <4>[    0.070194]  [mnt_want_write+103/138] mnt_want_write+0x67/0x8a
> <4>[    0.070390]  [sys_mkdirat+139/219] sys_mkdirat+0x8b/0xdb
> <4>[    0.070584]  [clean_path+27/79] ? clean_path+0x1b/0x4f
> <4>[    0.070829]  [trace_hardirqs_on+11/13] ? trace_hardirqs_on+0xb/0xd
> <4>[    0.071185]  [sys_mkdir+21/23] sys_mkdir+0x15/0x17
> <4>[    0.071378]  [do_name+279/440] do_name+0x117/0x1b8
> <4>[    0.071570]  [write_buffer+34/49] write_buffer+0x22/0x31
> <4>[    0.071763]  [flush_window+105/184] flush_window+0x69/0xb8
> <4>[    0.071996]  [unpack_to_rootfs+1585/2238] unpack_to_rootfs+0x631/0x8be
> <4>[    0.072192]  [trace_hardirqs_on_caller+248/301] ? trace_hardirqs_on_caller+0xf8/0x12d
> <4>[    0.072440]  [restore_nocheck_notrace+0/16] ? restore_nocheck_notrace+0x0/0x10
> <4>[    0.072689]  [populate_rootfs+37/270] populate_rootfs+0x25/0x10e
> <4>[    0.072886]  [alternative_instructions+344/349] ? alternative_instructions+0x158/0x15d
> <4>[    0.073139]  [start_kernel+840/858] start_kernel+0x348/0x35a
> <4>[    0.073335]  =======================

(net-related cc's removed)

This look like a startup ordering bug in mnt_want_write().
