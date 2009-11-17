Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZKQRjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZKQRjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZKQRjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:39:35 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58638 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902AbZKQRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:39:34 -0500
Message-Id: <1258479580.17116.1345691629@webmail.messagingengine.com>
X-Sasl-Enc: efqfsLJG5YQVWpR1ulRQ3cKyHGHw35CkUKL7pHS44Cci 1258479580
From: myuboot@fastmail.fm
To: "Ralf Baechle" <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
 <4AD906D8.3020404@caviumnetworks.com>
 <1257898975.30125.1344591929@webmail.messagingengine.com>
 <4AFA6B7F.10404@walsimou.com>
 <1258417281.1921.1345554581@webmail.messagingengine.com>
 <20091117093330.GA24000@linux-mips.org>
Subject: Re: problem bring up initramfs and busybox
In-Reply-To: <20091117093330.GA24000@linux-mips.org>
Date: Tue, 17 Nov 2009 11:39:40 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Nov 2009 10:33 +0100, "Ralf Baechle" <ralf@linux-mips.org>
wrote:
> On Mon, Nov 16, 2009 at 06:21:21PM -0600, myuboot@fastmail.fm wrote:
> 
> > I have been struggling to bring up a MIPS 32 board with busybox with or
> > without initramfs.
> > The kernel stucks there without the shell coming up.
> > 
> > [    1.153000] nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
> > [    1.161000] ip_tables: (C) 2000-2006 Netfilter Core Team
> > [    1.167000] TCP cubic registered
> > [    1.170000] NET: Registered protocol family 17
> > [   25.971000] Freeing unused kernel memory: 1032k freed
> > [   39.969000] Algorithmics/MIPS FPU Emulator v1.5
> > 
> > 
> > What I tried here is to use initramfs with statically linked busybox.
> > The initramfs seems to be up, and runs the commands in the /init one by
> > one, and then it goes to a inifite loop in r4k_wait at
> > arch/mips/kernel/genex.S.
> 
> r4k_wait is called by the idle loop.  Which means the kernel has no
> process
> to run so runs the idle loop.  This might be because there is no other
> process left running or because all processes are waiting for I/O for
> example.  So it's not uncommon that even busy systems ocasionally briefly
> run the idle loop.  In other words, seeing the processor executing
> r4k_wait does not necessarily mean something went wrong.  In this case -
> also along with the other information you've provieded it's not obvious
> what has gone wrong.
> 
>   Ralf

According to an email from Kevin, I added a symbolic link from
switch_root to busybox. The switch_root seems to be found now based on
the execution sequence, but I got the following error - "Kernel panic -
not syncing: Attempted to kill init!". This is the same error when I
tried to start the shell without initramfs. Something must be wrong, but
I can't quite figure out.

[    9.250000] Freeing unused kernel memory: 1032k freed
[   10.463000] Algorithmics/MIPS FPU Emulator v1.5
[   41.695000] Kernel panic - not syncing: Attempted to kill init!
[   41.701000] Rebooting in 3 seconds.

Thanks for your help. Andrew

(gdb) c
Continuing.

Breakpoint 2, do_execve (filename=0x9780a000 "/init", argv=0x943dd2bc,
envp=0x943dd230, regs=0x97819e30)
    at fs/exec.c:1293
1293            retval = unshare_files(&displaced);
(gdb) c
Continuing.

Breakpoint 2, do_execve (filename=0x9780a000 "/sbin/switch_root",
argv=0x4f7450, envp=0x4f7464, regs=0x97819f30)
    at fs/exec.c:1293
1293            retval = unshare_files(&displaced);
(gdb) c
Continuing.
