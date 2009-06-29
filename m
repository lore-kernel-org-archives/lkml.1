Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZF2Gfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZF2Gfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZF2Gfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:35:39 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:52857 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZF2Gfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Awui++T3SZNxLclyENyuDA9MIBR65nY5y2j3qGhqERLFqQdxaDEcWD+tD+1xjH54cI
         tm0B//y44Izfof4CDsqw5hQAJMJtcpZ9cT0PHiS3lE51fNWu7t/i1J6oYYQR2Wnwet1i
         Xhlw0E3+Mht4HQJZ/lpALhWWY+uyexCZ4VP9w=
MIME-Version: 1.0
In-Reply-To: <20090627164258.GE8633@ZenIV.linux.org.uk>
References: <40a4ed590906252356i574f0da4jc3763cfc9f0f65f6@mail.gmail.com>
	 <20090626071520.GC8633@ZenIV.linux.org.uk>
	 <20090626073919.GD8633@ZenIV.linux.org.uk>
	 <40a4ed590906270410o9e17587p68a2d688b551b667@mail.gmail.com>
	 <20090627164258.GE8633@ZenIV.linux.org.uk>
Date: Mon, 29 Jun 2009 08:35:39 +0200
Message-ID: <40a4ed590906282335n45ff68fas78deee1bd046c67c@mail.gmail.com>
Subject: Re: 2.6.31-rc1 crashes randomly on my Machine.
From: Zeno Davatz <zdavatz@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Al

On Sat, Jun 27, 2009 at 6:42 PM, Al Viro<viro@zeniv.linux.org.uk> wrote:
> On Sat, Jun 27, 2009 at 01:10:46PM +0200, Zeno Davatz wrote:
>> > which is at least not entirely implausible. ?So it seems to be a memory
>> > corruption in .text, which might or might not affect the directly
>> > preceding bytes (0xe9 <signed 32bit int> is a relative jump, so there's
>> > no way to tell whether this 0xff had been the only byte affected - it
>> > would be preceded by 3 0xff coming from small negative integer anyway).
>>
>> I just done another pull from the Git repository of Linus and booted
>> from the latest 2.6.31-rc1 and my Machine still hangs after boot up,
>> with the following message at the end in /var/log/messages
>>
>> Jun 27 03:01:52 zenogentoo Stack:
>> Jun 27 03:01:52 zenogentoo c10d14f2 f2eb9f5c c10ab407 00000400
>> b8033000 f6b43d80 f33cbe28 00000000
>> Jun 27 03:01:52 zenogentoo <0> 00000000 f65c9000 00001000 00000000
>> 00000000 00000000 f721a100 fffffffb
>> Jun 27 03:01:52 zenogentoo <0> c10d13e5 f2eb9f64 c10f1522 f2eb9f98
>> 00000400 b8033000 f6b43d80 f6b43d80
>> Jun 27 03:01:52 zenogentoo Call Trace:
>> Jun 27 03:01:52 zenogentoo [<c10d14f2>] ? seq_read+0x10d/0x3a5
>> Jun 27 03:01:52 zenogentoo [<c10ab407>] ? mmap_region+0x1bf/0x41a
>> Jun 27 03:01:52 zenogentoo [<c10d13e5>] ? seq_read+0x0/0x3a5
>> Jun 27 03:01:52 zenogentoo [<c10f1522>] ? proc_reg_read+0x57/0x78
>> Jun 27 03:01:52 zenogentoo [<c10bb257>] ? vfs_read+0x8b/0x141
>> Jun 27 03:01:52 zenogentoo [<c10f14cb>] ? proc_reg_read+0x0/0x78
>> Jun 27 03:01:52 zenogentoo [<c10bb3b6>] ? sys_read+0x3d/0x6b
>> Jun 27 03:01:52 zenogentoo [<c1021290>] ? sysenter_do_call+0x12/0x2c
>> Jun 27 03:01:52 zenogentoo Code: 0b fc f6 50 0b fc f6 01 00 00 00 00
>> 00 00 00 60 0b fc f6 60 0b fc f6 00 00 00 00 00 00 00 00 00 00 00 00
>> 08 00 00 00 00 00 00 00 <ff> ff ff ff ff ff ff ff 00 00 00 00 00 00 00
>> 00 00 00 00 00 00
>> Jun 27 03:01:52 zenogentoo EIP: [<f6fc0b7c>] 0xf6fc0b7c SS:ESP 0068:f2eb9efc
>> Jun 27 03:01:52 zenogentoo ---[ end trace 1b3422263ead727b ]---
>
> Jumped to nowhere.  For one thing, 0xf6fc0b7c is nowhere near the addresses
> where the kernel code would live.  For another, the contents of memory at
> that address doesn't look code (a lot of 0, a lot of 0xff *and* several
> 32bit values that look like addresses nearby (0xf6fc0b50, 0xf6fc0b60).
> IOW, some data structures; hell knows what it might have been, but we
> have seq_read() seeing m->op->start that points somewhere strange.
>
> Again, memory corruption of some kind.  We have file->private_data that
> might have been screwed up, or it might have been right pointer, but
> the struct seq_file it points had been overwritten with some crap, or
> that might have happened to the methods table ->op of that seq_file points
> to...
>
> Having looked at what seq_read() has compiled to in your kernel... what's
> the value of ECX in that oops?  That's where m->op ends up and a look at
> that sucker might at least narrow it down.

