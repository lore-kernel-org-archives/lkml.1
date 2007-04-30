Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbXD3POP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbXD3POP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbXD3POO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:14:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37472 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbXD3POM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:14:12 -0400
Date: Mon, 30 Apr 2007 08:16:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 hangs in boot
Message-Id: <20070430081653.60fab0a5.randy.dunlap@oracle.com>
In-Reply-To: <20070429222354.63265e3f.akpm@linux-foundation.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070429220132.951cdf7f.randy.dunlap@oracle.com>
	<20070429222354.63265e3f.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 22:23:54 -0700 Andrew Morton wrote:

> On Sun, 29 Apr 2007 22:01:32 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Wed, 25 Apr 2007 22:57:16 -0700 Andrew Morton wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/
> > 
> > I'm getting a hang near the end of booting on x86_64 UP.
> > The last initcall_debug function varies.  E.g.:
> > 
> > 1/
> > [    0.140257] Calling initcall 0xffffffff806f2fa8: init_misc_binfmt+0x0/0x3f()
> > [    0.140266] initcall 0xffffffff806f2fa8: init_misc_binfmt+0x0/0x3f() returned 0.
> > [    0.140275] initcall 0xffffffff806f2fa8 ran for 0 msecs: init_misc_binfmt+0x0/0x3f()
> > [    0.140284] Calling initcall 0xffffffff806f2fe7: init_script_binfmt+0x0/0x12()
> > [    0.140293] initcall 0xffffffff806f2fe7: init_script_binfmt+0x0/0x12() returned 0.
> > [    0.140302] initcall 0xffffffff806f2fe7 ran for 0 msecs: init_script_binfmt+0x0/0x12()
> > [    0.140310] Calling initcall 0xffffffff806f2ff9: init_elf_binfmt+0x0/0x12()
> > [    0.140317] initcall 0xffffffff806f2ff9: init_elf_binfmt+0x0/0x12() returned 0.
> > [    0.140326] initcall 0xffffffff806f2ff9 ran for 0 msecs: init_elf_binfmt+0x0/0x12()
> > [    0.140335] Calling initcall 0xffffffff806f3de9: debugfs_init+0x0/0x4a()
> > [    0.140344] initcall 0xffffffff806f3de9: debugfs_init+0x0/0x4a() returned 0.
> > [    0.140351] initcall 0xffffffff806f3de9 ran for 0 msecs: debugfs_init+0x0/0x4a()
> > 
> > 2/
> > [    0.140206] Calling initcall 0xffffffff806efeb1: ksysfs_init+0x0/0x29()
> > [    0.140215] initcall 0xffffffff806efeb1: ksysfs_init+0x0/0x29() returned 0.
> > [    0.140222] initcall 0xffffffff806efeb1 ran for 0 msecs: ksysfs_init+0x0/0x29()
> > [    0.140230] Calling initcall 0xffffffff806f25be: filelock_init+0x0/0x31()
> > [    0.140242] initcall 0xffffffff806f25be: filelock_init+0x0/0x31() returned 0.
> > [    0.140249] initcall 0xffffffff806f25be ran for 0 msecs: filelock_init+0x0/0x31()
> > [    0.140258] Calling initcall 0xffffffff806f2fa8: init_misc_binfmt+0x0/0x3f()
> > [    0.140266] initcall 0xffffffff806f2fa8: init_misc_binfmt+0x0/0x3f() returned 0.
> > [    0.140276] initcall 0xffffffff806f2fa8 ran for 0 msecs: init_misc_binfmt+0x0/0x3f()
> > [    0.140284] Calling initcall 0xffffffff806f2fe7: init_script_binfmt+0x0/0x12()
> > [    0.140293] initcall 0xffffffff806f2fe7: init_script_binfmt+0x0/0x12() returned 0.
> > 
> 
> So perhaps it locks during a timer interrupt.
> 
> > .config is attached.
> > 
> > Any ideas/suggestions?
> 
> Just the usual: nothing from sysrq or NMI watchdog?

Nothing from either of those.  I'll jiggle some config options.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
