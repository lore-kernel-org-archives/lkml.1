Return-Path: <linux-kernel-owner+w=401wt.eu-S966255AbXDGSiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966255AbXDGSiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966263AbXDGSiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:38:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966255AbXDGSit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:38:49 -0400
Date: Sat, 7 Apr 2007 11:38:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: mm snapshot broken-out-2007-04-07-03-27.tar.gz uploaded
Message-Id: <20070407113829.c10e9fd1.akpm@linux-foundation.org>
In-Reply-To: <4617DE67.4090801@googlemail.com>
References: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
	<46178ECC.2030107@googlemail.com>
	<20070407105328.836902d1.akpm@linux-foundation.org>
	<4617DE67.4090801@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Apr 2007 20:09:43 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> BTW. I guess that this need a similar fix.
> 
> kernel BUG at kernel/ptrace.c:494!
> invalid opcode: 0000 [#2]
> PREEMPT SMP 
> last sysfs file: devices/platform/w83627hf.656/temp2_input
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss intel_agp snd_pcm agpgart evdev snd_timer snd soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
> CPU:    1
> EIP:    0060:[<c0163f22>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.21-rc6-mm1 #1)
> EIP is at ptrace_exit+0x29/0x21d
> 

no, I don't see what would cause that.  Was there no call trace?

It's always possible that some random part of the kernel has
gone and leaked a preempt_count.

BUG_ON is an obnoxious thing - please prefer to use WARN_ON in non-fatal
situations.   Particularly when the assertions aren't tested ;)