My ECX Values are:

Jun 25 21:19:12 zenogentoo EAX: f6b70400 EBX: f7279d00 ECX: 00000400
EDX: b7fb9000
Jun 25 21:19:12 zenogentoo ESI: fffffffb EDI: c10d1d35 EBP: f635df64
ESP: f635df44
Jun 25 21:19:12 zenogentoo DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 25 21:19:12 zenogentoo Process sh (pid: 2961, ti=f635c000
task=f64edb60 task.ti=f635c000)
Jun 25 21:19:12 zenogentoo Stack:
Jun 25 21:19:12 zenogentoo c10f29e2 f635df98 00000400 b7fb9000
f6b70400 f6b70400 b7fb9000 00000400
Jun 25 21:19:12 zenogentoo <0> f635df8c c10bbb37 f635df98 00000000
f64cd500 00000073 c10f298b f6b70400
Jun 25 21:19:12 zenogentoo <0> fffffff7 00000000 f635dfac c10bbc96
f635df98 00000000 00000000 00000000
Jun 25 21:19:12 zenogentoo Call Trace:
Jun 25 21:19:12 zenogentoo [<c10f29e2>] ? proc_reg_read+0x57/0x78
Jun 25 21:19:12 zenogentoo [<c10bbb37>] ? vfs_read+0x8b/0x141
Jun 25 21:19:12 zenogentoo [<c10f298b>] ? proc_reg_read+0x0/0x78
Jun 25 21:19:12 zenogentoo [<c10bbc96>] ? sys_read+0x3d/0x6b
Jun 25 21:19:12 zenogentoo [<c1021290>] ? sysenter_do_call+0x12/0x2c
Jun 25 21:19:12 zenogentoo Code: 00 00 00 c7 47 20 00 00 00 00 c7 47
24 00 00 00 00 c7 47 10 00 00 00 00 c7 47 14 00 00 00 00 c7 47 0c 00
00 00 00 e9 27 ff ff ff <ff> 89 e5 57 56 53 83 ec 34 89 45 d0 89 55 cc
89 4d c8 8b 70 6c
Jun 25 21:19:12 zenogentoo EIP: [<c10d1d35>] seq_read+0x0/0x3a5 SS:ESP
0068:f635df44
Jun 25 21:19:12 zenogentoo CR2: 0000000053565be5
Jun 25 21:19:12 zenogentoo ---[ end trace 6254fef9dc80950c ]---

