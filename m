Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbXJaGxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbXJaGxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXJaGxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:53:30 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54528 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752884AbXJaGx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:53:29 -0400
Message-ID: <393813611.31145@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 31 Oct 2007 14:53:25 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
References: <20071028152428.GJ7918@iucha.net> <E1ImlvH-0003YH-Qf@localhost> <20071030114250.GL25561@iucha.net> <E1ImpbK-0000l3-1u@localhost> <20071031000242.GP25561@iucha.net> <20071031035245.GQ25561@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031035245.GQ25561@iucha.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1In7S9-0001rv-NO@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 10:52:45PM -0500, Florin Iucha wrote:
> On Tue, Oct 30, 2007 at 07:02:42PM -0500, Florin Iucha wrote:
> > I have added the patches and started a linux kernel compilation, and
> > something really interesting happens.  I run the build with the
> > equivalent of "make -j3" and in a separate console I am watching the
> > build with 'top'.  The build consumes 98% of both CPUs.  If I stop the
> > output in the build console with "Ctrl-S", one core goes to idle,
> > while the other is in 50% waiting, then goes to 75% waiting.  When I
> > resume the build with "Ctrl-Q", the build starts to use both CPUs at
> > 98-99%.  The NFS4 use was minimal, as I did not login with Gnome, but
> > just logged on the console.  Also, the CPU that is in 75% waiting
> > state changes occasionally.  'Top' shows pdflush in D state, using
> > 5-6% of CPU.
> 
> I forgot the traces:
> 
>    http://iucha.net/2.6.24-rc1/fw.1.gz
>    http://iucha.net/2.6.24-rc1/fw.2.gz
>    http://iucha.net/2.6.24-rc1/fw.3.gz

Sorry for the delay - I've been fixing our server today.

[  263.685691] mm/page-writeback.c 655 wb_kupdate: pdflush(248) 24235 global 4593 0 0 wc _M tw 1024 sk 0
[  263.789648] requeue_io 301: inode 4031199 size 562 at 08:07(sda7)
[  263.789656] requeue_io 301: inode 4031231 size 329 at 08:07(sda7)
[  263.789660] requeue_io 301: inode 4031255 size 177 at 08:07(sda7)
[  263.789664] requeue_io 301: inode 4031268 size 94 at 08:07(sda7)
[  263.789667] requeue_io 301: inode 4031329 size 88 at 08:07(sda7)
[  263.789671] requeue_io 301: inode 4031351 size 74 at 08:07(sda7)
[  263.789674] requeue_io 301: inode 4031408 size 175 at 08:07(sda7)
[  263.789678] requeue_io 301: inode 4031413 size 129 at 08:07(sda7)
[  263.789681] requeue_io 301: inode 4031415 size 391 at 08:07(sda7)
[  263.789690] mm/page-writeback.c 655 wb_kupdate: pdflush(248) 24235 global 4593 0 0 wc _M tw 1024 sk 0
[  263.890184] requeue_io 301: inode 4031199 size 562 at 08:07(sda7)
[  263.890191] requeue_io 301: inode 4031231 size 329 at 08:07(sda7)
[  263.890195] requeue_io 301: inode 4031255 size 177 at 08:07(sda7)
[  263.890198] requeue_io 301: inode 4031268 size 94 at 08:07(sda7)
[  263.890202] requeue_io 301: inode 4031329 size 88 at 08:07(sda7)
[  263.890205] requeue_io 301: inode 4031351 size 74 at 08:07(sda7)
[  263.890208] requeue_io 301: inode 4031408 size 175 at 08:07(sda7)
[  263.890212] requeue_io 301: inode 4031413 size 129 at 08:07(sda7)
[  263.890215] requeue_io 301: inode 4031415 size 391 at 08:07(sda7)
[  263.890223] mm/page-writeback.c 655 wb_kupdate: pdflush(248) 24235 global 4593 0 0 wc _M tw 1024 sk 0

It's about sda7, not NFSv4.

Is it a Reiserfs? We have a fresh fix for it: http://lkml.org/lkml/2007/10/23/93

Thank you,
Fengguang

