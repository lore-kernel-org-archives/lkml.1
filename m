Return-Path: <linux-kernel-owner+w=401wt.eu-S1764944AbXGaPGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764944AbXGaPGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762274AbXGaPFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:05:52 -0400
Received: from [212.12.190.233] ([212.12.190.233]:33983 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762831AbXGaPFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:05:51 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: HowTo crashkernel hibernation (was: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation)
Date: Tue, 31 Jul 2007 18:06:01 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311806.02000.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> > 3. Boot kernel compiled for normal usage, the reserved crash kernel
> > memory region must be added to kernel command line as following:
> >
> > crashkernel=<XX>M@<XX>M
> >
> > Where, <XX> should be replaced by the real memory size and
> > position.
>
> I used crashkernel=64M@64M .

It's good to see that people finally try this.

I used crashkernel=16M@16M, which is the absolute minimum I managed to have 
the crashkernel boot successfully.

> > 4. Load kernel compiled for hibernating usage as a crashdump kernel
> > with kexec, the same kernel as that of 3 can be used if
> > CONFIG_RELOCATABLE=y is selected.

That's not enough.  You have to set the CONFIG_PHYSICAL_START to 1,000,000 
for a 16M start.  That's because the crashkernel only supports vmlinux, 
which cannot be relocatable.

> > The kernel command line option as
> > following must be appended to kernel command line.
> >
> > kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`
> >
> > For example, the shell command line can be as follow:
> >
> > kexec -p /boot/vmlinux --args-linux --append="root=/dev/hdb signal
> > kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"
>
> I think I followed the instructions closely. Now I'm trying to do
>
> kexec -p /data/l/linux/vmlinux --args-linux --append="init=/bin/bash
> kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"
>
> but it tells me:
>
> Invalid memory segment 0x100000 - 0x7a0fff
>
> (and nothing in dmesg)
>
> If I try to load bzImage (corresponding to vmlinux I tried to use),  I
> get:
>
> root@amd:~# kexec -p /data/l/linux/arch/i386/boot/bzImage
> --append="init=/bin/bash \ kexec_jump_buf_pfn=`cat
> /sys/kernel/kexec_jump_buf_pfn`" Could not find a free area \ of memory of
> 9000 bytes... locate_hole failed
> root@amd:~#
>
> What am I doing wrong?

Nothing, but the doc isn't really clear on this, and an update is probably in 
order.


Thanks!

--
Al

