Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbXBOXj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbXBOXj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXBOXj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:39:27 -0500
Received: from smtp.ono.com ([62.42.230.12]:36612 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbXBOXj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:39:27 -0500
Date: Fri, 16 Feb 2007 00:39:12 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1
Message-ID: <20070216003912.238e6ba5@werewolf-wl>
In-Reply-To: <20070215153142.d631f8b7.akpm@linux-foundation.org>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<20070215223017.2cf5d19f@werewolf-wl>
	<20070215153142.d631f8b7.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.7.2cvs46 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 15:31:42 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 15 Feb 2007 22:30:17 +0100
> "J.A. Magall__n" <jamagallon@ono.com> wrote:
> 
> > On Thu, 15 Feb 2007 05:14:08 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > Temporarily at
> > > 
> > >   http://userweb.kernel.org/~akpm/2.6.20-mm1/
> > > 
> > > Will appear later at
> > > 
> > >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/
> > > 
> > > 
> > 
> > Oops plague for me :(.
> > 
> > A lot like this:
> > 
> > ee1394 usblp evdev
> > CPU:    1
> > EIP:    0060:[<c0195f12>]    Tainted: P       VLI
> > EFLAGS: 00010246   (2.6.20-jam01 #1)
> > EIP is at sysfs_lookup+0x5b/0x20a
> > eax: f6707118   ebx: f6b33e5c   ecx: f6917d38   edx: 00000004
> > esi: 00000000   edi: f670717c   ebp: f6b33e24   esp: f6997db4
> > ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > Process udevd (pid: 3899, ti=f6996000 task=f7e34540 task.ti=f6996000)
> > Stack: f66e1800 f6707118 c016da12 f66e1800 f6707118 c02f75c0 f6707118 f6997f04 
> >        f6997e38 c0164238 f6997e44 c210d8c0 f6b39340 f6b393b4 f7a7d025 f6997e38 
> >        27692f8b f6997f04 c0165a6a f7a7d01d 00000000 000200d2 c037ddac 00000286 
> > Call Trace:
> >  [<c016da12>] d_alloc+0x140/0x198
> >  [<c0164238>] do_lookup+0x128/0x165
> >  [<c0165a6a>] __link_path_walk+0x7e2/0xc9b
> >  [<c0165f68>] link_path_walk+0x45/0xbf
> >  [<c01661b6>] do_path_lookup+0x88/0x1cc
> >  [<c0165125>] getname+0x90/0xad
> >  [<c0166aa4>] __user_walk_fd+0x2f/0x47
> >  [<c01607c4>] vfs_lstat_fd+0x16/0x3d
> >  [<c0160830>] sys_lstat64+0xf/0x23
> >  [<c0111904>] do_page_fault+0x326/0x5e2
> >  [<c01115de>] do_page_fault+0x0/0x5e2
> >  [<c010288e>] sysenter_past_esp+0x5f/0x85
> >  [<c02f0000>] wait_for_completion_interruptible+0xdf/0xee
> 
> 
> Oh dear.  Any one of about 700 developers might have caused this.
> 
> bisection-search will find this.  Can you upload the .config please?
> 

Here it goes:

http://belly.cps.unizar.es/~magallon/oops/config-2.6.20-jam01

copied from previous and answered missing CONFIG_'s.
Just 2.6.20-m11 + 11-pci-iomap-regions posted in LKML + patch to make
HDIO_OBSOLETE_IDENTITY work on sata (also from LKML).

> > 
> > Full dmesg at:
> > 
> > http://belly.cps.unizar.es/~magallon/oops/oops.txt
> > 
> > And another one on reboot. Picture here:
> > 
> > http://belly.cps.unizar.es/~magallon/oops/IMG_1448.JPG
> > 
> > (sorry, no tripod available ;), just the back of my soft chair).
> >
> > And yes, before nobody says anything, nvidia.ko is loaded.
> > If you really want, I can try without it.
> 
> It would be appreciated if you could do that, thanks.

Probably tomorrow.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam07 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #2 SMP PREEMPT
