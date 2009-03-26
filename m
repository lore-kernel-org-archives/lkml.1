Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbZCZTPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbZCZTPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbZCZTPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:15:20 -0400
Received: from gw.goop.org ([64.81.55.164]:53664 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbZCZTPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:15:19 -0400
Message-ID: <49CBD444.70103@goop.org>
Date: Thu, 26 Mar 2009 12:15:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Subject: Re: Bug: ptrace issues under x86_64 Xen kernel 2.6.29
References: <3e8340490903252341u55abbc3aree9afc1b0a7703e6@mail.gmail.com>
In-Reply-To: <3e8340490903252341u55abbc3aree9afc1b0a7703e6@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan wrote:
> Using 2.6.29 or 2.6.28 as a 64-bit Xen domU, a number of ptrace()
> users seem to have issues with unexpected breakpoints. ltrace and gdb
> both seem to be affected, under both 64-bit and 32-bit userspace.
> 32-bit kernels do not seem to be affected. Typical symptoms look like:
>   

Thanks for the reminder.  I'd noticed it in passing, but haven't 
investigated it.

    J

> x86 li63-205:/# ltrace /bin/true
> unexpected breakpoint at 0xf7e6d89f
> unexpected breakpoint at 0xf7e60a3f
> unexpected breakpoint at 0xf7e6464f
> unexpected breakpoint at 0x804933f
> unexpected breakpoint at 0xf7ea509f
> unexpected breakpoint at 0xf7e9b1ff
> unexpected breakpoint at 0xf7efef66
> +++ exited (status 0) +++
>
> x64 li63-205:~/linux-2.6# ltrace true
> unexpected breakpoint at 0x7f3379878f1f
> unexpected breakpoint at 0x7f337986ca3f
> unexpected breakpoint at 0x7f337986fd3f
> unexpected breakpoint at 0x402bdf
> unexpected breakpoint at 0x7f33798b07bf
> unexpected breakpoint at 0x7f33798a696f
> unexpected breakpoint at 0x7f3379905e3f
> +++ exited (status 0) +++
>
> li63-205:~# gdb /bin/true
> GNU gdb 6.8-debian
> Copyright (C) 2008 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-linux-gnu"...
> (no debugging symbols found)
> (gdb) run
> Starting program: /bin/true
> (no debugging symbols found)
> (no debugging symbols found)
>
> Program received signal SIGTRAP, Trace/breakpoint trap.
> 0x00007f640680e4e7 in ?? () from /lib64/ld-linux-x86-64.so.2
> (gdb)
>
> In the specific case of the above gdb session, here is /proc/pid/maps
> from the tracee:
> 00400000-00407000 r-xp 00000000 ca:00 9531
>   /bin/true
> 00607000-00608000 rw-p 00007000 ca:00 9531
>   /bin/true
> 7f64067f9000-7f6406816000 r-xp 00000000 ca:00 1678
>   /lib/ld-2.9.so
> 7f6406a12000-7f6406a15000 rw-p 7f6406a12000 00:00 0
> 7f6406a15000-7f6406a17000 rw-p 0001c000 ca:00 1678
>   /lib/ld-2.9.so
> 7fff0ea01000-7fff0ea16000 rw-p 7ffffffea000 00:00 0                      [stack]
> 7fff0ebfe000-7fff0ebff000 r-xp 7fff0ebfe000 00:00 0                      [vdso]
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
>   [vsyscall]
>
> strace seems(?) to be unaffected.
>
> I've attached my .config, dmesg, and strace output for running ltrace
> (32-bit) on /bin/true on the affected system. Unfortunately, I'm not
> enough of a ptrace guru to interpret what the cause might be.

