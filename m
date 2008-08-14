Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYHNPE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYHNPE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYHNPET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:04:19 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:51767 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbYHNPES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:04:18 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0808141347480.11013@blonde.site>
References: <1218697362.26014.9.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0808141347480.11013@blonde.site>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 15:56:34 +0100
Message-Id: <1218725794.29410.17.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: kernel BUG at lib/radix-tree.c:473!
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 14:06 +0100, Hugh Dickins wrote:
> On Thu, 14 Aug 2008, Ian Campbell wrote:
> > Jeremy first noticed this
> > http://marc.info/?l=linux-kernel&m=121783008503477&w=2
> > 
> > [    3.132333] ------------[ cut here ]------------
> > [    3.132343] kernel BUG at /home/ijc/development/kernel/2.6.git/lib/radix-tree.c:473!
> > [    3.132348] invalid opcode: 0000 [#1] SMP 
> > [    3.132352] Modules linked in:
> > [    3.132356] 
> > [    3.132363] Pid: 580, comm: debconf Tainted: G        W (2.6.26 #27)
> > [    3.132368] EIP: 0061:[<c01f5279>] EFLAGS: 00010002 CPU: 0
> > [    3.132375] EIP is at radix_tree_tag_set+0x1d/0x9f
> > [    3.132379] EAX: c203af30 EBX: c261b8c0 ECX: 00000000 EDX: 00000001
> > [    3.132383] ESI: 00000000 EDI: 00000001 EBP: c7977ce8 ESP: c7977cc8
> > [    3.132387]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
> > [    3.132392] Process debconf (pid: 580, ti=c7976000 task=c538a240 task.ti=c7976000)
> > [    3.132396] Stack: fffede22 00000000 00000001 c203af30 c203af2c c261b8c0 c203af2c 00000001 
> > [    3.132406]        c7977cfc c01a1570 c261b8c0 c203af2c c2563000 c7977d0c c01a1a24 c261b8c0 
> > [    3.132416]        00000001 c7977d1c c01682fc c261b8c0 00000001 c7977d2c c0169185 c261b8c0 
> > [    3.132425] Call Trace:
> > [    3.132428]  [<c01a1570>] ? __set_page_dirty+0xdf/0x11f
> > [    3.132434]  [<c01a1a24>] ? __set_page_dirty_buffers+0x68/0x6c
> > [    3.132441]  [<c01682fc>] ? set_page_dirty+0x34/0x94
> > [    3.132446]  [<c0169185>] ? set_page_dirty_balance+0xe/0x3c
> > [    3.132452]  [<c016eec6>] ? __do_fault+0x35d/0x37e
> > [    3.132458]  [<c01707a4>] ? handle_mm_fault+0x45d/0x9c9
> > [    3.132463]  [<c01939a0>] ? __d_lookup+0xb7/0xeb
> > [    3.132469]  [<c0180d18>] ? kfree+0x81/0x88
> > [    3.132474]  [<c02dfaf7>] ? _spin_unlock_irqrestore+0x19/0x1f
> > [    3.132481]  [<c02dfaf7>] ? _spin_unlock_irqrestore+0x19/0x1f
> > [    3.132487]  [<c011b5ee>] ? do_page_fault+0x3be/0x8d0
> > [    3.132493]  [<c02061ef>] ? fb_ioctl+0x1a2/0x2de
> > [    3.132499]  [<c011ad1c>] ? pvclock_clocksource_read+0x48/0xa3
> > [    3.132506]  [<c02dfaf7>] ? _spin_unlock_irqrestore+0x19/0x1f
> > [    3.132512]  [<c013e02b>] ? hrtimer_start+0x12a/0x144
> > [    3.132519]  [<c0104682>] ? xen_mc_flush+0x123/0x160
> > [    3.132525]  [<c0104699>] ? xen_mc_flush+0x13a/0x160
> > [    3.136027]  [<c010436c>] ? xen_leave_lazy+0x12/0x14
> > [    3.136027]  [<c01075bc>] ? __switch_to+0xec/0x126
> > [    3.136027]  [<c012755c>] ? finish_task_switch+0x32/0xa5
> > [    3.136027]  [<c02de601>] ? schedule+0x6cc/0x735
> > [    3.136027]  [<c018e377>] ? vfs_ioctl+0x57/0x69
> > [    3.136027]  [<c018e636>] ? sys_ioctl+0x50/0x5a
> > [    3.136027]  [<c011b230>] ? do_page_fault+0x0/0x8d0
> > [    3.136027]  [<c02dfd3a>] ? error_code+0x72/0x78
> > [    3.136027]  =======================
> > [    3.136027] Code: b4 89 42 04 83 c4 50 89 d8 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 14 89 45 ec 89 55 e8 89 4d e4 8b 30 3b 14 b5 88 52 3a c0 76 04 <0f> 0b eb fe 8b 45 ec 8b 4d e4 8b 58 08 6b c6 06 c1 e1 03 
> > [    3.136027] EIP: [<c01f5279>] radix_tree_tag_set+0x1d/0x9f SS:ESP 0069:c7977cc8
> > [    3.136027] ---[ end trace 991579adcab01bbf ]---
> > 
> > I've bisected it down to:
> > commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
> > Author: Hugh Dickins <hugh@veritas.com>
> > Date:   Mon Jul 28 15:46:19 2008 -0700
> > 
> >     tmpfs: fix kernel BUG in shmem_delete_inode
> > 
> > Reverting this patch from current Linus tree
> > (b635acec48bcaa9183fcbf4e3955616b0d4119b5) causes the problem to go
> > away. I haven't yet seen the link between the backtrace and this
> > changeset though.
> 
> Nor I!  Thanks a lot for doing the bisection, but all I can say so far
> is that I'm utterly flummoxed.  (And I do wonder if it's a pvfb bug
> which has previously been masked; but that's premature, we can't
> say until we understand how it got here at all.)

I've added Markus, the current PVFB maintainer.

> There's a lot of "?" entries in your backtrace, Jeremy's ones
> look clearer: CONFIG_FRAME_POINTER=y ought to improve yours.

That was with CONFIG_FRAME_POINTER=y / CONFIG_DEBUG_KERNEL=y /
CONFIG_DEBUG_INFO=y. I wonder why it is so crappy...

> In both cases it's handling a page fault: I'm curious as to what kind
> of vma this fault is occurring on.  Could you devise a way of getting
> us /proc/<pid>/maps output, together with the faulting address, when
> it hits one of these BUGs?  Or should I try to put together a patch
> for that?

I'll have a go but I'm just about to go away for a long weekend so it
might be next week unless I get to it tonight. Any pointers on how to go
about it would be appreciated though...

Ian.

-- 
Ian Campbell
Current Noise: Enslaved - Intro: "Green Reflection"

The problem with people who have no vices is that generally you can
be pretty sure they're going to have some pretty annoying virtues.
		-- Elizabeth Taylor

