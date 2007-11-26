Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbXKZNpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbXKZNpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 08:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXKZNox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 08:44:53 -0500
Received: from eazy.amigager.de ([213.239.192.238]:33867 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXKZNow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:44:52 -0500
Date: Mon, 26 Nov 2007 14:12:10 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: XFS related Oops
Message-ID: <20071126131210.GA4430@eazy.amigager.de>
Mail-Followup-To: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
References: <20071112064706.GA23595@dose.home.local> <20071112222720.GG995458@sgi.com> <20071113105119.GA11527@dose.home.local> <20071113230445.GE995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113230445.GE995458@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 10:04:45 +1100, David Chinner wrote:
> On Tue, Nov 13, 2007 at 11:51:19AM +0100, Tino Keitel wrote:
> > On Tue, Nov 13, 2007 at 09:27:20 +1100, David Chinner wrote:
> > 
> > [...]
> > 
> > > No. I'd say something got screwed up during suspend/resume. Is it
> > > reproducable?
> > 
> > No. I often use suspend to RAM, and usually it works without such
> > failures. I restart squid during the resume prosecure, and the above
> > Oops lead to a squid in D state.
> 
> Ok. Sounds like there's not much we can debug at this point. Thanks
> for the report, though.

I got a similar Oops again:

xfs_iget_core: ambiguous vns: vp/0xc00700c0, invp/0xcb5a1680
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:55!
invalid opcode: 0000 [#2]
SMP 
Modules linked in: dvb_usb_cinergyT2 rfcomm l2cap bluetooth i915 drm
cpufreq_stats firewire_ohci firewire_core dvb_usb crc_itu_t usblp evdev
snd_hda_intel rtc_cmos sky2 dvb_core applesmc led_class coretemp hwmon
CPU:    0
EIP:    0060:[<c025a45a>]    Tainted: G      D VLI
EFLAGS: 00010246   (2.6.23.1 #4)
EIP is at cmn_err+0x9a/0xa0
eax: c049efb0   ebx: c044ffac   ecx: 00000001   edx: 00000286
esi: 00000000   edi: 00000286   ebp: f75f86f0   esp: eab9fccc
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process gc_approx (pid: 29386, ti=eab9e000 task=e409b030
task.ti=eab9e000)
Stack: c04531ce c043a07d c05544c0 eab9fcf4 c0071500 00002094 00000000
c022855b 
       00000000 c044ffac c00700c0 cb5a1680 f796ac00 c18828c4 c04fb280
f75f86f4 
       00000000 00000000 f748e800 cb5a1680 00000000 c0071500 cb5a169c
cb5a1680 
Call Trace:
 [<c022855b>] xfs_iget_core+0x54b/0x690
 [<c0228774>] xfs_iget+0xd4/0x160
 [<c024474b>] xfs_dir_lookup_int+0x9b/0x100
 [<c0247ec5>] xfs_lookup+0x75/0xa0
 [<c0256874>] xfs_vn_lookup+0x54/0x90
 [<c0177a32>] do_lookup+0x122/0x1a0
 [<c01794d4>] __link_path_walk+0x784/0xd80
 [<c0179b35>] link_path_walk+0x65/0xc0
 [<c0179b15>] link_path_walk+0x45/0xc0
 [<c0179db3>] do_path_lookup+0x73/0x1b0
 [<c0178a55>] getname+0xa5/0xc0
 [<c017a7bb>] __user_walk_fd+0x3b/0x60
 [<c0173992>] vfs_stat_fd+0x22/0x60
 [<c0173a7f>] sys_stat64+0xf/0x30
 [<c0181885>] dput+0x85/0x100
 [<c0171744>] __fput+0x114/0x160
 [<c01856eb>] mntput_no_expire+0x1b/0x80
 [<c016ead7>] filp_close+0x47/0x80
 [<c016ff93>] sys_close+0x63/0xc0
 [<c010428e>] sysenter_past_esp+0x5f/0x85
 [<c03e0000>] __mutex_lock_interruptible_slowpath+0xb0/0x290
 =======================
Code: 45 c0 89 44 24 04 e8 e6 ec ec ff 89 fa b8 b0 ef 49 c0 e8 5a 6e 18
00 85 f6 74 10 83 c4 10 5b 5e 5f c3 c6 81 c0 44 55 c0 00 eb c1 <0f> 0b
eb fe 90 90 83 ec 10 85 d2 89 1c 24 89 cb 89 74 24 04 89 
EIP: [<c025a45a>] cmn_err+0x9a/0xa0 SS:ESP 0068:eab9fccc

Regards,
Tino
