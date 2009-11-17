Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZKQRui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZKQRui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZKQRuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:50:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:18286 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZKQRug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:50:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Q+EbWJ+ux2DlbpipnzWEUlHwKfhI5xLDvsYj7mY8INUP5XD9JgOyrZzfIQeaJpQF6l
         dJomwDQkZ9PoFDcIPitChh9pxxCoxymFOePRZStuFgscdYsAvReuGmIYmySzn/5k+fuv
         dCCcfjfk3HCcz3VgG1xhWvTqyZ4zufGsFsxKI=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: myuboot@fastmail.fm
Subject: Re: problem bring up initramfs and busybox
Date: Tue, 17 Nov 2009 18:48:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-server; KDE/4.3.2; x86_64; ; )
Cc: "Ralf Baechle" <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       "linux-mips" <linux-mips@linux-mips.org>
References: <1255735395.30097.1340523469@webmail.messagingengine.com> <20091117093330.GA24000@linux-mips.org> <1258479580.17116.1345691629@webmail.messagingengine.com>
In-Reply-To: <1258479580.17116.1345691629@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911171848.44137.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 17 November 2009 18:39:40 myuboot@fastmail.fm wrote:
> On Tue, 17 Nov 2009 10:33 +0100, "Ralf Baechle" <ralf@linux-mips.org>
> 
> wrote:
> > On Mon, Nov 16, 2009 at 06:21:21PM -0600, myuboot@fastmail.fm wrote:
> > > I have been struggling to bring up a MIPS 32 board with busybox with or
> > > without initramfs.
> > > The kernel stucks there without the shell coming up.
> > >
> > > [    1.153000] nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
> > > [    1.161000] ip_tables: (C) 2000-2006 Netfilter Core Team
> > > [    1.167000] TCP cubic registered
> > > [    1.170000] NET: Registered protocol family 17
> > > [   25.971000] Freeing unused kernel memory: 1032k freed
> > > [   39.969000] Algorithmics/MIPS FPU Emulator v1.5
> > >
> > >
> > > What I tried here is to use initramfs with statically linked busybox.
> > > The initramfs seems to be up, and runs the commands in the /init one by
> > > one, and then it goes to a inifite loop in r4k_wait at
> > > arch/mips/kernel/genex.S.
> >
> > r4k_wait is called by the idle loop.  Which means the kernel has no
> > process
> > to run so runs the idle loop.  This might be because there is no other
> > process left running or because all processes are waiting for I/O for
> > example.  So it's not uncommon that even busy systems ocasionally briefly
> > run the idle loop.  In other words, seeing the processor executing
> > r4k_wait does not necessarily mean something went wrong.  In this case -
> > also along with the other information you've provieded it's not obvious
> > what has gone wrong.
> >
> >   Ralf
> 
> According to an email from Kevin, I added a symbolic link from
> switch_root to busybox. The switch_root seems to be found now based on
> the execution sequence, but I got the following error - "Kernel panic -
> not syncing: Attempted to kill init!". This is the same error when I
> tried to start the shell without initramfs. Something must be wrong, but
> I can't quite figure out.
> 
> [    9.250000] Freeing unused kernel memory: 1032k freed
> [   10.463000] Algorithmics/MIPS FPU Emulator v1.5
> [   41.695000] Kernel panic - not syncing: Attempted to kill init!
> [   41.701000] Rebooting in 3 seconds.
> 
> Thanks for your help. Andrew
> 
> (gdb) c
> Continuing.
> 
> Breakpoint 2, do_execve (filename=0x9780a000 "/init", argv=0x943dd2bc,
> envp=0x943dd230, regs=0x97819e30)
>     at fs/exec.c:1293
> 1293            retval = unshare_files(&displaced);
> (gdb) c
> Continuing.
> 
> Breakpoint 2, do_execve (filename=0x9780a000 "/sbin/switch_root",
> argv=0x4f7450, envp=0x4f7464, regs=0x97819f30)
>     at fs/exec.c:1293
> 1293            retval = unshare_files(&displaced);
> (gdb) c
> Continuing.

If you happen to use uClibc and gcc-4.4.0 or superior, make sure that you have 
that patch applied to uClibc: http://www.mail-
archive.com/uclibc@uclibc.org/msg04483.html
--
WBR, Florian
