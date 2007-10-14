Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbXJNTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbXJNTbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXJNTbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:31:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959AbXJNTbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:31:04 -0400
Date: Sun, 14 Oct 2007 12:31:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Milter" <davemilter@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: linux-2.6.23-mm1 crashed
Message-Id: <20071014123101.208b102b.akpm@linux-foundation.org>
In-Reply-To: <2a382c6e0710141224n2b8a47c8v1346f1a9dedc7943@mail.gmail.com>
References: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
	<2a382c6e0710141224n2b8a47c8v1346f1a9dedc7943@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(please don't top-post!  edited...)

On Sun, 14 Oct 2007 23:24:39 +0400 "Dave Milter" <davemilter@gmail.com> wrote:

> On 10/14/07, Dave Milter <davemilter@gmail.com> wrote:
> > I build linux-2.6.23-mm1 and try to boot it using qemu,
> > and it crashed with trace like this:
> > do_page_fault
> > error_code
> > lock_acquire
> > _spin_lock_irqsave
> > gdth_timeout
> > run_timer_softirq
> > __do_softirq
> > do_softirq
> >
> > I have screenshot, but have no idea, is it legal to include it, if I
> > sent copy to lkml.
> > config of kernel in attachment,
> > I apply all three patches from hot-fixes.
> >
>
> By the way, because of oops happens on early stage of boot,
> you not need any image to reproduce this bug:
> something like this will be enough:
> 1)cd /tmp/ && qemu-img create hda.img 10M
> 2)cd linux/mm/source/code
> 3)qemu -kernel arch/i386/boot/bzImage -hda /tmp/hda.img
> 
> if you add "-s" to qemu options you can after that do:
> gdb vmlinux
> $target remote localhost:1234
> $br gth_timeout
> $continue
> 

I didn't notice that qemu was involved.  Does qemu have an emulator for the
gdth hardware?  