Jun 27 03:01:52 zenogentoo EAX: f33cbe00 EBX: fffffff4 ECX: f6077f20
EDX: f2eb9f2c
Jun 27 03:01:52 zenogentoo ESI: f33cbe00 EDI: c10d13e5 EBP: f2eb9f40
ESP: f2eb9efc
Jun 27 03:01:52 zenogentoo DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 27 03:01:52 zenogentoo Process sh (pid: 2889, ti=f2eb8000
task=f691ebe0 task.ti=f2eb8000)
Jun 27 03:01:52 zenogentoo Stack:
Jun 27 03:01:52 zenogentoo c10d14f2 f2eb9f5c c10ab407 00000400
b8033000 f6b43d80 f33cbe28 00000000
Jun 27 03:01:52 zenogentoo <0> 00000000 f65c9000 00001000 00000000
00000000 00000000 f721a100 fffffffb
Jun 27 03:01:52 zenogentoo <0> c10d13e5 f2eb9f64 c10f1522 f2eb9f98
00000400 b8033000 f6b43d80 f6b43d80
Jun 27 03:01:52 zenogentoo Call Trace:
Jun 27 03:01:52 zenogentoo [<c10d14f2>] ? seq_read+0x10d/0x3a5
Jun 27 03:01:52 zenogentoo [<c10ab407>] ? mmap_region+0x1bf/0x41a
Jun 27 03:01:52 zenogentoo [<c10d13e5>] ? seq_read+0x0/0x3a5
Jun 27 03:01:52 zenogentoo [<c10f1522>] ? proc_reg_read+0x57/0x78
Jun 27 03:01:52 zenogentoo [<c10bb257>] ? vfs_read+0x8b/0x141
Jun 27 03:01:52 zenogentoo [<c10f14cb>] ? proc_reg_read+0x0/0x78
Jun 27 03:01:52 zenogentoo [<c10bb3b6>] ? sys_read+0x3d/0x6b
Jun 27 03:01:52 zenogentoo [<c1021290>] ? sysenter_do_call+0x12/0x2c
Jun 27 03:01:52 zenogentoo Code: 0b fc f6 50 0b fc f6 01 00 00 00 00
00 00 00 60 0b fc f6 60 0b fc f6 00 00 00 00 00 00 00 00 00 00 00 00
08 00 00 00 00 00 00 00 <ff> ff ff ff ff ff ff ff 00 00 00 00 00 00 00
00 00 00 00 00 00
Jun 27 03:01:52 zenogentoo EIP: [<f6fc0b7c>] 0xf6fc0b7c SS:ESP 0068:f2eb9efc
Jun 27 03:01:52 zenogentoo ---[ end trace 1b3422263ead727b ]---


Jun 27 03:01:52 zenogentoo EAX: f33cbe00 EBX: fffffff4 ECX: f6077f20
EDX: f2ebdf2c
Jun 27 03:01:52 zenogentoo ESI: f33cbe00 EDI: c10d13e5 EBP: f2ebdf40
ESP: f2ebdefc
Jun 27 03:01:52 zenogentoo DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 27 03:01:52 zenogentoo Process xmessage (pid: 2891, ti=f2ebc000
task=f71bb440 task.ti=f2ebc000)
Jun 27 03:01:52 zenogentoo Stack:
Jun 27 03:01:52 zenogentoo c10d14f2 f2ebdf5c c10ab407 00000400
b801f000 f6b20b80 f33cbe28 00000000
Jun 27 03:01:52 zenogentoo <0> 00000000 f65c9000 00001000 00000000
00000000 00000000 f721a100 fffffffb
Jun 27 03:01:52 zenogentoo <0> c10d13e5 f2ebdf64 c10f1522 f2ebdf98
00000400 b801f000 f6b20b80 f6b20b80
Jun 27 03:01:52 zenogentoo Call Trace:
Jun 27 03:01:52 zenogentoo [<c10d14f2>] ? seq_read+0x10d/0x3a5
Jun 27 03:01:52 zenogentoo [<c10ab407>] ? mmap_region+0x1bf/0x41a
Jun 27 03:01:52 zenogentoo [<c10d13e5>] ? seq_read+0x0/0x3a5
Jun 27 03:01:52 zenogentoo [<c10f1522>] ? proc_reg_read+0x57/0x78
Jun 27 03:01:52 zenogentoo [<c10bb257>] ? vfs_read+0x8b/0x141
Jun 27 03:01:52 zenogentoo [<c10f14cb>] ? proc_reg_read+0x0/0x78
Jun 27 03:01:52 zenogentoo [<c10bb3b6>] ? sys_read+0x3d/0x6b
Jun 27 03:01:52 zenogentoo [<c1021290>] ? sysenter_do_call+0x12/0x2c
Jun 27 03:01:52 zenogentoo Code: 0b fc f6 50 0b fc f6 01 00 00 00 00
00 00 00 60 0b fc f6 60 0b fc f6 00 00 00 00 00 00 00 00 00 00 00 00
08 00 00 00 00 00 00 00 <ff> ff ff ff ff ff ff ff 00 00 00 00 00 00 00
00 00 00 00 00 00
Jun 27 03:01:52 zenogentoo EIP: [<f6fc0b7c>] 0xf6fc0b7c SS:ESP 0068:f2ebdefc
Jun 27 03:01:52 zenogentoo ---[ end trace 1b3422263ead727c ]---

