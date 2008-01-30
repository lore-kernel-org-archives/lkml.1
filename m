Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYA3FtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYA3FtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYA3Fsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:48:53 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:1765 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYA3Fsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GcAiwxE3NY1GfTYy1EZVUHlrSLtKUdcVEKJZan4iZUOi0bObGW2+QrTdIW8tWMXaTuFwam4qXGNyBHgZMDWjob9FGtAgS01GKe3qsNyVtTIpbj1CJYS9bvixy6ODiJzjhC6cCfRNgNTwoPIGqe3WQwxkbWlAZeIL+yUp0csxVO0=
Message-ID: <a8e1da0801292148u53c92f09ga270fa9d2922b649@mail.gmail.com>
Date: Wed, 30 Jan 2008 13:48:44 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Miguel Ojeda" <maxextreme@gmail.com>
Subject: Re: [WARNING -rc8] at fs/sysfs/dir.c:424 sysfs_add_one(), related with processor (ACPI)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <a8e1da0801241727y1af0b0feu96b1153a6e3da954@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <653402b90801210953u71a85f91udce9e382d588af09@mail.gmail.com>
	 <20080123140643.b56ea8eb.akpm@linux-foundation.org>
	 <20080124014436.GA3020@darkstar.te-china.tietoenator.com>
	 <653402b90801240832n4b39ec55gadb0cf193dcfc717@mail.gmail.com>
	 <a8e1da0801241727y1af0b0feu96b1153a6e3da954@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 9:27 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> On Jan 25, 2008 12:32 AM, Miguel Ojeda <maxextreme@gmail.com> wrote:
> >
> > On Jan 24, 2008 2:44 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > >
> > > On Wed, Jan 23, 2008 at 02:06:43PM -0800, Andrew Morton wrote:
> > > > > On Mon, 21 Jan 2008 18:53:18 +0100 "Miguel Ojeda" <maxextreme@gmail.com> wrote:
> > > > > Booting 2.6.24-rc8 I get this:
> > > > >
> > > > >
> > > > > sysfs: duplicate filename 'fan' can not be created
> > > > > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > > > Pid: 819, comm: modprobe Not tainted 2.6.24-rc8 #2
> > > > >  [<c01b18ff>] sysfs_add_one+0x9f/0xe0
> > > > >  [<c01b1e38>] create_dir+0x48/0x90
> > > > >  [<c01b1ea9>] sysfs_create_dir+0x29/0x50
> > > > >  [<c024873f>] kobject_get+0xf/0x20
> > > > >  [<c0248bff>] kobject_add+0x8f/0x1b0
> > > > >  [<c0248db1>] kobject_register+0x21/0x50
> > > > >  [<c02dc6f1>] bus_add_driver+0x71/0x1e0
> > > > >  [<f886402f>] acpi_fan_init+0x2f/0x4d [fan]
> > > > >  [<c0148986>] sys_init_module+0x126/0x19b0
> > > > >  [<c024af87>] rb_insert_color+0xb7/0xe0
> > > > >  [<c029dc8d>] acpi_bus_register_driver+0x0/0x38
> > > > >  [<c0104286>] syscall_call+0x7/0xb
> > > > >  =======================
> > > > > kobject_add failed for fan with -EEXIST, don't try to register things
> > > > > with the same name in the same directory.
> > > > > Pid: 819, comm: modprobe Not tainted 2.6.24-rc8 #2
> > > > >  [<c0248c81>] kobject_add+0x111/0x1b0
> > > > >  [<c0248db1>] kobject_register+0x21/0x50
> > > > >  [<c02dc6f1>] bus_add_driver+0x71/0x1e0
> > > > >  [<f886402f>] acpi_fan_init+0x2f/0x4d [fan]
> > > > >  [<c0148986>] sys_init_module+0x126/0x19b0
> > > > >  [<c024af87>] rb_insert_color+0xb7/0xe0
> > > > >  [<c029dc8d>] acpi_bus_register_driver+0x0/0x38
> > > > >  [<c0104286>] syscall_call+0x7/0xb
> > > > >  =======================
> > > > > processor: exports duplicate symbol acpi_processor_set_thermal_limit
> > > > > (owned by kernel)
> > > > >
> > >
> > > Could apply following debug patch and see the result?
> > >
> > >
> > > diff -upr linux/fs/sysfs/dir.c linux.new/fs/sysfs/dir.c
> > > --- linux/fs/sysfs/dir.c        2008-01-23 09:56:24.000000000 +0800
> > > +++ linux.new/fs/sysfs/dir.c    2008-01-23 09:59:12.000000000 +0800
> > > @@ -418,6 +418,8 @@ void sysfs_addrm_start(struct sysfs_addr
> > >   */
> > >  int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
> > >  {
> > > +       if (!strcmp(sd->s_name, "fan"))
> > > +               dump_stack();
> > >         if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
> > >                 printk(KERN_WARNING "sysfs: duplicate filename '%s' "
> > >                        "can not be created\n", sd->s_name);
> > >
> > >
> >
> > Done. The following appears in the new dmesg output.
> >
> >
> > ACPI: Power Button (CM) [PBTN]
> > input: Sleep Button (CM) as /class/input/input2
> > ACPI: Sleep Button (CM) [SBTN]
> > Pid: 1, comm: swapper Not tainted 2.6.24-rc8 #3
> >  [<c01b18d5>] sysfs_add_one+0x75/0x100
> >  [<c01b199f>] sysfs_addrm_start+0x3f/0xb0
> >  [<c01b1e58>] create_dir+0x48/0x90
> >  [<c01b1ec9>] sysfs_create_dir+0x29/0x50
> >  [<c024875f>] kobject_get+0xf/0x20
> >  [<c0248c1f>] kobject_add+0x8f/0x1b0
> >  [<c0248dd1>] kobject_register+0x21/0x50
> >  [<c02dc711>] bus_add_driver+0x71/0x1e0
> >  [<c05c7663>] acpi_fan_init+0x2f/0x4d
> >  [<c05ad551>] kernel_init+0x121/0x300
> >  [<c010416a>] ret_from_fork+0x6/0x1c
> >  [<c05ad430>] kernel_init+0x0/0x300
> >  [<c05ad430>] kernel_init+0x0/0x300
> >  [<c0104e6f>] kernel_thread_helper+0x7/0x18
> >  =======================
>
> I'm curious, the "fan" is configured as built-in, why the modprobe be called?

I guess initrd or your lib/modules need update.

>
>
> > ACPI: SSDT 3FE93134, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
> > ACPI: SSDT 3FE92ACA, 05E5 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
> > Monitor-Mwait will be used to enter C-1 state
> > Monitor-Mwait will be used to enter C-2 state
> >
> > Attached dmesg.txt
> >
> >
> > --
> > Miguel Ojeda
> > http://maxextreme.googlepages.com/index.htm
> >
>
