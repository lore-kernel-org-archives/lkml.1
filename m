Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYGPWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYGPWA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYGPWAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:00:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:35443 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbYGPWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=bVyY7WbblncDufJyU9d8orPBlRKz3n9EW3aO+OYgnqIB1LzQsxQNAAw3XWIVBPSXP1
         YEluHkAQyiRdFjuSTylBXY+l4Lezp8U8s6qSPRl0dQoxWCQUAVR4fES8PYC1NF+yJaU8
         mTQhMWIqVQ5Ea8hQk+6atxqw+zkl7TMTGonDw=
Subject: Usage of kgdb in v2.6.26
From: ZC Miao <hellwolf.misty@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 23:00:03 +0100
Message-Id: <1216245603.3664.29.camel@hellwolf-sony.freehell.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to use the kgdb from v2.6.26, but met few problems.
I use :
1. gdb 6.8 (gdb-6.8-11.fc9.i386)
2. kernel v2.6.26 source code
3. Qemu 0.9.1 (qemu-0.9.1-5.fc9.i386)
4. Host is : 2.6.25.10-86.fc9.i686
5. Cpu : Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz


* Firstly I compile kernel 2.6.26 with kgdb support :
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y

* Then I use qemu to boot my kernel along with a rootfs that I created,
with a qemu option that makes a local tcp port a listening service as a
serial port for the emulated system. The kernel arguments I gave is :
nfsroot=192.168.200.1:/path/to/rootfs,udp,nolock ip=dhcp root=/dev/nfs
ro single kgdboc=ttyS0,115200 kgdbwait

* After the kernel loaded and boot for a while, the gdb receives a
signal and hangs the kernel :
kgdb_register_io_module (new_kgdb_io_ops=<value optimized out>)
    at /data/home/hellwolf/mydoc/prog/linux/linux-2.6/kernel/kgdb.c:1674
(gdb) 

Question 1 :
* If I type "b sys_read", and then "c", the kernel continues until I
get :

---------------------------------------------------------------
[New Thread 1]
Cannot remove breakpoints because program is no longer writable.
It might be running in another process.
Further execution is probably impossible.

Breakpoint 1, sys_read (fd=3, buf=0xbfdb31dc "", count=512)

at /data/home/hellwolf/mydoc/prog/linux/linux-2.6/fs/read_write.c:360
(gdb) 
---------------------------------------------------------------

Why "program is no longer writable" happens here?

Question 2 :
* If I directly type "c" when kgdbwait triggered. And use Sys-Rq+G to
interrupt the kernel, I will get :
---------------------------------------------------------------
[New Thread -1]

Program received signal SIGTRAP, Trace/breakpoint trap.
[Switching to Thread -1]
sysrq_handle_gdb (key=103, tty=0xc78f6400)
    at /data/home/hellwolf/mydoc/prog/linux/linux-2.6/kernel/kgdb.c:167
(gdb)  
---------------------------------------------------------------
Here if I type "c sys_read" and "c", it never actually makes any break
points, I will never receive a break from gdb.


I don't know if I made anything wrong, or I missed any important thing,
so I post here and would like to get some help from you.

Thanks. 

--
ZC Miao (hellwolf.misty@gmail.com)
Blog http://hellwolf.cublog.cn

gpg --keyserver pgp.mit.edu --recv-key 0x6B174C6F

Most people deserve each other.
		-- Shirley


