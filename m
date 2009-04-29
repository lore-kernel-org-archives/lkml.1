Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZD2Pul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZD2Pul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbZD2Pua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:50:30 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36337 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZD2Pu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:50:29 -0400
Date: Wed, 29 Apr 2009 17:50:24 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference in try_to_del_timer_sync()
Message-ID: <20090429155023.GD6291@buzzloop.caiaq.de>
References: <20090428081416.GA22269@buzzloop.caiaq.de> <20090428235551.862ee0d1.akpm@linux-foundation.org> <20090429151345.GC16302@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429151345.GC16302@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 08:13:45AM -0700, Greg KH wrote:
> On Tue, Apr 28, 2009 at 11:55:51PM -0700, Andrew Morton wrote:
> > (cc linux-usb)
> > 
> > On Tue, 28 Apr 2009 10:14:16 +0200 Daniel Mack <daniel@caiaq.de> wrote:
> > 
> > > This happened more than once in the last 12h on my desktop machine with
> > > the kernel snapshot as of ce8a7424d23a36f043 (yesterday). It's not
> > > reproducible, otherwise I would have bisected it.
> > > 
> > > Daniel
> > > 
> > > 
> > > [10982.240372] BUG: unable to handle kernel NULL pointer dereference at 00000090
> > > [10982.240383] IP: [<c022eefd>] lock_timer_base+0xe/0x3e
> > > [10982.240396] *pde = 00000000 
> > > [10982.240400] Oops: 0000 [#2] PREEMPT SMP 
> > > [10982.240405] last sysfs file: /sys/devices/pci0000:00/0000:00:02.1/usb1/1-3/idProduct
> > > [10982.240411] Modules linked in: cbc nvidia(P) ppdev lp nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc dm_crypt dm_mod aes_generic cryptoloop loop snd_usb_caiaq snd_rawmidi pl2303 snd_pcm ftdi_sio usbserial snd_timer snd_page_alloc psmouse pcspkr i2c_nforce2 via_rhine mii forcedeth parport_pc thermal button [last unloaded: nvidia]
> > > [10982.240449] 
> > > [10982.240455] Pid: 22809, comm: cu Tainted: P      D    (2.6.30-rc3 #1) MS-7260
> > > [10982.240458] EIP: 0060:[<c022eefd>] EFLAGS: 00210286 CPU: 1
> > > [10982.240462] EIP is at lock_timer_base+0xe/0x3e
> > > [10982.240465] EAX: 0000007c EBX: 0000007c ECX: c022f4b9 EDX: ea10fe5c
> > > [10982.240468] ESI: ffffffff EDI: 0000007c EBP: ea10fe54 ESP: ea10fe44
> > > [10982.240471]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > > [10982.240475] Process cu (pid: 22809, ti=ea10e000 task=ea779270 task.ti=ea10e000)
> > > [10982.240477] Stack:
> > > [10982.240479]  ea10fe5c 0000007c ffffffff 0000007c ea10fe68 c022f0b6 00200246 00000094
> > > [10982.240488]  00200246 ea10fe7c c022f515 000004b2 f66b4c00 00000000 ea10fe94 f86930c6
> > > [10982.240497]  22222222 f869c310 f66b4c00 ea0bf000 ea10feb8 f85c0a32 edc52f00 f66b4ce4
> > > [10982.240507] Call Trace:
> > > [10982.240510]  [<c022f0b6>] ? try_to_del_timer_sync+0x15/0x4f
> > > [10982.240516]  [<c022f515>] ? del_timer_sync+0x5c/0x6c
> > > [10982.240521]  [<f86930c6>] ? ftdi_close+0xc5/0xe9 [ftdi_sio]
> 
> Ick.
> 
> Can you reproduce this without having loaded the nvidia driver?
> What were you doing when this happened?

I first thought I can not reproduce this at all, but now I had a closer
look and it turns out that this _always_ happens when my USB serial
adapter is disconnected from USB while I have a 'cu' session running on
it. I didn't look into the sources or bisect it, but this is certainly a
new effect which came in during the last days.
I'm running weekly'ish updated git kernels on my desktop machine and use
this adapter every day, usually without problems.

Daniel

