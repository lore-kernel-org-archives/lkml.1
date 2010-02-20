Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0BTN6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 08:58:18 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0BTN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 08:58:14 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100220135122.GB3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664814.11514.5.camel@jlt3.sipsolutions.net>
	 <20100220135122.GB3000@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 14:58:11 +0100
Message-ID: <1266674291.18465.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 21:51 +0800, Américo Wang wrote:

> >BUG: key c0000002165eb478 not in .data!
> >
> >instead of the lockdep complaint above.
> >
> 
> I am not surprised. :)
> 
> Please send us the backtraces you got, we could expect this.

I hacked in dump_stack() but it overflowed my log buffer, here's an example:

[   31.625411] BUG: key c0000002134f2ab0 not in .data!
[   31.625414] Call Trace:
[   31.625417] [c000000213b677c0] [c000000000012c1c] .show_stack+0xc0/0x200 (unreliable)
[   31.625423] [c000000213b67890] [c0000000005ac968] .dump_stack+0x28/0x3c
[   31.625428] [c000000213b67910] [c0000000000b6a3c] .lockdep_init_map+0x11c/0x674
[   31.625433] [c000000213b67a10] [c0000000001efd90] .sysfs_add_file_mode+0x90/0x124
[   31.625438] [c000000213b67ad0] [c0000000001efe60] .sysfs_add_file+0x3c/0x50
[   31.625442] [c000000213b67b70] [c0000000001f2f40] .sysfs_create_bin_file+0x5c/0x78
[   31.625448] [c000000213b67c10] [c0000000000cd0b0] .load_module+0x16a4/0x197c
[   31.625452] [c000000213b67d80] [c0000000000cd424] .SyS_init_module+0x9c/0x2d4
[   31.625457] [c000000213b67e30] [c0000000000075d4] syscall_exit+0x0/0x40

There's also
[   34.776604] BUG: key c000000216265388 not in .data!
[   34.776606] Call Trace:
[   34.776609] [c000000213b5f7a0] [c000000000012c1c] .show_stack+0xc0/0x200 (unreliable)
[   34.776615] [c000000213b5f870] [c0000000005ac968] .dump_stack+0x28/0x3c
[   34.776620] [c000000213b5f8f0] [c0000000000b6a3c] .lockdep_init_map+0x11c/0x674
[   34.776624] [c000000213b5f9f0] [c0000000001efd90] .sysfs_add_file_mode+0x90/0x124
[   34.776629] [c000000213b5fab0] [c0000000001f32b4] .internal_create_group+0x168/0x24c
[   34.776634] [c000000213b5fb70] [c0000000001f3420] .sysfs_create_group+0x38/0x50
[   34.776639] [c000000213b5fc10] [c0000000000ccf20] .load_module+0x1514/0x197c
[   34.776644] [c000000213b5fd80] [c0000000000cd424] .SyS_init_module+0x9c/0x2d4
[   34.776649] [c000000213b5fe30] [c0000000000075d4] syscall_exit+0x0/0x40

and many many times...

Let me recompile with that dump_stack() removed.

johannes

