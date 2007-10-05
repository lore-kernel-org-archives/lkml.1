Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXJEHmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXJEHmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 03:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXJEHmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 03:42:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:60262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbXJEHmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 03:42:16 -0400
Date: Fri, 5 Oct 2007 00:44:23 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [OOPS] AXIS 700 Lite (VIA C7 CPU) BUG with 2.6.23-rc9-git (i2c)
Message-ID: <20071005074423.GA17572@suse.de>
References: <Pine.LNX.4.60.0710042343030.4537@poirot.grange> <20071005092844.26d27198@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005092844.26d27198@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 09:28:44AM +0200, Jean Delvare wrote:
> Hi Guennadi,
> 
> On Fri, 5 Oct 2007 00:46:59 +0200 (CEST), Guennadi Liakhovetski wrote:
> > Got an AXIS 700 Lite thin client with a C7 CPU and CN700 chipset in it, 
> > compiled today's git snapshot, and it Oopses in i2c_viapro:
> > 
> > BUG: unable to handle kernel paging request at virtual address 016c0555
> >  printing eip:
> > c01a60ed
> > *pde = 00000000
> > Oops: 0000 [#1]
> > PREEMPT 
> > Modules linked in: i2c_viapro i2c_dev i2c_core loop
> > CPU:    0
> > EIP:    0060:[<c01a60ed>]    Not tainted VLI
> > EFLAGS: 00010282   (2.6.23-rc9-g804b3f9a #5)
> > EIP is at sysfs_create_group+0x1d/0xe0
> > eax: f889b828   ebx: 00000000   ecx: f7d764b0   edx: 016c0555
> > esi: 016c0555   edi: 00000000   ebp: f7d71dc4   esp: f7d71da8
> > ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> > Process modprobe (pid: 1214, ti=f7d70000 task=c18f3560 task.ti=f7d70000)
> > Stack: c03ceba0 f7d7647c f7d71dd8 c01a392b f7d764b0 00000000 f889f3a0 f7d71ddc 
> >        c0248b38 f889b828 f889b7c0 00000000 00000000 f7d71df4 c0248c0c 00000000 
> >        f889b7c0 00000000 f889b864 f7d71e20 c02491ee f889b828 c0367b56 f889b864 
> > Call Trace:
> >  [<c0104e7c>] show_trace_log_lvl+0x1c/0x40
> >  [<c0104f5a>] show_stack_log_lvl+0x9a/0xc0
> >  [<c01051bc>] show_registers+0x1dc/0x340
> >  [<c01054b2>] die+0x102/0x210
> >  [<c01183c6>] do_page_fault+0x266/0x600
> >  [<c031102a>] error_code+0x6a/0x70
> >  [<c0248b38>] device_add_groups+0x28/0x60
> >  [<c0248c0c>] device_add_attrs+0x5c/0xb0
> >  [<c02491ee>] device_add+0xfe/0x330
> >  [<c0249432>] device_register+0x12/0x20
> >  [<f889f53d>] i2c_register_adapter+0xbd/0x170 [i2c_core]
> >  [<f889f66a>] i2c_add_adapter+0x7a/0x80 [i2c_core]
> >  [<f889a605>] vt596_probe+0x145/0x370 [i2c_viapro]
> >  [<c01ef7dd>] pci_call_probe+0xd/0x10
> >  [<c01ef82f>] __pci_device_probe+0x4f/0x60
> >  [<c01ef869>] pci_device_probe+0x29/0x50
> >  [<c024b864>] really_probe+0x94/0x140
> >  [<c024b970>] driver_probe_device+0x40/0x60
> >  [<c024baaa>] __driver_attach+0x7a/0x80
> >  [<c024aa74>] bus_for_each_dev+0x54/0x70
> >  [<c024bac9>] driver_attach+0x19/0x20
> >  [<c024b177>] bus_add_driver+0x77/0x130
> >  [<c024bed5>] driver_register+0x75/0x80
> >  [<c01efb7a>] __pci_register_driver+0x4a/0x80
> >  [<f8890017>] i2c_vt596_init+0x17/0x19 [i2c_viapro]
> >  [<c01420a2>] sys_init_module+0xe2/0x140
> >  [<c0104162>] sysenter_past_esp+0x5f/0x85
> >  =======================
> > Code: e8 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 56 89 d6 53 83 ec 
> > 14 85 c0 0f 84 b2 00 00 00 8b 48 30 85 c9 0f 84 a7 00 00 00 <8b> 12 85 d2 
> > 0f 85 89 00 00 00 89 4d f4 8b 5d f4 85 db 74 0b 8b 
> > EIP: [<c01a60ed>] sysfs_create_group+0x1d/0xe0 SS:ESP 0068:f7d71da8
> 
> Thanks for letting us know. From the stack trace above, the oops
> happens in the driver core. Greg, did you touch something in this area
> recently?

No I have not, sorry.

thanks,

greg k-h
