Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZKJGzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZKJGzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 01:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZKJGzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 01:55:50 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43285 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZKJGzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 01:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=NfMFjp7cgiJYldrruw/xVGd7k5Y0b8iskBcGc//isto8nFJZ/Pf0O6HAqkXuQzKAt3
         s5BvfqOjZFsWN7LRWDbkyNjYdo11IorsdPkQB5ld75jH4Ki+q4pVxeyaAjAIZm+ksah7
         GIyomnmB5N7QW+pwXXMWZPrPc4YQ740hGadEE=
MIME-Version: 1.0
Date: Tue, 10 Nov 2009 14:55:54 +0800
Message-ID: <7d98bfeb0911092255j1923ff6evafd9d40ee317d1d3@mail.gmail.com>
Subject: problems of using the 2.6.26 Linux Kernel Debugger (KGDB) with VMware
From: min li <fly.limin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone:
Recently I was using kgdb and VMware workstation to debug linux kernel 2.6.26.
I compiled and install kgdb according to the following webpage£º
http://jaredrobinson.com/blog/using-the-2626-linux-kernel-debugger-kgdb-with-vmware/

But I still have some problems£º
When I start gdb like£ºgdb ./vmliunx, it shows£º

[root@localhost linux-2.6.26]# gdb ./vmlinux
GNU gdb Red Hat Linux (6.6-35.fc8rh)
Copyright (C) 2006 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "i386-redhat-linux-gnu"...
Using host libthread_db library "/lib/libthread_db.so.1".
(gdb) set remotebaud 115200
(gdb) target remote /dev/ttyS0
Remote debugging using /dev/ttyS0
warning: shared library handler failed to enable breakpoint
0xc045516d in ?? ()

Then I type "n", it shows£º
(gdb) n
Cannot find bounds of current function

I simply realize the output "0xc045516d in ?? ()" is different from
common output
"breakpoint () at kernel/kgdb.c:1212
1212:atomic_set(&kgdb_setting_breakpoint, 0);" which I found on some webpages

The real problem is that when I set breakpoints at like "sys_open",
"sys_getdents64", the kernel execution didn't stop at that point.
But if I "echo g > /proc/sysrq-trigger " in target machine, it can
stop running. In the development machine, I still only can send
"continue" command to make the target run again, if I send "next"
command, it shows just like above.

Does anybody confront this kind of problems, please give me some
suggestions, I really appreciate that!

--
Min Li
School of Computer Science and Technology
Cluster and Grid Computing Lab
Services Computing Technology and System Lab
Huazhong University of Science and Technology
Wuhan, 430074, China
Tel: +86-139-8625-1431
Email: fly.limin@gmail.com
