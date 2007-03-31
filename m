Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXCaUlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXCaUlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXCaUlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:41:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXCaUlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:41:08 -0400
Date: Sat, 31 Mar 2007 13:40:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20.4 crashes
Message-Id: <20070331134011.068995e2.akpm@linux-foundation.org>
In-Reply-To: <460EAC2A.8080706@dns.toxicfilms.tv>
References: <460EAC2A.8080706@dns.toxicfilms.tv>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 20:44:58 +0200 Maciej Soltysiak <solt@dns.toxicfilms.tv> wrote:

> Hi,
> 
> here's more...
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> 00000000
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in: binfmt_misc sit nfs lockd nfs_acl sunrpc ipt_ECN iptable_mangle w83627ehf i2c_isa i2c_viapro i2c_core via_agp agpgart rtc
> CPU:    0
> EIP:    0060:[<00000000>]    Not tainted VLI
> EFLAGS: 00010016   (2.6.20.3-cks1 #4)

That's not 2.6.20.4.

> EIP is at 0x0
> eax: e94a5e6c   ebx: e94a5e6c   ecx: 00000000   edx: 00000001
> esi: 00000000   edi: e94a5e84   ebp: e94a5e6c   esp: e94a5e4c
> ds: 007b   es: 007b   ss: 0068
> Process grep (pid: 9156, ti=e94a4000 task=f4569a90 task.ti=e94a4000)
> Stack: c0116429 00000000 00000001 00000001 ec7da800 00000000 00000286 00000000 
>        e94a5e84 c0117802 00000000 00000000 ec7da800 ec7da800 ec7da85c c015c622 
>        00000000 e9d02b40 e94a5f60 f77b6ac0 00000000 00000400 c0313e6c 00001000 
> Call Trace:
>  [<c0116429>] __wake_up_common+0x39/0x70
>  [<c0117802>] __wake_up+0x22/0x30
>  [<c015c622>] pipe_write+0x222/0x4b0
>  [<c0156887>] do_sync_write+0xc7/0x110
>  [<c012b5c0>] autoremove_wake_function+0x0/0x50
>  [<c0157156>] vfs_write+0xa6/0x160
>  [<c01567c0>] do_sync_write+0x0/0x110
>  [<c0157781>] sys_write+0x41/0x70
>  [<c0102ed6>] sysenter_past_esp+0x5f/0x85
>  [<c0300033>] ipv6_flowlabel_opt+0x193/0x730
>  =======================
> Code:  Bad EIP value.
> EIP: [<00000000>] 0x0 SS:ESP 0068:e94a5e4c

__wake_up() did a jump-to-zero.  Is it repeatable?  Does removal of Con's 
patchset fix it?
