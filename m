Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbYBKVqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbYBKVqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYBKVqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:46:21 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:28964 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbYBKVqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:46:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a+vP4f7kruN1xqcFt7An9S5VtfkZOxi00Ny7iD5LeP/DG74YlwMX1IUKFLjRckBLW8BPtL4l+zfCMwE++HIm9mfq6I+vjtzCObwjbF1K2QeiQfaQ8cycF9JG8tH/eOnktuzeQ7ZR5jaMIKgIc1pHd9dYat5qOwJ4YEFlkXGTRSo=
Message-ID: <64bb37e0802111346q13ddc3fy60edfce0daff3bf@mail.gmail.com>
Date: Mon, 11 Feb 2008 22:46:18 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 11, 2008 1:44 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> So give it all a good testing.

My mm-mystery-crash has now sneaked into mainline:
[ 1463.829078] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000378
[ 1463.832141] IP: [<ffffffff8047af18>] ether1394_dg_complete+0x28/0xa0
[ 1463.834616] PGD 7955e067 PUD 7955d067 PMD 0
[ 1463.836148] Oops: 0000 [1] SMP
[ 1463.836148] CPU 0
[ 1463.836148] Modules linked in: radeon drm w83792d ipv6 tuner
tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
tvaudio msp3400 bttv videodev v4l1_compat ir_common compat_ioctl32
v4l2_common videobuf_dma_sg videobuf_core btcx_risc usbhid tveeprom sg
i2c_nforce2 hid pata_amd
[ 1463.836148] Pid: 519, comm: khpsbpkt Not tainted 2.6.25-rc1 #1
[ 1463.836148] RIP: 0010:[<ffffffff8047af18>]  [<ffffffff8047af18>]
ether1394_dg_complete+0x28/0xa0
[ 1463.836148] RSP: 0000:ffff81007eeb1e80  EFLAGS: 00010282
[ 1463.836148] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
[ 1463.836148] RDX: ffff81004bc62d80 RSI: 0000000000000000 RDI: ffff810051873e40
[ 1463.836148] RBP: ffff81007eeb1eb0 R08: 0000000000000000 R09: 0000000000000001
[ 1463.836148] R10: 0000000000000001 R11: 0000000000000001 R12: ffff810051873e40
[ 1463.836148] R13: ffff81007e1f7200 R14: 0000000000000001 R15: ffff810051873e40
[ 1463.836148] FS:  00007f727d6d4700(0000) GS:ffffffff807e8000(0000)
knlGS:0000000000000000
[ 1463.836148] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1463.836148] CR2: 0000000000000378 CR3: 0000000079559000 CR4: 00000000000006e0
[ 1463.836148] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1463.836148] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1463.836148] Process khpsbpkt (pid: 519, threadinfo
ffff81007eeb0000, task ffff81007ee9e000)
[ 1463.836148] Stack:  ffff81007eeb1e90 ffff81004bc62b40
ffff810051873e40 0000000000000000
[ 1463.836148]  0000000000000001 0000000000000000 ffff81007eeb1ee0
ffffffff8047b233
[ 1463.836148]  ffff81007eeb1ec8 ffff81007eeb1ef0 ffffffff8046c280
ffff81007ff6df10
[ 1463.836148] Call Trace:
[ 1463.836148]  [<ffffffff8047b233>] ether1394_complete_cb+0xb3/0xd0
[ 1463.836148]  [<ffffffff8046c280>] ? hpsbpkt_thread+0x0/0x140
[ 1463.836148]  [<ffffffff8046c33b>] hpsbpkt_thread+0xbb/0x140
[ 1463.836148]  [<ffffffff8024aead>] kthread+0x4d/0x80
[ 1463.836148]  [<ffffffff8020c578>] child_rip+0xa/0x12
[ 1463.836148]  [<ffffffff8020bc8f>] ? restore_args+0x0/0x31
[ 1463.836148]  [<ffffffff8024ae60>] ? kthread+0x0/0x80
[ 1463.836148]  [<ffffffff8020c56e>] ? child_rip+0x0/0x12
[ 1463.836148]
[ 1463.836148]
[ 1463.836148] Code: 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d d8 4c
89 75 f0 89 f3 4c 89 7d f8 4c 89 65 e0 49 89 ff 4c 89 6d e8 4c 8b 2f
49 8b 45 20 <4c> 8b a0 78 03 00 00 4d 8d b4 24 d0 00 00 00 4c 89 f7 e8
41 f0
[ 1463.836148] RIP  [<ffffffff8047af18>] ether1394_dg_complete+0x28/0xa0
[ 1463.836148]  RSP <ffff81007eeb1e80>
[ 1463.836148] CR2: 0000000000000378
[ 1463.836208] ohci1394: fw-host0: Waking dma ctx=0 ... processing is
probably too slow
[ 1463.839250] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000000
[ 1463.841549] IP: [<ffffffff80296d1d>] kmem_cache_alloc_node+0x6d/0xa0
[ 1463.842925] PGD 7955e067 PUD 7955d067 PMD 0
[ 1463.846148] Oops: 0000 [2] SMP
[ 1463.846148] CPU 0
[ 1463.846148] Modules linked in: radeon drm w83792d ipv6 tuner
tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
tvaudio msp3400 bttv videodev v4l1_compat ir_common compat_ioctl32
v4l2_common videobuf_dma_sg videobuf_core btcx_risc usbhid tveeprom sg
i2c_nforce2 hid pata_amd
[ 1463.846148] Pid: 519, comm: khpsbpkt Tainted: G      D  2.6.25-rc1 #1
[ 1463.846148] RIP: 0010:[<ffffffff80296d1d>]  [<ffffffff80296d1d>]
kmem_cache_alloc_node+0x6d/0xa0
[ 1463.846148] RSP: 0000:ffffffff80871ae0  EFLAGS: 00010046
[ 1463.846148] RAX: 0000000000000000 RBX: ffff810001006820 RCX: ffffffff8052c549
[ 1463.846148] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff807fbec0
[ 1463.846148] RBP: ffffffff80871b00 R08: 00000000000005e0 R09: 000000000000ffc1
[ 1463.846148] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000ffffffff
[ 1463.846148] R13: 0000000000000020 R14: 0000000000000020 R15: ffffffff807fbec0
-> here the output from the serial console stopped.
Caps lock and Scroll lock where flashing again and as it hit a 'good'
spot during the installing of the package this crash resulted in a
corrupted ld.so.cache and damage several housekeeping files of the
package manager. :-(

Last good mm was 2.6.24-rc2-mm1, the next booting mm was
2.6.24-rc3-mm2 and that version had these "random" crashes.
Last good mainline was 2.6.24-rc7 that I was testing with the new
iommu patches that where added to 2.6.24-rc3-mm2.

I did a partly bisect of 2.6.24-rc6-mm1 that narrow it to this range:
2.6.24-rc6 + mm-patches up to (including) git.nfsd -> worked
2.6.24-rc6 + mm-patches up to (including) git.xfs -> crashed

I think the only added patch between rc2-mm1 and rc3-mm2 in that range
where the iommu changes that I later ruled out.
That leaves some git trees as suspects:
git-ocfs2.patch
git-selinux.patch
git-s390.patch
git-sched.patch
git-sh.patch
git-scsi-misc.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-xfs.patch

I don't use ocfs2, selinux, unionfs or the p9fs.
The system is a dual opteron x86_64 system with 4 GB ECC RAM and an
nVidia 3600 chipset (MCP55).
As noted in the rc3-mm2-thread the crash will also happen, if I use
normal ethernet instead of ether1394.

The root filesystem is xfs on dm-crypt on raid5 on 3 sata disks. 2 on
sata_sil24, 1 on sata_nv.

My testcase is updating the system, this means in the case of gentoo
compiling the new packages, then installing them. The portage tree and
the distfiles (source packages) are on a NFSv4 share.

Sadly I currently lack the time to do much testing, so further
bisecting that mm-kernel is not possible, as each step takes several
hours of compiling packages and hoping to hit the bug. Somtimes I
needed to compile over 100 KDE packages until it triggered.

Torsten