Jun 27 13:02:32 zenogentoo EAX: f695cc00 EBX: f6077f20 ECX: 00000002
EDX: 00000100
Jun 27 13:02:32 zenogentoo ESI: f7002540 EDI: 00000000 EBP: f707bf50
ESP: f707bf34
Jun 27 13:02:32 zenogentoo DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jun 27 13:02:32 zenogentoo Process events/1 (pid: 11, ti=f707a000
task=f7059130 task.ti=f707a000)
Jun 27 13:02:32 zenogentoo Stack:
Jun 27 13:02:32 zenogentoo 00000002 f7000a00 f7002564 f7002550
f7002540 f7000a00 c2686660 f707bf70
Jun 27 13:02:32 zenogentoo <0> c10b509e 00000000 00000000 f707bf70
c2689600 c2686660 f7059130 f707bfb8
Jun 27 13:02:32 zenogentoo <0> c105f8a7 c2688f80 00000001 fffedb31
c2684e00 c268960c c2689604 c2689600
Jun 27 13:02:32 zenogentoo Call Trace:
Jun 27 13:02:32 zenogentoo [<c10b509e>] ? cache_reap+0xbf/0xe9
Jun 27 13:02:32 zenogentoo [<c105f8a7>] ? worker_thread+0x158/0x23b
Jun 27 13:02:32 zenogentoo [<c10b4fdf>] ? cache_reap+0x0/0xe9
Jun 27 13:02:32 zenogentoo [<c1063a8f>] ? autoremove_wake_function+0x0/0x3a
Jun 27 13:02:32 zenogentoo [<c105f74f>] ? worker_thread+0x0/0x23b
Jun 27 13:02:32 zenogentoo [<c106376c>] ? kthread+0x6f/0x75
Jun 27 13:02:32 zenogentoo [<c10636fd>] ? kthread+0x0/0x75
Jun 27 13:02:32 zenogentoo [<c1021da7>] ? kernel_thread_helper+0x7/0x10
Jun 27 13:02:32 zenogentoo Code: 56 53 83 ec 10 89 45 e8 89 d6 89 4d
e4 85 c9 7e 79 8d 42 10 89 45 f0 3b 42 10 74 6e 8d 52 24 89 55 ec 31
ff eb 42 8b 13 8b 43 04 <89> 42 04 89 10 c7 03 00 01 10 00 c7 43 04 00
02 20 00 8b 55 e8
Jun 27 13:02:32 zenogentoo EIP: [<c10b4f7c>] drain_freelist+0x2f/0x92
SS:ESP 0068:f707bf34
Jun 27 13:02:32 zenogentoo CR2: 0000000000000104
Jun 27 13:02:32 zenogentoo ---[ end trace 1b3422263ead727d ]---

I got a lot of the

ECX: 00000400

values around the hanging.

Best
Zeno
